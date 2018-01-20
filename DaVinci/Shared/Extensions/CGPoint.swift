
import CoreGraphics

extension CGPoint {
    /// Flips a point vertically along an axis with a given Y value.
    ///
    /// - parameter axisY: The Y coordinate of the symmetry axis.
    ///
    /// - returns: A new point flipped vertically alongside the given Y axis.
    public func flipVertically(by axisY: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: (2 * axisY) - y)
    }
    
    /// Flips a point horizontally along an axis with a given X value.
    ///
    /// - parameter axisX: The X coordinate of the symmetry axis.
    ///
    /// - returns: A new point flipped horizontally alongside the given X axis.
    public func flipHorizontally(by axisX: CGFloat) -> CGPoint {
        return CGPoint(x: (2 * axisX) - x, y: y)
    }
    
    /// Flips a point horizontally/vertically along an axis with a given X/Y value.
    ///
    /// - parameter axis: The X/Y coordinate of the symmetry axis.
    ///
    /// - returns: A new point flipped horizontally/vertically alongside the given X/Y axis.
    public func flip(_ type: FlipType, by axis: CGFloat) -> CGPoint {
        switch type {
        case .horizontally:
            return self.flipHorizontally(by: axis)
        default:
            return self.flipVertically(by: axis)
        }
    }
}

