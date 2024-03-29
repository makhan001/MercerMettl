//
//  AssistiveTouchButton.swift
//  Mercer | Mettl
//
//  Created by m@k on 16/05/22.
//

import UIKit

open class AssistiveTouchButton: UIButton {
    var originPoint = CGPoint.zero
    let screen = UIScreen.main.bounds

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            fatalError("touch can not be nil")
        }
        originPoint = touch.location(in: self)
    }

    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            fatalError("touch can not be nil")
        }
        let nowPoint = touch.location(in: self)
        let offsetX = nowPoint.x - originPoint.x
        let offsetY = nowPoint.y - originPoint.y
        self.center = CGPoint(x: self.center.x + offsetX, y: self.center.y + offsetY)
    }

    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        reactBounds(touches: touches)
    }

    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        reactBounds(touches: touches)
    }

    func reactBounds(touches: Set<UITouch>) {
        guard let touch = touches.first else {
            fatalError("touch can not be nil")
        }
        let endPoint = touch.location(in: self)
        let offsetX = endPoint.x - originPoint.x
        let offsetY = endPoint.y - originPoint.y

        UIView.animate(withDuration: 0, delay: 1.0, options: .curveEaseOut, animations: {})
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {})
//        UIView.beginAnimations(nil, context: nil)
//        UIView.setAnimationDuration(0.3)
        if center.x + offsetX >= screen.width / 2 {
            self.center = CGPoint(x: screen.width - bounds.size.width / 2, y: center.y + offsetY)
        } else {
            self.center = CGPoint(x: bounds.size.width / 2, y: center.y + offsetY)
        }
        if center.y + offsetY >= screen.height - bounds.size.height / 2 {
            self.center = CGPoint(x: center.x, y: screen.height - bounds.size.height / 2)
        } else if center.y + offsetY < bounds.size.height / 2 {
            self.center = CGPoint(x: center.x, y: bounds.size.height / 2)
        }
        UIView.setAnimationsEnabled(true)
    }

    override open func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
    }
}
