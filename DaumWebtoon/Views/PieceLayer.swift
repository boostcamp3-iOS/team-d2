//
//  PieceLayer.swift
//  DaumWebtoon
//
//  Created by oingbong on 29/01/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

class PieceLayer: CAShapeLayer {
    private let animationKey = "path"
    
    override init() {
        super.init()
    }
    
    // MARK: for StoryBoard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: for Custom
    convenience init(color: UIColor, path: UIBezierPath) {
        self.init()
        self.speed = 0
        self.timeOffset = 0
        self.fillColor = color.cgColor
        self.path = path.cgPath
    }
    
    func configureAnimation(passPath: UIBezierPath, toPath: UIBezierPath) {
        guard let fromPath = self.path else { return }
        let animation = CAKeyframeAnimation(keyPath: animationKey)
        animation.duration = 1
        animation.values = [fromPath, passPath.cgPath, toPath.cgPath]
        animation.keyTimes = [0, 0.5, 1]
        self.add(animation, forKey: animationKey)
    }
}
