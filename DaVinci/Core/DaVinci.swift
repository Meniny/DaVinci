//
//  DaVinci.swift
//  DaVinci
//
//  Created by Meniny on 2018-05-19.
//

#if os(macOS)
import AppKit

public typealias DaVinciImage = NSImage
public typealias DaVincColor = NSColor
public typealias DaVincBezierPath = NSBezierPath
#else
import UIKit

public typealias DaVinciImage = UIImage
public typealias DaVincColor = UIColor
public typealias DaVincBezierPath = UIBezierPath
#endif

public typealias DaVinciDrawingClosure = (_ context: CGContext) -> Swift.Void

/**
 DaVinci - Fabulous Image Processing in Swift.
 
 The DaVinci class provides two methods of interaction - either through an instance, wrapping an single image,
 or through the static functions, providing an image for each invocation.
 
 This allows for some flexible usage. Using static methods when you need a single operation:
 let resizedImage = DaVinci.resize(myImage, size: CGSize(width: 100, height: 150))
 
 Or create an instance for easy method chaining:
 let resizedAndMaskeredImage = DaVinci(withImage: myImage).resize(CGSize(width: 100, height: 150)).maskWithEllipse().image
 */
public class DaVinci: NSObject {
    public var image: DaVinciImage?
    
    public init(image withImage: DaVinciImage) {
        self.image = withImage
    }
}

#if !os(macOS)
// MARK: - Resizer
public extension DaVinci {
    
    /**
     Resize the contained image to the specified size. Depending on what fitMode is supplied, the image
     may be clipped, cropped or scaled. @see documentation on FitMode.
     
     The current image on this toucan instance is replaced with the resized image.
     
     - parameter size: Size to resize the image to
     - parameter fitMode: How to handle the image resizing process
     
     - returns: Self, allowing method chaining
     */
    public func resize(to size: CGSize, fitMode: DaVinci.Resizer.FitMode = .clip) -> DaVinci {
        if let image = self.image {
            self.image = DaVinci.Resizer.resizeImage(image, size: size, fitMode: fitMode)
        }
        return self
    }
    
    /**
     Resize the contained image to the specified size by resizing the image to fit
     within the width and height boundaries without cropping or scaling the image.
     
     The current image on this toucan instance is replaced with the resized image.
     
     - parameter size: Size to resize the image to
     
     - returns: Self, allowing method chaining
     */
    @objc
    public func resize(clipping size: CGSize) -> DaVinci {
        if let image = self.image {
            self.image = DaVinci.Resizer.resizeImage(image, size: size, fitMode: .clip)
        }
        return self
    }
    
    /**
     Resize the contained image to the specified size by resizing the image to fill the
     width and height boundaries and crops any excess image data.
     The resulting image will match the width and height constraints without scaling the image.
     
     The current image on this toucan instance is replaced with the resized image.
     
     - parameter size: Size to resize the image to
     
     - returns: Self, allowing method chaining
     */
    @objc
    public func resize(cropping size: CGSize) -> DaVinci {
        if let image = self.image {
            self.image = DaVinci.Resizer.resizeImage(image, size: size, fitMode: .crop)
        }
        return self
    }
    
    /**
     Resize the contained image to the specified size by scaling the image to fit the
     constraining dimensions exactly.
     
     The current image on this toucan instance is replaced with the resized image.
     
     - parameter size: Size to resize the image to
     
     - returns: Self, allowing method chaining
     */
    @objc
    public func resize(scaling size: CGSize) -> DaVinci {
        if let image = self.image {
            self.image = DaVinci.Resizer.resizeImage(image, size: size, fitMode: .scale)
        }
        return self
    }
    
    /**
     Container struct for all things Resizer related
     */
    public struct Resizer {
        
