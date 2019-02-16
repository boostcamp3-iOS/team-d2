//
//  PodCastTableViewCell.swift
//  DaumWebtoon
//
//  Created by Tak on 15/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

class PodCastTableViewCell: UITableViewCell {

    @IBOutlet weak var podcastTitle: UILabel!
    @IBOutlet weak var podcastPublisher: UILabel!
    @IBOutlet weak var podcastThumbnail: UIImageView!
    
    func configure(podcast: PodCastSearch) {
        podcastTitle.text = podcast.title
        podcastPublisher.text = podcast.publisher
        
        FetchImageService.shared.execute(imageUrl: podcast.thumbnail) { [weak self] in
            guard let self = self else { return }
            self.podcastThumbnail.image = $0
        }
    }

}
