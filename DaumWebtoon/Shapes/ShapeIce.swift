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
        case .a: return (0, 0.4)
        case .b: return (0, 0.6)
        case .c: return (1, 0.6)
        case .d: return (1, 0.4)
        case .e: return (0.146, 0.146)
        case .f: return (0.312, 0.037)
        case .g: return (0.146, 0.854)
        case .h: return (0.312, 0.963)
        case .i: return (0.688, 0.963)
        case .j: return (0.854, 0.854)
        case .k: return (0.854, 0.146)
        case .l: return (0.688, 0.036)
        case .m: return (0.381, 0.5)
        case .n: return (0.619, 0.5)
        case .o: return (0.5, 0.4)
        case .p: return (0.5, 0.6)
        }
    }
}
