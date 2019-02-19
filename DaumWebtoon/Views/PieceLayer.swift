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
    private let colorKey = "fillColor"
    private let opacityKey = "opacity"
    
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
    
    func pathAnimation(pathCtoN: UIBezierPath, pathN: UIBezierPath, pathNtoHourglass: UIBezierPath, pathHourglass: UIBezierPath, pathHourglassToIce: UIBezierPath, pathIce: UIBezierPath, pathIceToC: UIBezierPath, pathAnotherC: UIBezierPath) {
        guard let fromPath = self.path else { return }
        let animation = CAKeyframeAnimation(keyPath: animationKey)
        animation.duration = 1
        animation.isRemovedOnCompletion = false
        animation.values = [fromPath, pathCtoN.cgPath, pathN.cgPath, pathNtoHourglass.cgPath, pathHourglass.cgPath, pathHourglassToIce.cgPath, pathIce.cgPath, pathIceToC.cgPath, pathAnotherC.cgPath]
        self.add(animation, forKey: animationKey)
    }
    
    func colorAnimation() {
        let animation = CAKeyframeAnimation(keyPath: colorKey)
        animation.duration = 1
        animation.isRemovedOnCompletion = false
        let brown = UIColor.brown.cgColor
        let red = UIColor.red.cgColor
        let purple = UIColor.purple.cgColor
        let blue = UIColor.blue.cgColor
        animation.values = [red, brown, purple, blue, red]
        self.add(animation, forKey: colorKey)
    }
    
    func opacityAnimation() {
        let animation = CAKeyframeAnimation(keyPath: opacityKey)
        animation.duration = 1
        animation.values = [1, 1, 0]
        self.add(animation, forKey: opacityKey)
    }
}
