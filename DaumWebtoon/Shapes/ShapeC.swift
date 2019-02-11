//
//  ShapeC.swift
//  DaumWebtoon
//
//  Created by oingbong on 08/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

enum ShapeC: String, Shape {
    case a,b,c,d,e,f,g,h,i,j,k,l
    
    var coordinate: (CGFloat, CGFloat) {
        switch self {
        case .a: return (0.5, 0)
        case .b: return (0.5, 1)
        case .c: return (0.067, 0.25)
        case .d: return (0.933, 0.75)
        case .e: return (0.933, 0.25)
        case .f: return (0.067, 0.75)
        case .g: return (0.733, 0.365)
        case .h: return (0.5, 0.231)
        case .i: return (0.267, 0.365)
        case .j: return (0.267, 0.635)
        case .k: return (0.5, 0.769)
        case .l: return (0.733, 0.635)
        }
    }
}
