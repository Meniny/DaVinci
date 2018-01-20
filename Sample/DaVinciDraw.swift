
import CoreGraphics
import DaVinci

public func draw(in context: CGContext, rect: CGRect) {
    let fillColorOne: CGColor = #colorLiteral(red: 0.05, green:0.49, blue:0.98, alpha:0.8).cgColor
//    let fillColorTwo: CGColor = #colorLiteral(red: 0.15, green:0.82, blue:0.55, alpha:0.7).cgColor
//
//    let triangle = DaVinciPath(point: rect.topLeftPoint)
//        .addLine(to: rect.bottomLeftPoint)
//        .addLine(towards: [.right: Float(rect.width), .top: Float(rect.height / 2)])
//        .close()
//
//    let flippedTriangle = triangle.flip(.horizontally, by: rect.midX)
//
//    context.setFillColor(fillColorOne)
//    context.addPath(triangle.cgPath)
//    context.fillPath()
//
//    context.setFillColor(fillColorTwo)
//    context.addPath(flippedTriangle.cgPath)
//    context.fillPath()
    func cal(_ ref: CGFloat, _ acu: CGFloat) -> CGFloat {
        let reference: CGFloat = 66
        return (ref / reference) * acu
    }
    
    let arrowPartTop = DaVinciPath.init(point: CGPoint.init(x: cal(11, rect.width), y: rect.midY))
        .addLine(to: CGPoint.init(x: cal(44.5, rect.width), y: 0))
        .addLine(to: CGPoint.init(x: cal(54, rect.width), y: cal(9.5, rect.height)))
        .addLine(to: CGPoint.init(x: cal(30, rect.width), y: rect.midY))
        .close()
    let arrowPartBottom = arrowPartTop.flip(.vertically, by: rect.midY)
    let arrow = arrowPartTop + arrowPartBottom
    
    context.fill(path: arrow, color: fillColorOne)
}

