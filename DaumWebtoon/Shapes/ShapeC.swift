//
//  ShapeC.swift
//  DaumWebtoon
//
//  Created by oingbong on 08/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

enum ShapeC: String {
    case a,b,c,d,e,f,g,h,i,j,k,l
    
    var coordinate: (CGFloat, CGFloat) {
        switch self {
        case .a: return (100, 0)
        case .b: return (100, 200)
        case .c: return (13.4, 50)
        case .d: return (186.6, 150)
        case .e: return (186.6, 50)
        case .f: return (13.4, 150)
        case .g: return (146.6, 73)
        case .h: return (100, 46.2)
        case .i: return (53.4, 73)
        case .j: return (53.4, 127)
        case .k: return (100, 153.8)
        case .l: return (146.6, 127)
        }
    }
}
