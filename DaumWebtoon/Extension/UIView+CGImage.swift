//
//  UIView+CGImage.swift
//  DaumWebtoon
//
//  Created by oingbong on 22/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

extension UIView {
    func convertCGImage() -> CGImage? {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        let image = renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
        return image.cgImage
    }
}
