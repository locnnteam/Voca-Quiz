//
//  MoveAnimationView.swift
//  VocabularyGame
//
//  Created by Nguyen Nhat  Loc on 10/17/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import UIKit

protocol MoveAnimationViewDelegate {
    func stopMoveAnimation()
}

open class MoveAnimationView: UIView, CAAnimationDelegate {
    
    var delegate: MoveAnimationViewDelegate!
    
    public typealias waterDropBuildClosure = (MoveAnimationView) -> Void
    

    ///Waterdrop's color
    open var color: UIColor = UIColor.blue.withAlphaComponent(0.7)
    ///Add position start and stop animation
    open var startPoint: CGPoint = CGPoint(x: 0, y: 0)
    open var stopPoint: CGPoint = CGPoint(x: 0, y: 0)
    ///Size of star
    open var widthStar = 30
    open var heightStar = 30
    
    fileprivate var isStarted = false
    
    private var waterAnimations = [CAAnimation]()
    private var animationGroup : CAAnimationGroup?
    
    public init(frame: CGRect = CGRect.zero, build: waterDropBuildClosure) {
        super.init(frame: frame)
        addAppCycleObserver()
        build(self)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addAppCycleObserver()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addAppCycleObserver()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    /// Required : Add water drops animation in view
    public func startAnimation() {
        isStarted = true
        moveStar()
    }
    
    public func stopAnimation() {
        isStarted = false
        self.layer.sublayers?.forEach {
            $0.removeFromSuperlayer()
        }
    }
    
    @objc open func pauseAnimation() {
        
        layer.sublayers?.forEach {
            if let animation = $0.animation(forKey: "animationGroup") {
                waterAnimations.append(animation)
                $0.pause()
            }
        }
        
    }
    
    @objc open func resumeAnimation() {
        
        if !waterAnimations.isEmpty {
            for i in 0 ..< waterAnimations.count {
                layer.sublayers?[i].add(waterAnimations[i], forKey: "animationGroup")
            }
            waterAnimations.removeAll()
        }
        
        layer.sublayers?.forEach {
            $0.resume()
        }
    }
    
    
    fileprivate func addAppCycleObserver() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pauseAnimation),
                                               name: .UIApplicationWillResignActive,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(resumeAnimation),
                                               name: .UIApplicationWillEnterForeground,
                                               object: nil)
        
    }
    
    fileprivate func moveStar() {
        let starLayer = CALayer()
        starLayer.contents = #imageLiteral(resourceName: "redStar").cgImage
        starLayer.bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        self.layer.addSublayer(starLayer)
        
        startLayerAnimation(layer: starLayer)
    }
    
    fileprivate func startLayerAnimation(layer: CALayer) {
        // animation
        let dropAnimation = CABasicAnimation(keyPath: "position")
        dropAnimation.fromValue = self.startPoint
        dropAnimation.toValue = self.stopPoint

        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 3
        scaleAnimation.toValue = 1
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = Double.pi*2.0
        rotationAnimation.isCumulative = true
        
        animationGroup = CAAnimationGroup()
        animationGroup?.animations = [dropAnimation, scaleAnimation, rotationAnimation]
        animationGroup?.duration = 0.5
        animationGroup?.repeatCount = 1
        animationGroup?.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseIn)
        
        animationGroup?.delegate = self
        layer.add(animationGroup!, forKey: "animationGroup")
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        stopAnimation()
        self.removeFromSuperview()
        self.delegate.stopMoveAnimation()
    }
}

extension CALayer {
    
    fileprivate func pause() {
        
        let pausedTime = self.convertTime(CACurrentMediaTime(), from: nil)
        self.speed = 0.0
        self.timeOffset = pausedTime
        
    }
    
    fileprivate func resume() {
        
        let pausedTime = self.timeOffset
        self.speed = 1.0
        self.timeOffset = 0.0
        self.beginTime = 0.0
        let timeSincePause = self.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        self.beginTime = timeSincePause
        
    }
    
}

