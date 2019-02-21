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
    
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        setNeedsLayout()
//        layoutIfNeeded()
//
////        layoutIfNeeded()
////        label.preferredMaxLayoutWidth = label.bounds.size.width
////        layoutAttributes.bounds.size.height  = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
//        
////        let size = contentView.systemLayoutSizeFitting(recommandTitle.frame.size)
////        var frame = layoutAttributes.frame
////        frame.size.width = ceil(size.width)
////        frame.size.height = 30
////        layoutAttributes.frame = frame
////
////        prepareForReuse()
//
//        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(recommandTitle.frame.size)
//        
//        return layoutAttributes
//    }
}
