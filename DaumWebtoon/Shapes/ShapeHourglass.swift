//
//  ShapeHourglass.swift
//  DaumWebtoon
//
//  Created by oingbong on 08/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

enum ShapeHourglass: String, Shape {
    case a,b,c,d,e,f,g,h,i,j,k,l,m,n
    
    var coordinate: (CGFloat, CGFloat) {
        switch self {
        case .a: return (0, 0)
        case .b: return (1, 0)
        case .c: return (0, 1)
        case .d: return (1, 1)
        case .e: return (0.25, 0)
        case .f: return (0.75, 1)
        case .g: return (0.25, 1)
        case .h: return (0.75, 0)
        case .i: return (0.15, 0.2)
        case .j: return (0.853, 0.196)
        case .k: return (0.15, 0.8)
        case .l: return (0.85, 0.8)
        case .m: return (0.375, 0.5)
        case .n: return (0.625, 0.5)
        }
    }
}
