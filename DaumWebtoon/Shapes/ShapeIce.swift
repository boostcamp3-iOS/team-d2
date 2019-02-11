//
//  ShapeIce.swift
//  DaumWebtoon
//
//  Created by oingbong on 08/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

enum ShapeIce: String, Shape {
    case a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p

    var coordinate: (CGFloat, CGFloat) {
        switch self {
        case .a: return (0, 80)
        case .b: return (0, 120)
        case .c: return (200, 120)
        case .d: return (200, 80)
        case .e: return (29.2, 29.2)
        case .f: return (62.4, 7.4)
        case .g: return (29.2, 170.8)
        case .h: return (62.4, 192.6)
        case .i: return (137.6, 192.6)
        case .j: return (170.8, 170.8)
        case .k: return (170.8, 29.2)
        case .l: return (137.6, 7.2)
        case .m: return (76.2, 100)
        case .n: return (123.8, 100)
        case .o: return (100, 80)
        case .p: return (100, 120)
        }
    }
}