        /**
         FitMode drives the resizing process to determine what to do with an image to
         make it fit the given size bounds.
         
         - Clip:  Resizers the image to fit within the width and height boundaries without cropping or scaling the image.
         
         - Crop:  Resizers the image to fill the width and height boundaries and crops any excess image data.
         
         - Scale: Scales the image to fit the constraining dimensions exactly.
         */
        public enum FitMode {
            /**
             Resize the image to fit within the width and height boundaries without cropping or scaling the image.
             The resulting image is assured to match one of the constraining dimensions, while
             the other dimension is altered to maintain the same aspect ratio of the input image.
             */
            case clip
            
            /**
             Resize the image to fill the width and height boundaries and crops any excess image data.
             The resulting image will match the width and height constraints without scaling the image.
             */
            case crop
            
            /**
             Scales the image to fit the constraining dimensions exactly.
             */
            case scale
        }
        
        /**
         Resize an image to the specified size. Depending on what fitMode is supplied, the image
         may be clipped, cropped or scaled. @see documentation on FitMode.
         
         - parameter image:   Image to resize
         - parameter size:    Size to resize the image to
         - parameter fitMode: How to handle the image resizing process
         
         - returns: Resizerd image
         */
        public static func resizeImage(_ image: DaVinciImage, size: CGSize, fitMode: FitMode = .clip) -> DaVinciImage? {
            
            guard let imgRef = ToolBox.CGImageWithCorrectOrientation(image) else {
                return nil
            }
            let originalWidth  = CGFloat(imgRef.width)
            let originalHeight = CGFloat(imgRef.height)
            let widthRatio = size.width / originalWidth
            let heightRatio = size.height / originalHeight
            
            let scaleRatio = fitMode == .clip ? min(heightRatio, widthRatio): max(heightRatio, widthRatio)
            
            let resizedImageBounds = CGRect(x: 0, y: 0, width: round(originalWidth * scaleRatio), height: round(originalHeight * scaleRatio))
            let resizedImage = ToolBox.drawImage(image, bounds: resizedImageBounds)
            guard let resized = resizedImage else {
                return nil
            }
            
            switch (fitMode) {
            case .clip:
                return resized
            case .crop:
                let croppedRect = CGRect(x: (resized.size.width - size.width) / 2,
                                         y: (resized.size.height - size.height) / 2,
                                         width: size.width, height: size.height)
                return ToolBox.croppedImage(from: resized, rect: croppedRect)
            case .scale:
                return ToolBox.drawImage(resized, bounds: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            }
        }
    }
}

// MARK: - Masker
public extension DaVinci {
    
    /**
     Maske the contained image with another image mask.
     Note that the areas in the original image that correspond to the black areas of the mask
     show through in the resulting image. The areas that correspond to the white areas of
     the mask aren’t painted. The areas that correspond to the gray areas in the mask are painted
     using an intermediate alpha value that’s equal to 1 minus the image mask sample value.
     
     - parameter maskImage: Image Masker to apply to the Image
     
     - returns: Self, allowing method chaining
     */
    public func maskWithImage(_ maskImage: DaVinciImage) -> DaVinci {
        if let image = self.image {
            self.image = DaVinci.Masker.maskImage(image, with: maskImage)
        }
        return self
    }
    
    /**
     Maske the contained image with an ellipse.
     Allows specifying an additional border to draw on the clipped image.
     For a circle, ensure the image width and height are equal!
     
     - parameter border: Optional border to apply
     
     - returns: Self, allowing method chaining
     */
    public func maskWithEllipse(border: CGBorder = CGBorder.init(color: .white)) -> DaVinci {
        if let image = self.image {
            self.image = DaVinci.Masker.maskImage(image, ellipse: border)
        }
        return self
    }
    
    /**
     Maske the contained image with a path (DaVincBezierPath) which is provided via a closure.
     
     - parameter path: closure that returns a DaVincBezierPath. Using a closure allows the user to provide the path after knowing the size of the image
     
     - returns: Self, allowing method chaining
     */
    public func maskWithPath(_ path: (_ rect: CGRect) -> (DaVincBezierPath)) -> DaVinci {
        if let image = self.image {
            self.image = DaVinci.Masker.maskImage(image, path: path)
        }
        return self
    }
    
