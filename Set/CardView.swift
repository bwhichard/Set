//
//  SetUIView.swift
//  Set
//
//  Created by Brandon Whichard on 4/21/18.
//  Copyright © 2018 Brandon Whichard. All rights reserved.
//

import UIKit

@IBDesignable

class CardView: UIView {
    
     struct ShapeSize {
        static let ovalRatio = AspectRatio(1,3)
        static let diamondRatio = AspectRatio(3,2)
        static let squiggleatio = AspectRatio(2,2)
        static let cornderRadius : CGFloat = 16.0
        static let twoSymbolPecentTop : CGFloat = 0.75
        static let twoSymbolPecentBottom : CGFloat = 1.25
        static let threeSymbolPecentTop : CGFloat = 0.25
        static let threeSymbolPecentBottom : CGFloat = 0.75
        static let selectedLineWidth : CGFloat = 25.0
        static let noLineWidth : CGFloat = 0.0
        static let lineWidth : CGFloat = 5.0
        static let backgroundColor = UIColor.white
        static let shapeStripe : CGFloat = 20.0
        static let selectedLineWidthScaler : CGFloat = selectedLineWidth/340
        static let strippedLineWidthScaler : CGFloat = lineWidth/340
        static let cornerRadiusScaler : CGFloat = cornderRadius/340
        
    }
    
    //Example is I had subviews that needed layouts
    //@IBInspectable var symbol : String = "squiggle" { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    @IBInspectable var symbol : String = "diamond" { didSet { setNeedsDisplay() ; setNeedsLayout() } }
    @IBInspectable var color : UIColor  = UIColor.red { didSet { setNeedsDisplay() ; setNeedsLayout() } }
    @IBInspectable var shading : String = "solid" { didSet { setNeedsDisplay() ; setNeedsLayout()  } }
    @IBInspectable var symbolCount : Int = 3 { didSet { setNeedsDisplay() ; setNeedsLayout()  } }
    @IBInspectable var selected : Bool  = false { didSet { setNeedsDisplay() ; setNeedsLayout()  } }
    //var isStripeNeeded : Bool { get { return shading == "shading" } }
 
    override var description: String {
        return "Color: \(color), Symbol: \(symbol), Shading: \(shading), Count: \(symbolCount)"
    }
        
