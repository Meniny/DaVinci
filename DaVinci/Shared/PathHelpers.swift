
import CoreGraphics

/// Concatenate two paths together.
public func + (lhp: DaVinciPath, rhp: DaVinciPath) -> DaVinciPath {
    let actions = lhp.actions + rhp.actions
    return DaVinciPath(point: rhp.currentPoint, pathActions: actions)
}

/// Concatenate two paths together.
///
/// - parameter lhp: Left hand path.
/// - parameter rhp: Right hand path.
///
/// - returns: A new path.
public func concat(_ lhp: DaVinciPath, _ rhp: DaVinciPath) -> DaVinciPath {
    return lhp + rhp
}