    /**
     Maske the contained image with a rounded rectangle border.
     Allows specifying an additional border to draw on the clipped image.
     
     - parameter cornerRadius: Radius of the rounded rect corners
     - parameter borderWidth:  Optional width of border to apply - default 0
     - parameter borderColor:  Optional color of the border - default White
     
     - returns: Self, allowing method chaining
     */
    public func maskWithRoundedRect(cornerRadius: CGFloat,
                                    border: CGBorder = CGBorder.init(color: .white)) -> DaVinci {
        if let image = self.image {
            self.image = DaVinci.Masker.maskImage(image, cornerRadius: cornerRadius, border: border)
        }
        return self
    }
    
    /**
     Container struct for all things Masker related
     */
    public struct Masker {
        
        /**
         Mask the given image with another image mask.
         Note that the areas in the original image that correspond to the black areas of the mask
         show through in the resulting image. The areas that correspond to the white areas of
         the mask aren’t painted. The areas that correspond to the gray areas in the mask are painted
         using an intermediate alpha value that’s equal to 1 minus the image mask sample value.
         
         - parameter image:     Image to apply the mask to
         - parameter maskImage: Image Masker to apply to the Image
         
         - returns: Maskered image
         */
        public static func maskImage(_ image: DaVinciImage, with maskImage: DaVinciImage) -> DaVinciImage? {
            
            guard let imgRef = ToolBox.CGImageWithCorrectOrientation(image) else {
                return nil
            }
            #if os(macOS)
            let maskRef = maskImage.cgImage
            #else
            guard let maskRef = maskImage.cgImage else {
                return
            }
            #endif
            
            guard let dataProvider = maskRef.dataProvider else {
                return nil
            }
            
            guard let mask = CGImage(maskWidth: maskRef.width,
                                     height: maskRef.height,
                                     bitsPerComponent: maskRef.bitsPerComponent,
                                     bitsPerPixel: maskRef.bitsPerPixel,
                                     bytesPerRow: maskRef.bytesPerRow,
                                     provider: dataProvider, decode: nil, shouldInterpolate: false) else {
                                        return nil
            }
            
            guard let masked = imgRef.masking(mask) else {
                return nil
            }
            
            return ToolBox.drawImage(size: image.size, scale: image.scale) { (size: CGSize, context: CGContext) -> Void in
                
                // need to flip the transform matrix, CoreGraphics has (0,0) in lower left when drawing image
                context.scaleBy(x: 1, y: -1)
                context.translateBy(x: 0, y: -size.height)
                
                context.draw(masked, in: CGRect.init(origin: .zero, size: size))
            }
        }
        
        /**
         Mask the given image with an ellipse.
         Allows specifying an additional border to draw on the clipped image.
         For a circle, ensure the image width and height are equal!
         
         - parameter image:   Image to apply the mask to
         - parameter ellipse: Optional ellipse to apply
         
         - returns: Maskered image
         */
        public static func maskImage(_ image: DaVinciImage, ellipse border: CGBorder) -> DaVinciImage? {
            
            guard let imgRef = ToolBox.CGImageWithCorrectOrientation(image) else {
                return nil
            }
            let size = CGSize(width: CGFloat(imgRef.width) / image.scale, height: CGFloat(imgRef.height) / image.scale)
            
            return ToolBox.drawImage(size: size, scale: image.scale) { (size: CGSize, context: CGContext) -> Void in
                
                let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                
                context.addEllipse(in: rect)
                context.clip()
                image.draw(in: rect)
                
                if (border.width > 0) {
                    context.setStrokeColor(border.color.cgColor)
                    context.setLineWidth(border.width)
                    context.addEllipse(in: CGRect(x: border.width / 2,
                                                  y: border.width / 2,
                                                  width: size.width - border.width,
                                                  height: size.height - border.width))
                    context.strokePath()
                }
            }
        }
        
