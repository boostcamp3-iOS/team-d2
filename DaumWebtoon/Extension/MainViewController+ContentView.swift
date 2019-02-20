//
//  MainViewController+ContentView.swift
//  DaumWebtoon
//
//  Created by oingbong on 19/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import Foundation

protocol ContentDelegate: class {
    func firstGenre(with channel: Channel, genreId: Int)
}

extension MainViewController: ContentDelegate {
    func firstGenre(with channel: Channel, genreId: Int) {
        FetchImageService.shared.execute(imageUrl: channel.image) {
            let headerContent = HeaderContent(title: channel.title, description: channel.description, image: $0)
            self.headerContentsDictionary.updateValue(headerContent, forKey: genreId)
        }
    }
}
