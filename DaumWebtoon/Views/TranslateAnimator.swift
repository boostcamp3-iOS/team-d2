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
    var backgroundImage: UIImageView?
    
    private let duration = 0.25
    
    private var containerWidth: CGFloat = 0.0
    private var selectedImageHeight: CGFloat = 0.0
    private var initialOrigin = CGPoint(x: 0.0, y: 0.0)
    private lazy var flightValues = [
        [
            initialOrigin,
            CGPoint(x: containerWidth / 2, y: containerWidth / 2),
            CGPoint(x: containerWidth / 2, y: selectedImageHeight)
        ],
        [
            initialOrigin,
            CGPoint(x: containerWidth / 2, y: containerWidth / 4),
            CGPoint(x: containerWidth / 2, y: selectedImageHeight)
        ],
        [   initialOrigin,
            CGPoint(x: containerWidth / 2, y: selectedImageHeight)
        ]
    ]
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let selectedImage = selectedImage,
            let toView = transitionContext.view(forKey: .to),
            let backgroundImage = backgroundImage else { return }
        
        let containerView = transitionContext.containerView
        let duration = transitionDuration(using: transitionContext)
        let yPosition = selectedImage.frame.origin.y
        
        containerWidth = containerView.frame.width
        initialOrigin = selectedImage.frame.origin
        selectedImageHeight = selectedImage.frame.height
        
        let animatedImage = CALayer()
        animatedImage.contents = selectedImage.image?.cgImage
        animatedImage.frame = selectedImage.frame
        
        backgroundImage.center = CGPoint(x: self.containerWidth / 2, y: self.selectedImageHeight)
        backgroundImage.isHidden = true
        
        containerView.addSubview(toView)
        containerView.addSubview(backgroundImage)
        containerView.layer.addSublayer(animatedImage)

        let flight = CAKeyframeAnimation(keyPath: "position")
        flight.delegate = self
        if yPosition >= containerView.frame.height / 2 {
            flight.duration = duration
            flight.values = flightValues[0].map { NSValue(cgPoint: $0) }
            flight.keyTimes = [0.0, 0.75, 1.0]
        } else if yPosition >= containerView.frame.height / 4 && yPosition < containerView.frame.height / 2 {
            flight.duration = duration
            flight.values = flightValues[1].map { NSValue(cgPoint: $0) }
            flight.keyTimes = [0.0, 0.75, 1.0]
        } else {
            flight.duration = 0.1
            flight.values = flightValues[2].map { NSValue(cgPoint: $0) }
            flight.keyTimes = [0.0, 1.0]
        }
        
        animatedImage.add(flight, forKey: nil)
        animatedImage.position = CGPoint(x: containerView.frame.width / 2, y: selectedImage.frame.height)
        
        transitionContext.completeTransition(true)
    }
}

extension TranslateAnimator: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let backgroundImage = backgroundImage else { return }
        
        backgroundImage.isHidden = false
        UIView.animate(withDuration: 0.1, animations: {() -> Void in
            backgroundImage.bounds.size.width += self.containerWidth - backgroundImage.frame.width
        }, completion: {(_ finished: Bool) -> Void in

        })
    }
}
