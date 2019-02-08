//
//  ShapeSquare.swift
//  DaumWebtoon
//
//  Created by oingbong on 08/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

enum ShapeSquare: String {
    case a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,z
    
    var coordinate: (CGFloat, CGFloat) {
        switch self {
        case .a: return (0, 0)
        case .b: return (0, 40)
        case .c: return (40, 40)
        case .d: return (40, 0)
        case .e: return (0, 160)
        case .f: return (0, 200)
        case .g: return (40, 200)
        case .h: return (40, 160)
        case .i: return (160, 160)
        case .j: return (160, 200)
        case .k: return (200, 200)
        case .l: return (200, 160)
        case .m: return (160, 0)
        case .n: return (160, 40)
        case .o: return (200, 40)
        case .p: return (200, 0)
        case .q: return (100, 0)
        case .r: return (100, 40)
        case .s: return (0, 100)
        case .t: return (40, 100)
        case .u: return (160, 100)
        case .v: return (200, 100)
        case .w: return (100, 160)
        case .z: return (100, 200)
        }
    }
}