    override func draw(_ rect: CGRect) {
        drawRoundedCard()
        let knownSymbol = SetUI.symbolNames.contains(symbol)

        if knownSymbol {
            switch symbol {
                case SetUI.symbolNames[0]:
                    _ = getSymbolCoordinates().map( {drawDiamond($0)} )
                case SetUI.symbolNames[1]:
                    _ = getSymbolCoordinates().map( {drawSquiggle(center: $0)} )
                case SetUI.symbolNames[2]:
                    _ = getSymbolCoordinates().map( {drawSetOval(center: $0)} )
            default:
                assert(knownSymbol, "Can't draw \(symbol)")
            }
        } else {
            assert(knownSymbol, "Can't draw \(symbol)")
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    private func getSymbolCoordinates() -> [CGPoint] {
        var points : Array<CGPoint> = []
        
        switch symbolCount {
        case 1:
            points.append(CGPoint(x: bounds.midX, y: bounds.midY))
        case 2:
            points.append(CGPoint(x: bounds.midX, y: bounds.midY*ShapeSize.twoSymbolPecentTop))
            points.append(CGPoint(x: bounds.midX, y: bounds.midY*ShapeSize.twoSymbolPecentBottom))
        case 3:
            points.append(CGPoint(x: bounds.midX, y: bounds.midY))
            points.append(CGPoint(x: bounds.midX, y: bounds.maxY*ShapeSize.threeSymbolPecentTop))
            points.append(CGPoint(x: bounds.midX, y: bounds.maxY*ShapeSize.threeSymbolPecentBottom))
        default:
            points.append(CGPoint(x: bounds.midX, y: bounds.midY))
        }
        return points
    }
    
    private func drawRoundedCard() {
        let cornerRadius = bounds.maxX * ShapeSize.cornerRadiusScaler
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        if selected {
            UIColor.yellow.setStroke()
            roundedRect.lineWidth = bounds.maxX * ShapeSize.selectedLineWidthScaler
        } else {
            UIColor.white.setStroke()
            roundedRect.lineWidth = CardView.ShapeSize.noLineWidth
        }
        roundedRect.stroke()
    }
    
    private func drawDiamond(_ center : CGPoint) {
        let width = bounds.midX/ShapeSize.diamondRatio.width
        let height = 2 * width
        
        let topPoint = CGPoint(x: center.x, y: center.y - width)
        let bottomPoint = CGPoint(x: center.x, y: center.y + width)
        let rightPoint = CGPoint(x: center.x + height, y: center.y )
        let leftPoint = CGPoint(x: center.x - height, y: center.y )
        
        let path = UIBezierPath()
        path.move(to: topPoint)
        path.addLine(to: leftPoint)
        path.addLine(to: bottomPoint)
        path.addLine(to: rightPoint)
        path.close()
        //path.formatThePath(shading: shading, color: color)
        formatTheShape(shape: path)
    }
    
    private func drawSetOval(center : CGPoint) {
        let width = bounds.midX/ShapeSize.ovalRatio.width
        let height = bounds.midY/ShapeSize.ovalRatio.height
        
        let halfTheWidth = width/2
        let halfTheHeight = height/2
        let radius = halfTheHeight
        let rightCenter = CGPoint(x: center.x + halfTheWidth, y : center.y)
        let leftCenter = CGPoint(x: center.x - halfTheWidth, y : center.y)
        let twoSeventy = CGFloat.pi/2
        let ninety = CGFloat.pi*1.5
        let path = UIBezierPath()
        
        let topLeft = CGPoint(x: center.x - halfTheWidth, y: center.y - halfTheHeight)
        let topRight = CGPoint(x: center.x + halfTheWidth, y: center.y - halfTheHeight)
        let bottomLeft = CGPoint(x: center.x - halfTheWidth, y: center.y + halfTheHeight)
        let bottomRight = CGPoint(x: center.x + halfTheWidth, y: center.y + halfTheHeight)
        
        path.move(to: topLeft)
        path.addLine(to: topRight)
        path.addArc(withCenter: rightCenter, radius: radius, startAngle: ninety, endAngle: twoSeventy, clockwise: true)
        
        path.move(to: bottomRight)
        path.addLine(to: bottomLeft)
        path.addArc(withCenter: leftCenter, radius: radius, startAngle: twoSeventy  , endAngle: ninety, clockwise: true)

        path.close()
        //path.formatThePath(shading: shading, color: color)
        formatTheShape(shape: path)
    }
    
    private func drawSquiggle(center : CGPoint) {
        let width = bounds.midX/ShapeSize.squiggleatio.width
        let height = bounds.midY/ShapeSize.squiggleatio.height
        
        let halfWidth = CGFloat(width / 2)
        let halfHeight = CGFloat(height / 2)
        
        let startPoint = CGPoint(x: center.x + halfWidth/1.5, y: center.y + halfHeight/3)
        
        //let leftPoint = CGPoint(x: center.x - halfWidth, y: center.y - halfHeight)
        let leftPoint = CGPoint(x: startPoint.x - width, y: startPoint.y - halfHeight)
        let rightPoint = CGPoint(x: startPoint.x + halfWidth, y: startPoint.y - halfHeight)
        let upperControl = CGPoint(x: startPoint.x + halfWidth, y: startPoint.y + halfHeight)
        let lowerControl = CGPoint(x: startPoint.x - halfWidth, y: startPoint.y - halfHeight/4)
        let leftCenter = CGPoint(x: startPoint.x - (width + halfWidth), y: startPoint.y)
        let leftLower = CGPoint(x: startPoint.x - width, y: startPoint.y + halfHeight/2)
        let leftMidLow = CGPoint(x: startPoint.x -  halfWidth, y: startPoint.y - halfHeight/4)
       
        
        let path =  UIBezierPath()
        path.move(to: startPoint)
        path.addQuadCurve(to: rightPoint, controlPoint: upperControl)
        path.addQuadCurve(to: leftPoint, controlPoint: lowerControl)
        path.addQuadCurve(to: leftLower, controlPoint: leftCenter)
        path.addQuadCurve(to: startPoint, controlPoint: leftMidLow)
        path.close()
        //path.formatThePath(shading: shading, color: color)
        //drawRectangle(center: center, height: CGFloat(10), width: CGFloat(10))
        formatTheShape(shape: path)
    }
        
    private func drawRectangle(center : CGPoint, height : CGFloat, width : CGFloat) {
        let orginForRec = CGPoint(x:(center.x - width/2), y:(center.y - height/2))
        let size = CGSize(width: width, height: height)
        let rectPoint = CGRect(origin: orginForRec, size: size)
        let path = UIBezierPath( rect: rectPoint)
        
        path.formatThePath(shading: shading, color: color)
    }
    
    private func drawGemotricOval(center : CGPoint, height : CGFloat, width : CGFloat) {
        let toLeftCornerHeight = CGFloat(height / 2)
        let toLeftCornerWidth = CGFloat(width / 2)
        let size = CGSize(width: width, height: height)
        let origin = CGPoint(x: center.x - toLeftCornerWidth, y: center.x - toLeftCornerHeight)
        let rectPoint = CGRect(origin: origin, size: size)
        let path = UIBezierPath( ovalIn: rectPoint)
        
        path.formatThePath(shading: shading, color: color)
    }
    
    private func drawTriangle(center: CGPoint, length : CGFloat) {
        let topPoint = CGPoint(x: center.x, y: center.y - length)
        let bottomPoint = CGPoint(x: center.x, y: center.y + length)
        let rightPoint = CGPoint(x: center.x + length, y: center.y)
        let leftPoint = CGPoint(x: center.x - length, y: center.y)
        
        if let context = UIGraphicsGetCurrentContext() {
            context.move(to: topPoint)
            context.addLine(to: rightPoint)
            context.addLine(to: bottomPoint)
            context.addLine(to: leftPoint)
            context.addLine(to: topPoint)
            context.setLineWidth(bounds.maxX * ShapeSize.strippedLineWidthScaler)
            UIColor.red.setFill()
            UIColor.red.setStroke()
            context.strokePath()
        }
    }
    
    private func formatTheShape( shape : UIBezierPath ) {
        shape.lineWidth = bounds.maxX * ShapeSize.strippedLineWidthScaler
        
        if (shading == SetUI.striped) {
            stripeShape(path: shape)
        } else {
            if (shading == SetUI.solid) {
                    color.setFill()
            } else if ( shading == SetUI.open ) {
                    CardView.ShapeSize.backgroundColor.setFill()
            }
            color.setStroke()
            shape.stroke()
            shape.fill()
        }
    }
    
    private func stripeShape(path : UIBezierPath) {
        UIGraphicsGetCurrentContext()?.saveGState()
        path.addClip()
        let stripeOffset = (bounds.maxX - bounds.minX) / ShapeSize.shapeStripe
        for index in 0...Int(ShapeSize.shapeStripe) {
            let x = bounds.minX + stripeOffset * index.toCGFloat()
            let startPoint = CGPoint(x : x, y : bounds.minY)
            let endPoint = CGPoint(x : x, y : bounds.maxY)
            let linePath = UIBezierPath()
            linePath.move(to: startPoint)
            linePath.addLine(to : endPoint)
            linePath.close()
            linePath.lineWidth = bounds.maxX * ShapeSize.strippedLineWidthScaler
            color.setStroke()
            linePath.stroke()
        }
        UIGraphicsGetCurrentContext()?.restoreGState()
    }
    
    //Example form lecture
    private func drawCircleBezierPath() {
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: 100.0, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        path.formatThePath(shading: shading, color: color)
    }
    
    //Example form lecture
    private func drawCircle() {
        if let context = UIGraphicsGetCurrentContext() {
            context.addArc(center: CGPoint(x: bounds.midX, y: bounds.midY), radius: 100.0, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
            context.setLineWidth(5.0)
            UIColor.green.setFill()
            UIColor.red.setStroke()
            context.strokePath()
            //Contect is now lost so does not work, Bezuer Path example does work.
            context.fillPath()
        }
        
    }
    
}

class AspectRatio {
    var width : CGFloat =  1
    var height : CGFloat  = 1
    
    init(_ width : Int, _ height : Int ) {
        self.width = CGFloat(width)
        self.height = CGFloat(height)
    }
}

extension Int {
    func toCGFloat () -> CGFloat {
        return CGFloat(self)
    }
}

extension UIBezierPath {
    func formatThePath(shading : String, color : UIColor) {
        self.lineWidth = CardView.ShapeSize.lineWidth

        if (SetUI.shadingNames.contains(shading)) {
            if (shading == SetUI.shadingNames[0]) {
                color.setFill()
            } else if ( shading == SetUI.shadingNames[1]) {
                CardView.ShapeSize.backgroundColor.setFill()
            }
//            else if (shading == SetUI.shadingNames[2] ) {
//                //SetUIView.ShapeSize.backgroundColor.setFill()
//                UIColor.clear.setFill()
//            }
            color.setStroke()
            self.stroke()
            self.fill()
        }
    }
}