        /**
         Mask the given image with a path(DaVincBezierPath) provided via a closure. This allows the user to get the size of the image before computing their path variable.
         
         - parameter image:       Image to apply the mask to
         - parameter path: DaVincBezierPath to make as the mask
         
         - returns: Maskered image
         */
        public static func maskImage(_ image: DaVinciImage, path closure:(_ rect: CGRect) -> (DaVincBezierPath)) -> DaVinciImage? {
            
            guard let imgRef = ToolBox.CGImageWithCorrectOrientation(image) else {
                return nil
            }
            let size = CGSize(width: CGFloat(imgRef.width) / image.scale, height: CGFloat(imgRef.height) / image.scale)
            
            let path = closure(CGRect(x: 0, y: 0, width: size.width, height: size.height))
            
            return ToolBox.drawImage(size: size, scale: image.scale) { (size: CGSize, context: CGContext) -> Void in
                
                let boundSize = path.bounds.size
                
                let pathRatio = boundSize.width / boundSize.height
                let imageRatio = size.width / size.height
                
                
                if pathRatio > imageRatio {
                    //scale based on width
                    let scale = size.width / boundSize.width
                    path.apply(CGAffineTransform(scaleX: scale, y: scale))
                    path.apply(CGAffineTransform(translationX: 0, y: (size.height - path.bounds.height) / 2.0))
                } else {
                    //scale based on height
                    let scale = size.height / boundSize.height
                    path.apply(CGAffineTransform(scaleX: scale, y: scale))
                    path.apply(CGAffineTransform(translationX: (size.width - path.bounds.width) / 2.0, y: 0))
                }
                
                let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                
                context.addPath(path.cgPath)
                context.clip()
                image.draw(in: rect)
            }
        }
        
        /**
         Mask the given image with a rounded rectangle border.
         Allows specifying an additional border to draw on the clipped image.
         
         - parameter image:        Image to apply the mask to
         - parameter cornerRadius: Radius of the rounded rect corners
         - parameter borderWidth:  Optional width of border to apply - default 0
         - parameter borderColor:  Optional color of the border - default White
         
         - returns: Maskered image
         */
        public static func maskImage(_ image: DaVinciImage,
                                     cornerRadius: CGFloat,
                                     border: CGBorder = CGBorder.init(color: .white)) -> DaVinciImage? {
            
            guard let imgRef = ToolBox.CGImageWithCorrectOrientation(image) else {
                return nil
            }
            let size = CGSize(width: CGFloat(imgRef.width) / image.scale, height: CGFloat(imgRef.height) / image.scale)
            
            return ToolBox.drawImage(size: size, scale: image.scale) { (size: CGSize, context: CGContext) -> Void in
                
                let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                
                DaVincBezierPath(roundedRect:rect, cornerRadius: cornerRadius).addClip()
                image.draw(in: rect)
                
                if (border.width > 0) {
                    context.setStrokeColor(border.color.cgColor)
                    context.setLineWidth(border.width)
                    
                    let borderRect = CGRect(x: 0, y: 0,
                                            width: size.width, height: size.height)
                    
                    let borderPath = DaVincBezierPath(roundedRect: borderRect, cornerRadius: cornerRadius)
                    borderPath.lineWidth = border.width * 2
                    borderPath.stroke()
                }
            }
        }
    }
}

// MARK: - Layer
public extension DaVinci {
    
    /**
     Overlay an image ontop of the current image.
     
     - parameter overlayImage: Image to be on the top layer, i.e. drawn on top of image
     - parameter overlayFrame: Frame of the overlay image
     
     - returns: Self, allowing method chaining
     */
    public func overlay(_ overlayImage: DaVinciImage, in overlayFrame: CGRect) -> DaVinci {
        if let image = self.image {
            self.image = DaVinci.Layer.overlayImage(image, with: overlayImage, in: overlayFrame)
        }
        return self
    }
    
