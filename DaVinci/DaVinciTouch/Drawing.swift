
import UIKit

public func drawInCurrentContext(_ closure: DaVinciDrawingClosure) {
    guard let context = UIGraphicsGetCurrentContext() else { return }
    context.draw(closure)
}

