
#if !os(macOS)
import UIKit

public extension DaVinci {
    public static func drawInCurrentContext(_ closure: DaVinciDrawingClosure) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.draw(closure)
    }
}
#endif

