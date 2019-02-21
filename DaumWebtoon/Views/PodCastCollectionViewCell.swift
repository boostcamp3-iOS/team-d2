//
//  PodCastCollectionViewCell.swift
//  DaumWebtoon
//
//  Created by Tak on 12/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

class PodCastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var podcastThumbnail: UIImageView!
    @IBOutlet weak var podcastTitle: UILabel!
    @IBOutlet weak var podcastDuration: UILabel!
 
    func configure(_ episode: Episode, item: Int, index: IndexPath) {
        layer.borderWidth = 0.5
        layer.cornerRadius = 10
        layer.borderColor = UIColor.lightGray.cgColor
        
        podcastTitle.text = episode.title
        podcastDuration.text = episode.duration.stringFromTimeInt()
        
        FetchImageService.shared.execute(imageUrl: episode.thumbnail) { [weak self] (image) in
            guard let self = self else { return }
            self.podcastThumbnail.image = image
        }
    }
}
