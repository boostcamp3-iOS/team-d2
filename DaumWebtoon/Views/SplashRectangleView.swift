//
//  SplashRectangleView.swift
//  DaumWebtoon
//
//  Created by Gaon Kim on 28/01/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

class SplashRectangleView: UIView {
    convenience init(backgroundColor: UIColor) {
        self.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = backgroundColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
