//
//  MainViewController+HeaderView.swift
//  DaumWebtoon
//
//  Created by oingbong on 20/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import Foundation

protocol HeaderDelegate: class {
    func content(from genreId: Int) -> (HeaderContent, [TabContent])?
}

extension MainViewController: HeaderDelegate {
    func content(from genreId: Int) -> (HeaderContent, [TabContent])? {
        guard let content = headerContentsDictionary[genreId] else { return nil}
        return (content, tabContents)
    }
}
