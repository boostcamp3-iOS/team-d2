//
//  ShapeHourglass.swift
//  DaumWebtoon
//
//  Created by oingbong on 08/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

enum ShapeHourglass: String {
    case a,b,c,d,e,f,g,h,i,j,k,l,m,n

    var coordinate: (CGFloat, CGFloat) {
        switch self {
        case .a: return (0, 0)
        case .b: return (200, 0)
        case .c: return (0, 200)
        case .d: return (200, 200)
        case .e: return (50, 0)
        case .f: return (150, 200)
        case .g: return (50, 200)
        case .h: return (150, 0)
        case .i: return (30, 40)
        case .j: return (170.6, 39.2)
        case .k: return (30, 160)
        case .l: return (170, 160)
        case .m: return (75, 100)
        case .n: return (125, 100)
        }
    }
}
