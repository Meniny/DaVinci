
import UIKit
import DaVinci

@IBDesignable
class CustomView: UIView {
    override func draw(_ rect: CGRect) {
        DaVinci.drawInCurrentContext { context in
            iOS.draw(in: context, rect: self.bounds)
        }
    }
}

