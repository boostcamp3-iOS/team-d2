//
//  String+DeleteHTMLTag.swift
//  DaumWebtoon
//
//  Created by oingbong on 19/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import Foundation

extension String {
    var deleteHTMLTag: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
