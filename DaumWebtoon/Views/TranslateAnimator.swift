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
    var selectedCellOriginY: CGFloat?
    
    private let duration = 0.5
    
    private var backgroundImageLayer: CALayer?
    private var containerWidth: CGFloat = 0.0
    private var containerHeight: CGFloat = 0.0
    private var selectedImageHeight: CGFloat = 0.0
    private var initialOrigin = CGPoint(x: 0.0, y: 0.0)
    private lazy var flightValues = [
        [
            initialOrigin,
            CGPoint(x: containerWidth / 2, y: selectedImageHeight - 20)
        ],
        [
            initialOrigin,
            CGPoint(x: containerWidth / 2, y: containerHeight / 6),
            CGPoint(x: containerWidth / 2, y: selectedImageHeight - 20)
        ],
        [   initialOrigin,
            CGPoint(x: containerWidth / 2, y: containerHeight / 2),
            CGPoint(x: containerWidth / 2, y: selectedImageHeight - 20)
        ]
    ]
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let selectedImage = selectedImage,
            let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to),
            let selectedCellOriginY = selectedCellOriginY,
            let backgroundImage = UIImage(named: "lightGray") else { return }
        
        let containerView = transitionContext.containerView
        let duration = transitionDuration(using: transitionContext)
        
        containerWidth = containerView.frame.width
        containerHeight = containerView.frame.height
        initialOrigin = CGPoint(x: selectedImage.frame.origin.x, y: selectedCellOriginY)
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
        flight.duration = duration
        print(selectedCellOriginY)
        if selectedCellOriginY < containerView.frame.height / 4 {
            flight.values = flightValues[0].map { NSValue(cgPoint: $0) }
            flight.keyTimes = [0.0, 1.0]
        } else if selectedCellOriginY >= containerView.frame.height / 4 && selectedCellOriginY < containerView.frame.height / 2 + 100 {
            flight.values = flightValues[1].map { NSValue(cgPoint: $0) }
            flight.keyTimes = [0.0, 0.3, 1.0]
        } else {
            flight.values = flightValues[2].map { NSValue(cgPoint: $0) }
            flight.keyTimes = [0.0, 0.2, 1.0]
        }
        
        animatedImage.add(flight, forKey: nil)
        animatedImage.position = CGPoint(x: containerWidth / 2, y: selectedImageHeight - 20)
        
        transitionContext.completeTransition(true)
        fromView.removeFromSuperview()
    }
}

extension TranslateAnimator: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let backgroundImageLayer = backgroundImageLayer else { return }
        
        backgroundImageLayer.isHidden = false
        UIView.animate(withDuration: 5.0, animations: {
            backgroundImageLayer.cornerRadius = 10
            backgroundImageLayer.opacity = 0.5
            backgroundImageLayer.setAffineTransform(CGAffineTransform(scaleX: self.containerWidth, y: CGFloat(1)))
        })
    }
}
