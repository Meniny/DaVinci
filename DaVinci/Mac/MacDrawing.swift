
#if os(macOS)
import AppKit

public extension DaVinci {
    public static func drawInCurrentContext(_ closure: DaVinciDrawingClosure) {
        NSGraphicsContext.current?.cgContext.draw(closure)
    }
}
#endif
