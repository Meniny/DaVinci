//
//  Arrow.swift
//  DaVinci-iOS
//
//  Created by Meniny on 2018-01-20.
//

#if os(macOS)
    import AppKit
    public typealias ImageType = NSImage
#else
    import UIKit
    public typealias ImageType = UIImage
#endif

public enum ArrowDirection {
    case left
    case right
    case up
    case down
}

public extension ImageType {
    public class func arrow(_ direction: ArrowDirection, square: CGFloat, color: CGColor, background: CGColor? = nil) -> ImageType {
        let rect = CGRect.init(x: 0, y: 0, width: square, height: square)
        return ImageType.render(rect.size, transparency: background == nil) { _ in
            
            let context = CGContext.current
            
            if let background = background {
                let back = DaVinciPath.rectangle(rect)
                context?.fill(path: back, color: background)
            }
            
            func cal(_ ref: CGFloat, _ acu: CGFloat) -> CGFloat {
                let reference: CGFloat = 66
                return (ref / reference) * acu
            }
            
            let arrowPartTop = DaVinciPath.init(point: CGPoint.init(x: cal(11, rect.width), y: rect.midY))
                .addLine(to: CGPoint.init(x: cal(44.5, rect.width), y: 0))
                .addLine(to: CGPoint.init(x: cal(54, rect.width), y: cal(9.5, rect.height)))
                .addLine(to: CGPoint.init(x: cal(30, rect.width), y: rect.midY))
                .close()
            let arrowPartBottom = arrowPartTop.flip(.vertically, by: rect.midY)
            let arrowToLeft = arrowPartTop + arrowPartBottom
            
            switch direction {
            case .left:
                context?.fill(path: arrowToLeft, color: color)
                break
            case .right:
                let arrowToRight = arrowToLeft.flip(.horizontally, by: rect.midX)
                context?.fill(path: arrowToRight, color: color)
                break
            case .up:
                let arrowToUp = arrowToLeft
                context?.rotateClockwise(around: rect.center, by: 90)
                context?.fill(path: arrowToUp, color: color)
                break
            case .down:
                let arrowToDown = arrowToLeft
                context?.rotateClockwise(around: rect.center, by: -90)
                context?.fill(path: arrowToDown, color: color)
                break
            }
            
        }
    }
}
