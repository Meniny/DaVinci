
import AppKit
import DaVinci

@IBDesignable
class CustomView: NSView {
  override func draw(_ dirtyRect: NSRect) {
    DaVinci.drawInCurrentContext { context in
        macOS.draw(in: context, rect: self.bounds)
    }
  }
}
