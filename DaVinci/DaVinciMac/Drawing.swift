
import AppKit

public func drawInCurrentContext(_ closure: DaVinciDrawingClosure) {
    NSGraphicsContext.current?.cgContext.draw(closure)
}

