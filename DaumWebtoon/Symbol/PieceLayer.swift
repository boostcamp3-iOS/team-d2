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
    
    func configureAnimation(to targetPath: UIBezierPath) {
        let animation = CABasicAnimation(keyPath: animationKey)
        animation.duration = 1
        animation.fromValue = self.path
        animation.toValue = targetPath.cgPath
        self.add(animation, forKey: animationKey)
    }
}
