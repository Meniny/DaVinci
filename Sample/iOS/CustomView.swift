
import UIKit
import DaVinci

@IBDesignable
class CustomView: UIView {
    override func draw(_ rect: CGRect) {
        drawInCurrentContext { context in
            iOS.draw(in: context, rect: self.bounds)
        }
    }
}

