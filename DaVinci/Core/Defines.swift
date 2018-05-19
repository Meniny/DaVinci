
#if os(macOS)
import AppKit
#else
import UIKit
#endif

public extension Double {
    public func degreesToRadians() -> Double {
        return self * Double.pi / 180.0
    }
}

/// Platform-agnostic directions in the graphics context. Possible values: `Top`, `Right`, `Bottom`, and `Left`.
public enum GraphicsDirection {
    case top
    case right
    case bottom
    case left
}

public enum CGFlipping {
    case vertically
    case horizontally
}

public enum CGSizeType {
    case fixed(CGSize)
    case resizable
}

public struct CGBorder: Equatable {
    public enum Alignment {
        case inside
        case center
        case outside
    }
    
    public var width: CGFloat
    public var color: DaVincColor
    public var alignment: CGBorder.Alignment
    
    public init(width: CGFloat = 0, color: DaVincColor = .clear, alignment: CGBorder.Alignment = .inside) {
        self.width = width
        self.color = color
        self.alignment = alignment
    }
}

public struct CGCorner: Equatable {
    public var topLeft: CGFloat
    public var topRight: CGFloat
    public var bottomLeft: CGFloat
    public var bottomRight: CGFloat
    
    public static var zero: CGCorner {
        return CGCorner.init(topLeft: 0, topRight: 0, bottomLeft: 0, bottomRight: 0)
    }
    
    public init(topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) {
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomLeft = bottomLeft
        self.bottomRight = bottomRight
    }
    
    public init(radius: CGFloat) {
        self.init(topLeft: radius, topRight: radius, bottomLeft: radius, bottomRight: radius)
    }
    
    public var maxRadius: CGFloat {
        return fmax(fmax(self.topLeft, self.topRight), fmax(self.bottomLeft, self.bottomRight))
    }
    
    public var isAllEquals: Bool {
        return self.topLeft == self.topRight && self.bottomLeft == self.bottomRight && self.topLeft == self.bottomLeft
    }
}
