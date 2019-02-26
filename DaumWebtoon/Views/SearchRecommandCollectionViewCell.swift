//
//  SearchRecommandCollectionViewCell.swift
//  DaumWebtoon
//
//  Created by Tak on 15/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

class SearchRecommandCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var recommandTitle: UILabel!

    func configure(genre: Genre) {
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
        recommandTitle.text = "#\(genre.name)"
    }
}
