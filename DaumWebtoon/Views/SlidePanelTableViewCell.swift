//
//  SlidePanelTableViewCell.swift
//  DaumWebtoon
//
//  Created by oingbong on 14/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

class SlidePanelTableViewCell: UITableViewCell {
    let imageEpisode = UIImageView()
    let titleLabel = UILabel()
    let descLabel = UILabel()
    
    // MARK: - For StoryBoard
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - For Programmatically
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    // MARK: - For AutoLayout
    private func configure() {
        contentView.addSubview(imageEpisode)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descLabel)
        imageEpisode.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        
        imageEpisode.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        imageEpisode.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        imageEpisode.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 10).isActive = true
        imageEpisode.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: imageEpisode.bottomAnchor, constant: 8).isActive = true
        
        descLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
    }
}
