//
//  MainViewController+HeaderView.swift
//  DaumWebtoon
//
//  Created by oingbong on 19/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import Foundation

protocol HeaderDelegate: class {
    func firstgenre(with channel: Channel)
}

extension MainViewController: HeaderDelegate {
    func firstgenre(with channel: Channel) {
        headerView.configureData(with: channel)
    }
}
