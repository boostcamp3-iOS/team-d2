//
//  KVOContentOffset.swift
//  DaumWebtoon
//
//  Created by Gaon Kim on 21/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

@objcMembers public class KVOContentOffset: NSObject {
    static let shared = KVOContentOffset()
    private override init() { }
    
    dynamic var contentOffset: CGFloat = 0
}
