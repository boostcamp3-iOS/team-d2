//
//  TranslateAnimator.swift
//  DaumWebtoon
//
//  Created by Tak on 06/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit


class TranslateAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var selectedImage: UIImageView?
    var selectedCellFrame: CGRect?
    
    private let duration = 1.0
    
    private var backgroundImageLayer: CALayer?
    private var containerWidth: CGFloat = 0.0
    private var selectedImageHeight: CGFloat = 0.0
    private var initialOrigin = CGPoint(x: 0.0, y: 0.0)
    private lazy var flightValues = [
        [
            initialOrigin,
            CGPoint(x: containerWidth / 2, y: containerWidth / 1.5),
            CGPoint(x: containerWidth / 2, y: containerWidth / 2),
            CGPoint(x: containerWidth / 2, y: selectedImageHeight - 20)
        ],
        [
            initialOrigin,
            CGPoint(x: containerWidth / 2, y: containerWidth / 2),
            CGPoint(x: containerWidth / 2, y: selectedImageHeight - 20)
        ],
        [
            initialOrigin,
            CGPoint(x: containerWidth / 2, y: containerWidth / 2),
            CGPoint(x: containerWidth / 2, y: selectedImageHeight - 20)
        ],
        [   initialOrigin,
            CGPoint(x: containerWidth / 2, y: selectedImageHeight - 20)
        ]
    ]
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    private var toViewController: UIViewController?
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let selectedImage = selectedImage,
            let toView = transitionContext.view(forKey: .to),
            let selectedFrame = selectedCellFrame,
            let backgroundImage = UIImage(named: "lightGray"),
            let toViewController = transitionContext.viewController(forKey: .to) else { return }
        
        let containerView = transitionContext.containerView
        let duration = transitionDuration(using: transitionContext)
        let yPosition = selectedFrame.origin.y
        
        containerWidth = containerView.frame.width
        initialOrigin = CGPoint(x: selectedImage.frame.origin.x, y: selectedFrame.origin.y)
        selectedImageHeight = 150
        
        let animatedImage = CALayer()
        animatedImage.contents = selectedImage.image?.cgImage
        animatedImage.frame = CGRect(x: 0, y: 0, width: 170, height: selectedImageHeight)
        
        backgroundImageLayer = CALayer()
        backgroundImageLayer?.isHidden = true
        backgroundImageLayer?.contents = backgroundImage.cgImage
        backgroundImageLayer?.frame = CGRect(x: 0, y: 0, width: 100, height: selectedImageHeight)
        backgroundImageLayer?.position = CGPoint(x: containerWidth / 2, y: selectedImageHeight - 20)
        
        containerView.addSubview(toView)
        containerView.layer.addSublayer(backgroundImageLayer ?? CALayer())
        containerView.layer.addSublayer(animatedImage)
        
        let flight = CAKeyframeAnimation(keyPath: "position")
        flight.delegate = self
        if yPosition >= containerView.frame.height / 1.5 && yPosition < containerView.frame.height / 2 {
            flight.duration = duration
            flight.values = flightValues[0].map { NSValue(cgPoint: $0) }
            flight.keyTimes = [0.0, 0.2, 0.75, 1.0]
        } else if yPosition >= containerView.frame.height / 2 && yPosition < containerView.frame.height / 4 {
            flight.duration = duration
            flight.values = flightValues[1].map { NSValue(cgPoint: $0) }
            flight.keyTimes = [0.0, 0.2, 1.0]
        } else if yPosition >= containerView.frame.height / 4 && yPosition < containerView.frame.height / 2 {
            flight.duration = 0.2
            flight.values = flightValues[2].map { NSValue(cgPoint: $0) }
            flight.keyTimes = [0.0, 0.2, 1.0]
        } else {
            flight.duration = 0.2
            flight.values = flightValues[3].map { NSValue(cgPoint: $0) }
            flight.keyTimes = [0.0, 1.0]
        }
        
        animatedImage.add(flight, forKey: nil)
        animatedImage.position = CGPoint(x: containerWidth / 2, y: selectedImageHeight - 20)
        
        self.toViewController = toViewController
        
        transitionContext.completeTransition(true)
    }
}

extension TranslateAnimator: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let backgroundImageLayer = backgroundImageLayer else { return }
        
        backgroundImageLayer.isHidden = false
        UIView.animate(withDuration: 0.6) {
            backgroundImageLayer.cornerRadius = 10
            backgroundImageLayer.opacity = 0.5
            backgroundImageLayer.setAffineTransform(CGAffineTransform(scaleX: self.containerWidth, y: CGFloat(1)))
        }
    }
}
