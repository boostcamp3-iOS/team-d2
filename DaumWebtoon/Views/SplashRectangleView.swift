//
//  SplashRectangleView.swift
//  DaumWebtoon
//
//  Created by Gaon Kim on 28/01/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

protocol SplashRectangleAnimationDelegate {
    func setRedSquareLayout()
    func setTopWhiteRectangleLayout()
    func setBottomWhiteRectangleLayout()
    func animateRedSquare()
    func animateTopWhiteRectangle()
    func animateBottomWhiteRectangle()
}

enum SplashRectangleType {
    case redSquare
    case topWhiteRectangle
    case bottomWhiteRectangle
}

class SplashRectangleView: UIView {
    var delegate: SplashRectangleAnimationDelegate?
    private var type: SplashRectangleType?
    
    convenience init(type: SplashRectangleType) {
        self.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        switch type {
        case .redSquare: backgroundColor = .red
        case .topWhiteRectangle, .bottomWhiteRectangle: backgroundColor = .white
        }
        
        self.type = type
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setLayout() {
        guard let type = type else { return }
        switch type {
        case .redSquare:
            delegate?.setRedSquareLayout()
        case .topWhiteRectangle:
            delegate?.setTopWhiteRectangleLayout()
        case .bottomWhiteRectangle:
            delegate?.setBottomWhiteRectangleLayout()
        }
    }
    
    func animate() {
        guard let type = type else { return }
        switch type {
        case .redSquare:
            delegate?.animateRedSquare()
        case .topWhiteRectangle:
            delegate?.animateTopWhiteRectangle()
        case .bottomWhiteRectangle:
            delegate?.animateBottomWhiteRectangle()
        }
    }
}
