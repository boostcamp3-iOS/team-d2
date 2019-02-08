//
//  ShapeN.swift
//  DaumWebtoon
//
//  Created by oingbong on 08/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

enum ShapeN: String {
    case a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p

    var coordinate: (CGFloat, CGFloat) {
        switch self {
        case .a: return (0, 0)
        case .b: return (0, 40)
        case .c: return (200, 40)
        case .d: return (200, 0)
        case .e: return (0, 160)
        case .f: return (0, 200)
        case .g: return (200, 200)
        case .h: return (200, 160)
        case .i: return (173.8, 9.6)
        case .j: return (26.2, 190.2)
        case .k: return (86.8, 84.8)
        case .l: return (113, 115.2)
        case .m: return (100, 0)
        case .n: return (100, 40)
        case .o: return (100, 160)
        case .p: return (100, 200)
        }
    }
}
