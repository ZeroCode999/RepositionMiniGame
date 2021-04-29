//
//  GameFieldView.swift
//  RepositionMiniGame
//
//  Created by User on 3/12/21.
//

import UIKit

@IBDesignable
final class GameFieldView: UIView {
    private var curPath: UIBezierPath?
    var shapeHitHandler: (() -> Void)?
    
    private enum DrawingSetups: CGFloat {
        case lineWidth = 0
        case borderWidth = 1
        case cornerRadius = 5
    }
    
    @IBInspectable var shapeColor: UIColor = .red {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var shapePosition: CGPoint = .zero {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var shapeSize: CGSize = CGSize(width: 40, height: 40) {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var isShapeHidden: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard !isShapeHidden else {
            curPath = nil
            return
        }
        shapeColor.setFill()
        let path = getTrianglePath(in: CGRect(origin: shapePosition, size: shapeSize))
        path.fill()
        curPath = path
    }
    
    // Counting touches to a shape
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let curPath = curPath else {
            return
        }
        let hit = touches.contains(where: {touch -> Bool in
            let touchPoint = touch.location(in: self)
            return curPath.contains(touchPoint)
        })
        if hit {
            shapeHitHandler?()
        }
    }
    
    func randomizeShapes() {
        let maxX = bounds.maxX - shapeSize.width
        let maxY = bounds.maxY - shapeSize.height
        let xCord = CGFloat(arc4random_uniform(UInt32(maxX)))
        let yCord = CGFloat(arc4random_uniform(UInt32(maxY)))
        shapePosition = CGPoint(x: xCord, y: yCord)
    }
    
    // Do any additional setup after loading the view
    func layerAdditionalSetups() {
        layer.borderWidth = DrawingSetups.borderWidth.rawValue
        layer.backgroundColor = UIColor.gray.cgColor
        layer.cornerRadius = DrawingSetups.cornerRadius.rawValue
    }
    
    // Drawing a triangle
    private func getTrianglePath(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        path.lineWidth = DrawingSetups.lineWidth.rawValue
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.close()
        path.stroke()
        path.fill()
        return path
    }
}
