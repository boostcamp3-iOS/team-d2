//
//  HeaderImageView.swift
//  DaumWebtoon
//
//  Created by oingbong on 20/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

class HeaderImageView: UIView {
    struct HeaderImages {
        let gap: CGImage
        let first: CGImage
        let second: CGImage
        let third: CGImage
        let fourth: CGImage
    }
    
    private var imageLayer = CALayer()
    private let contentsKey = "contents"
    private let opacityKey = "opacity"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(with headerContentsDictionary: [Int: HeaderContent]) {
        let gapView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
        gapView.backgroundColor = .white
        guard let gapImage = gapView.convertCGImage() else { return }
        
        let genre = MainViewController.Genre.self
        let firstId = genre.webDesign.rawValue
        let secondId = genre.programming.rawValue
        let thirdId = genre.vrAndAr.rawValue
        let fourthId = genre.startup.rawValue
        
        guard let firstImage = headerContentsDictionary[firstId]?.image.cgImage else { return }
        guard let secondImage = headerContentsDictionary[secondId]?.image.cgImage else { return }
        guard let thirdImage = headerContentsDictionary[thirdId]?.image.cgImage else { return }
        guard let fourthImage = headerContentsDictionary[fourthId]?.image.cgImage else { return }
        imageLayer.frame.size = self.frame.size
        imageLayer.contents = firstImage
        imageLayer.speed = 0
        imageLayer.timeOffset = 0
        
        let headerImages = HeaderImages(gap: gapImage, first: firstImage, second: secondImage, third: thirdImage, fourth: fourthImage)
        contentAnimation(with: headerImages)
        opacityAnimation()
        self.layer.addSublayer(imageLayer)
    }
    
    private func contentAnimation(with images: HeaderImages) {
        let contentAnimation = CAKeyframeAnimation(keyPath: contentsKey)
        contentAnimation.duration = 1
        contentAnimation.isRemovedOnCompletion = false
        contentAnimation.values = [images.first, images.gap, images.second, images.gap, images.third, images.gap, images.fourth, images.gap, images.first]
        imageLayer.add(contentAnimation, forKey: contentsKey)
    }
    
    private func opacityAnimation() {
        let opacityAnimation = CAKeyframeAnimation(keyPath: opacityKey)
        opacityAnimation.duration = 1
        opacityAnimation.isRemovedOnCompletion = false
        opacityAnimation.values = [1, 0, 1, 0, 1, 0, 1, 0, 1]
        imageLayer.add(opacityAnimation, forKey: opacityKey)
    }
    
    func timeOffset(with value: Double) {
        imageLayer.timeOffset = value
    }
}
