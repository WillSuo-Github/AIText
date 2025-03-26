//
//  BallScaleMultipleAnimationView.swift
//  AIText
//
//  Created by will Suo on 2025/3/26.
//


import AppKit
import QuartzCore

class BallScaleMultipleAnimationView: NSView {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        layer = CALayer()
        setUpAnimation()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        wantsLayer = true
        layer = CALayer()
        setUpAnimation()
    }
    
    private func setUpAnimation() {
        guard let layer = self.layer else { return }
        let size: CGFloat = min(bounds.width, bounds.height)
        let color = NSColor.systemBlue
        let duration: CFTimeInterval = 1
        let beginTime = CACurrentMediaTime()
        let beginTimes: [CFTimeInterval] = [0, 0.2, 0.4]
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = duration
        scaleAnimation.fromValue = 0
        scaleAnimation.toValue = 1
        
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.duration = duration
        opacityAnimation.keyTimes = [0, 0.05, 1]
        opacityAnimation.values = [0, 1, 0]
        
        let animation = CAAnimationGroup()
        animation.animations = [scaleAnimation, opacityAnimation]
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = duration
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false
        
        for i in 0..<3 {
            let circle = createCircleLayer(size: size, color: color)
            let frame = CGRect(x: (bounds.width - size) / 2,
                               y: (bounds.height - size) / 2,
                               width: size,
                               height: size)
            
            animation.beginTime = beginTime + beginTimes[i]
            circle.frame = frame
            circle.opacity = 0
            circle.add(animation, forKey: "animation")
            layer.addSublayer(circle)
        }
    }
    
    private func createCircleLayer(size: CGFloat, color: NSColor) -> CALayer {
        let layer = CALayer()
        layer.bounds = CGRect(x: 0, y: 0, width: size, height: size)
        layer.cornerRadius = size / 2
        layer.backgroundColor = color.cgColor
        return layer
    }
}

// 创建一个 NSViewController 以显示动画视图
class AnimationViewController: NSViewController {
    override func loadView() {
        self.view = BallScaleMultipleAnimationView(frame: NSRect(x: 0, y: 0, width: 40, height: 40))
    }
}
