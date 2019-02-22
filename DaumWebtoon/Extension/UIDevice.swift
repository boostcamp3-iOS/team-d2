//
//  UIDevice.swift
//  DaumWebtoon
//
//  Created by Tak on 21/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