    /**
     Container struct for all things Layer related.
     */
    public struct Layer {
        
        /**
         Overlay the given image into a new layout ontop of the image.
         
         - parameter image:        Image to be on the bottom layer
         - parameter overlayImage: Image to be on the top layer, i.e. drawn on top of image
         - parameter overlayFrame: Frame of the overlay image
         
         - returns: Maskered image
         */
        public static func overlayImage(_ image: DaVinciImage, with overlayImage: DaVinciImage, in overlayFrame: CGRect) -> DaVinciImage? {
            guard let imgRef = ToolBox.CGImageWithCorrectOrientation(image) else {
                return nil
            }
            let size = CGSize(width: CGFloat(imgRef.width) / image.scale, height: CGFloat(imgRef.height) / image.scale)
            
            return ToolBox.drawImage(size: size, scale: image.scale) { (size: CGSize, context: CGContext) -> Void in
                
                let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                
                image.draw(in: rect)
                overlayImage.draw(in: overlayFrame)
            }
        }
    }
}

// MARK: - ToolBox
public extension DaVinci {
    /**
     Container struct for internally used utility functions.
     */
    internal struct ToolBox {
        
        /**
         Get the CGImage of the image with the orientation fixed up based on EXF data.
         This helps to normalise input images to always be the correct orientation when performing
         other core graphics tasks on the image.
         
         - parameter image: Image to create CGImageRef for
         
         - returns: CGImageRef with rotated/transformed image context
         */
        static func CGImageWithCorrectOrientation(_ image: DaVinciImage) -> CGImage? {
            NSImage
            if (image.imageOrientation == UIImageOrientation.up) {
                return image.cgImage
            }
            
            var transform: CGAffineTransform = CGAffineTransform.identity
            
            switch (image.imageOrientation) {
            case UIImageOrientation.right, UIImageOrientation.rightMirrored:
                transform = transform.translatedBy(x: 0, y: image.size.height)
                transform = transform.rotated(by: .pi / -2.0)
                break
            case UIImageOrientation.left, UIImageOrientation.leftMirrored:
                transform = transform.translatedBy(x: image.size.width, y: 0)
                transform = transform.rotated(by: .pi / 2.0)
                break
            case UIImageOrientation.down, UIImageOrientation.downMirrored:
                transform = transform.translatedBy(x: image.size.width, y: image.size.height)
                transform = transform.rotated(by: .pi)
                break
            default:
                break
            }
            
            switch (image.imageOrientation) {
            case UIImageOrientation.rightMirrored, UIImageOrientation.leftMirrored:
                transform = transform.translatedBy(x: image.size.height, y: 0)
                transform = transform.scaledBy(x: -1, y: 1)
                break
            case UIImageOrientation.downMirrored, UIImageOrientation.upMirrored:
                transform = transform.translatedBy(x: image.size.width, y: 0)
                transform = transform.scaledBy(x: -1, y: 1)
                break
            default:
                break
            }
            
            let contextWidth: Int
            let contextHeight: Int
            
            guard let imageCG = image.cgImage else {
                return nil
            }
            
            switch (image.imageOrientation) {
            case UIImageOrientation.left, UIImageOrientation.leftMirrored,
                 UIImageOrientation.right, UIImageOrientation.rightMirrored:
                contextWidth = imageCG.height
                contextHeight = imageCG.width
                break
            default:
                contextWidth = imageCG.width
                contextHeight = imageCG.height
                break
            }
            
            guard let colorSpace = imageCG.colorSpace else {
                return nil
            }
            
            guard let context = CGContext(data: nil, width: contextWidth, height: contextHeight,
                                          bitsPerComponent: imageCG.bitsPerComponent,
                                          bytesPerRow: 0,
                                          space: colorSpace,
                                          bitmapInfo: imageCG.bitmapInfo.rawValue) else {
                                            return nil
            }
            
            context.concatenate(transform)
            context.draw(imageCG, in: CGRect(x: 0, y: 0, width: CGFloat(contextWidth), height: CGFloat(contextHeight)))
            
            let cgImage = context.makeImage()
            return cgImage
        }
        
