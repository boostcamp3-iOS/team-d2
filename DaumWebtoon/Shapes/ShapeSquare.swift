//
//  ShapeSquare.swift
//  DaumWebtoon
//
//  Created by oingbong on 08/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

enum ShapeSquare: String, Shape {
    case a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,z
    
    var coordinate: (CGFloat, CGFloat) {
        switch self {
        case .a: return (0, 0)
        case .b: return (0, 0.2)
        case .c: return (0.2, 0.2)
        case .d: return (0.2, 0)
        case .e: return (0, 0.8)
        case .f: return (0, 1)
        case .g: return (0.2, 1)
        case .h: return (0.2, 0.8)
        case .i: return (0.8, 0.8)
        case .j: return (0.8, 1)
        case .k: return (1, 1)
        case .l: return (1, 0.8)
        case .m: return (0.8, 0)
        case .n: return (0.8, 0.2)
        case .o: return (1, 0.2)
        case .p: return (1, 0)
        case .q: return (0.5, 0)
        case .r: return (0.5, 0.2)
        case .s: return (0, 0.5)
        case .t: return (0.2, 0.5)
        case .u: return (0.8, 0.5)
        case .v: return (1, 0.5)
        case .w: return (0.5, 0.8)
        case .z: return (0.5, 1)
        }
    }
}
