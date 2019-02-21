//
//  UIView+RoundedCorner.swift
//  DaumWebtoon
//
//  Created by oingbong on 21/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

extension UIView {
    func roundedCorner() {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
}
