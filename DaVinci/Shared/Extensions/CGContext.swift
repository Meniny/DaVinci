
import CoreGraphics

public extension CGContext {
    /// Rotates the context by a given angle around a pivot point.
    ///
    /// - parameter pivot: A pivot point in the user space coordinates around which the context will rotate.
    /// - parameter angle: The angle, in degrees, by which to rotate the coordinate space of the context.
    public func rotate(around pivot: CGPoint, by angle: Double) {
        self.translateBy(x: pivot.x, y: pivot.y);
        self.rotate(by: CGFloat(degreesToRadians(angle)));
        self.translateBy(x: -pivot.x, y: -pivot.y);
    }
    
    /// Rotates the context clockwise, regardless of the platform, by a given angle around a pivot point.
    ///
    /// - parameter pivot: A pivot point in the user space coordinates around which the context will rotate.
    /// - parameter angle: The angle, in degrees, by which to rotate the coordinate space of the context. Positive values will rotate the context clockwise.
    public func rotateClockwise(around pivot: CGPoint, by angle: Double) {
        execute(on: .iOS({
            self.rotate(around: pivot, by: angle)
        }), .macOS({
            self.rotate(around: pivot, by: -angle)
        }))
    }
    
    /// Executes a drawing code block in the context.
    ///
    /// - parameter DaVinciDrawingClosure: The drawing block to execute in the context.
    public func draw(_ closure: DaVinciDrawingClosure) {
        self.saveGState()
        closure(self)
        self.restoreGState()
    }
    
    /// Add `path' to the path of context. The points in `path' are transformed by the CTM of context before they are added.
    ///
    /// - Parameter path: DaVinciPath
    public func addPath(_ path: DaVinciPath) {
        self.addPath(path.cgPath)
    }
    
    public func fill(path: DaVinciPath, color: CGColor) {
        self.setFillColor(color)
        self.addPath(path)
        self.fillPath()
    }
    
    public func stroke(path: DaVinciPath, color: CGColor) {
        self.setStrokeColor(color)
        self.addPath(path)
        self.strokePath()
    }
}

