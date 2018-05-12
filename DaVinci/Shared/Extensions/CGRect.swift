
import CoreGraphics

public extension CGRect {
    /// Instantiates a rect using a center point instead of an origin.
    public init(center c: CGPoint, size s: CGSize) {
        self.size = s
        self.origin = CGPoint(x: c.x - (s.width / 2), y: c.y - (s.height / 2))
    }
    
    /// Returns the center point of the rect.
    public var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
    
    /// Returns a CGPoint instance corresponding to the top left corner of the rect regardless of the platform.
    public var topLeftPoint: CGPoint {
        get {
            var point = CGPoint.zero
            
            execute(on: .iOS({
                point = self.origin
            }), .macOS({
                point = CGPoint(x: self.origin.x, y: self.maxY)
            }))
            
            return point
        }
    }
    
    /// Returns a CGPoint instance corresponding to the bottom left corner of the rect regardless of the platform.
    public var bottomLeftPoint: CGPoint {
        var point = CGPoint.zero
        
        execute(on: .iOS({
            point = CGPoint(x: self.origin.x, y: self.maxY)
        }), .macOS({
            point = self.origin
        }))
        
        return point
    }
    
    /// Returns a CGPoint instance corresponding to the top right corner of the rect regardless of the platform.
    public var topRightPoint: CGPoint {
        var point = CGPoint.zero
        
        execute(on: .iOS({
            point = CGPoint(x: self.width, y: self.origin.y)
        }), .macOS({
            point = CGPoint(x: self.width, y: self.maxY)
        }))
        
        return point
    }
    
    /// Returns a CGPoint instance corresponding to the bottom right corner of the rect regardless of the platform.
    public var bottomRightPoint: CGPoint {
        get {
            var point = CGPoint.zero
            
            execute(on: .iOS({
                point = CGPoint(x: self.width, y: self.maxY)
            }), .macOS({
                point = CGPoint(x: self.width, y: self.origin.y)
            }))
            
            return point
        }
    }
}

