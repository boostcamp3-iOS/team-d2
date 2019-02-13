//
//  DetailCollectionViewCell.swift
//  DaumWebtoon
//
//  Created by Tak on 13/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

class DetailCollectionViewCell: UICollectionReusableView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var podcastTitle: UILabel!
    @IBOutlet weak var podcastDescription: UILabel!
    @IBOutlet weak var podcastPublisher: UILabel!
    
    func configure(title: String?, description: String?, publisher: String?) {
        podcastTitle.text = title ?? ""
        podcastDescription.text = description ?? ""
        podcastPublisher.text = publisher ?? ""
    }
}
