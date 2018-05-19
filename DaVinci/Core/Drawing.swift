
#if os(macOS)
import AppKit
#else
import UIKit
#endif

public extension DaVinci {
    public static func drawInCurrentContext(_ closure: DaVinciDrawingClosure) {
        #if os(macOS)
        NSGraphicsContext.current?.cgContext.draw(closure)
        #else
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.draw(closure)
        #endif
    }
}
