//
//  ShapeN.swift
//  DaumWebtoon
//
//  Created by oingbong on 08/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

enum ShapeN: String, Shape {
    case a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p

    var coordinate: (CGFloat, CGFloat) {
        switch self {
        case .a: return (0, 0)
        case .b: return (0, 0.2)
        case .c: return (1, 0.2)
        case .d: return (1, 0)
        case .e: return (0, 0.8)
        case .f: return (0, 1)
        case .g: return (1, 1)
        case .h: return (1, 0.8)
        case .i: return (0.869, 0.048)
        case .j: return (0.131, 0.951)
        case .k: return (0.434, 0.424)
        case .l: return (0.565, 0.576)
        case .m: return (0.5, 0)
        case .n: return (0.5, 0.2)
        case .o: return (0.5, 0.8)
        case .p: return (0.5, 1)
        }
    }
}