        /**
         Draw the image within the given bounds (i.e. resizes)
         
         - parameter image:  Image to draw within the given bounds
         - parameter bounds: Bounds to draw the image within
         
         - returns: Resizerd image within bounds
         */
        static func drawImage(_ image: DaVinciImage, bounds: CGRect) -> DaVinciImage? {
            return drawImage(size: bounds.size, scale: image.scale) { (size: CGSize, context: CGContext) -> Void in
                image.draw(in: bounds)
            }
        }
        
        /**
         Crop the image within the given rect (i.e. resizes and crops)
         
         - parameter image: Image to clip within the given rect bounds
         - parameter rect:  Bounds to draw the image within
         
         - returns: Resizerd and cropped image
         */
        static func croppedImage(from image: DaVinciImage, rect: CGRect) -> DaVinciImage? {
            return drawImage(size: rect.size, scale: image.scale) { (size: CGSize, context: CGContext) -> Void in
                
                let drawRect = CGRect(x: -rect.origin.x,
                                      y: -rect.origin.y,
                                      width: image.size.width,
                                      height: image.size.height)
                
                context.clip(to: CGRect(x: 0,
                                        y: 0,
                                        width: rect.size.width,
                                        height: rect.size.height))
                
                image.draw(in: drawRect)
            }
        }
        
        /**
         Closure wrapper around image context - setting up, ending and grabbing the image from the context.
         
         - parameter size:    Size of the graphics context to create
         - parameter closure: Closure of magic to run in a new context
         
         - returns: Image pulled from the end of the closure
         */
        static func drawImage(size: CGSize,
                              scale: CGFloat,
                              _ closure: (_ size: CGSize, _ context: CGContext) -> Void) -> DaVinciImage? {
            
            guard size.width > 0.0 && size.height > 0.0 else {
                print("WARNING: Invalid size requested: \(size.width) x \(size.height) - must not be 0.0 in any dimension")
                return nil
            }
            
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            guard let context = UIGraphicsGetCurrentContext() else {
                print("WARNING: Graphics context is nil!")
                return nil
            }
            
            closure(size, context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
    }
}

public extension DaVinciImage {
    /**
     Resize the contained image to the specified size. Depending on what fitMode is supplied, the image
     may be clipped, cropped or scaled. @see documentation on FitMode.
     
     The current image on this toucan instance is replaced with the resized image.
     
     - parameter dest: Size to resize the image to
     - parameter fitMode:  How to handle the image resizing process
     
     - returns: resized `DaVinciImage` object
     */
    public func resize(to dest: CGSize, mode fitMode: DaVinci.Resizer.FitMode = .clip) -> DaVinciImage? {
        return DaVinci.Resizer.resizeImage(self, size: dest, fitMode: fitMode)
    }
    
    /**
     Maske the contained image with a path (DaVincBezierPath) which is provided via a closure.
     
     - parameter path: closure that returns a DaVincBezierPath. Using a closure allows the user to provide the path after knowing the size of the image
     
     - returns: masked `DaVinciImage` object
     */
    public func mask(path: (_ rect: CGRect) -> (DaVincBezierPath)) -> DaVinciImage? {
        return DaVinci.Masker.maskImage(self, path: path)
    }
    
    /**
     Overlay an image ontop of the current image.
     
     - parameter overlayImage: Image to be on the top layer, i.e. drawn on top of image
     - parameter overlayFrame: Frame of the overlay image
     
     - returns: overlaid `DaVinciImage` object
     */
    public func overlay(_ overlayImage: DaVinciImage, in overlayFrame: CGRect) -> DaVinciImage? {
        return DaVinci.Layer.overlayImage(self, with: overlayImage, in: overlayFrame)
    }
}
#endif
