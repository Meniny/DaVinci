
import CoreGraphics

public extension DaVinci {
    public struct Path {
        /// The last point in the path.
        public let currentPoint: CGPoint
        
        /// A list of path actions.
        public let actions: [DaVinci.PathAction]
        
        /// Instantiates a path with a point and a list of actions.
        public init(point: CGPoint, pathActions: [DaVinci.PathAction]) {
            currentPoint = point
            actions = pathActions
        }
        
        /// Instantiates a path with a point.
        public init(point: CGPoint) {
            currentPoint = point
            actions = [.move(point)]
        }
        
        public static func rectangle(_ rect: CGRect) -> DaVinci.Path {
            let path = DaVinci.Path.init(point: rect.origin)
                .addLine(to: rect.topRightPoint)
                .addLine(to: rect.bottomRightPoint)
                .addLine(to: rect.bottomLeftPoint)
                .close()
            return path
        }
    }
}

public extension DaVinci.Path {
    /// A computed CGPath property created from the path.
    var cgPath: CGPath {
        get {
            let mutablePath = CGMutablePath()
            
            for action in actions {
                switch action {
                case .move(let point):
                    mutablePath.move(to: point)
                case .addLine(let point):
                    mutablePath.addLine(to: point)
                case .close:
                    mutablePath.closeSubpath()
                }
            }
            
            return mutablePath
        }
    }
}

public extension DaVinci.Path {
    /// Flips a path vertically along an axis with a given Y value.
    ///
    /// - parameter axisY: The Y coordinate of the symmetry axis.
    ///
    /// - returns: A new path flipped vertically alongside the given Y axis.
    public func flipVertically(by axisY: CGFloat) -> DaVinci.Path {
        let flippedPoint = currentPoint.flipVertically(by: axisY)
        let flippedActions = actions.map { $0.flipVertically(by: axisY) }
        return DaVinci.Path(point: flippedPoint, pathActions: flippedActions)
    }
    
    /// Flips a path horizontally along an axis with a given X value.
    ///
    /// - parameter axisX: The X coordinate of the symmetry axis.
    ///
    /// - returns: A new path flipped horizontally alongside the given X axis.
    public func flipHorizontally(by axisX: CGFloat) -> DaVinci.Path {
        let flippedPoint = currentPoint.flipHorizontally(by: axisX)
        let flippedActions = actions.map { $0.flipHorizontally(by: axisX) }
        return DaVinci.Path(point: flippedPoint, pathActions: flippedActions)
    }
    
    /// Flips a path horizontally/vertically along an axis with a given X/Y value.
    ///
    /// - parameter axis: The X/Y coordinate of the symmetry axis.
    ///
    /// - returns: A new path flipped horizontally/vertically alongside the given X/Y axis.
    public func flip(_ type: CGFlipping, by axis: CGFloat) -> DaVinci.Path {
        switch type {
        case .horizontally:
            return self.flipHorizontally(by: axis)
        default:
            return self.flipVertically(by: axis)
        }
    }
}

public extension DaVinci.Path {
    /// Concatenate two paths together.
    ///
    /// - parameter rhp: Right hand path.
    ///
    /// - returns: A new path.
    public func concat(with rhp: DaVinci.Path) -> DaVinci.Path {
        return self + rhp
    }
    
    /// Concatenate two paths together.
    ///
    /// - parameter lhp: Left hand path.
    ///
    /// - returns: A new path.
    public func concat(to lhp: DaVinci.Path) -> DaVinci.Path {
        return lhp + self
    }
}

public extension DaVinci.Path {
    /// Returns a new path moved to a given a point.
    ///
    /// - parameter point: The point to move to.
    ///
    /// - returns: A new path moved to the given point.
    public func move(to point: CGPoint) -> DaVinci.Path {
        return DaVinci.Path(point: point, pathActions: actions + [.move(point)])
    }
    
    /// Returns a new path after adding a line to a given point in an existing path.
    ///
    /// - parameter point: The end point of the line.
    ///
    /// - returns: A new path with a new line added to it.
    public func addLine(to point: CGPoint) -> DaVinci.Path {
        return DaVinci.Path(point: point, pathActions: actions + [.addLine(point)])
    }
    
    
    /// Returns a new path after closing the existing path.
    ///  ///
    /// - returns: A new closed path.
    public func close() -> DaVinci.Path {
        return DaVinci.Path(point: currentPoint, pathActions: actions + [.close])
    }
    
    /// Returns a new path after adding a line towards a given platform-agnostic direction in the existing path.
    ///
    /// - parameter directions: A dictionary containing one or more `GraphicsDirection` as keys, and delta distance as values. The path will be moved  by the delta distance towards the corresponding value.
    ///
    /// - returns: A new path with a new line added to it.
    public func addLine(towards directions: [GraphicsDirection: Float]) -> DaVinci.Path {
        var destinationPoint = currentPoint
        for (direction, delta) in directions {
            switch direction {
            case .top:
                execute(on: .iOS({
                    destinationPoint.y -= CGFloat(delta)
                }), .macOS({
                    destinationPoint.y += CGFloat(delta)
                }))
            case .right:
                destinationPoint.x += CGFloat(delta)
            case .bottom:
                execute(on: .iOS({
                    destinationPoint.y += CGFloat(delta)
                }), .macOS({
                    destinationPoint.y -= CGFloat(delta)
                }))
            case .left:
                destinationPoint.x -= CGFloat(delta)
            }
        }
        
        return DaVinci.Path(point: destinationPoint, pathActions: actions + [.addLine(destinationPoint)])
    }
}

/// Concatenate two paths together.
public func + (lhp: DaVinci.Path, rhp: DaVinci.Path) -> DaVinci.Path {
    let actions = lhp.actions + rhp.actions
    return DaVinci.Path(point: rhp.currentPoint, pathActions: actions)
}

/// Concatenate two paths together.
///
/// - parameter lhp: Left hand path.
/// - parameter rhp: Right hand path.
///
/// - returns: A new path.
public func concat(_ lhp: DaVinci.Path, _ rhp: DaVinci.Path) -> DaVinci.Path {
    return lhp + rhp
}
