//
//  ChannelTableViewCell.swift
//  DaumWebtoon
//
//  Created by Gaon Kim on 14/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

class ChannelTableViewCell: UITableViewCell {
    var thumbnailImageView = UIImageView()
    private lazy var titleLabel = UILabel()
    private lazy var publisherLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addThumbnailImageView()
        addTitleLabel()
        addPublisherLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Thumnail Image View Methods
    func addThumbnailImageView() {
        addSubview(thumbnailImageView)
        setThumbnailImageViewLayout()
        setThumbnailImageViewProperties()
    }
    
    func setThumbnailImageViewLayout() {
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        thumbnailImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        thumbnailImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        thumbnailImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        thumbnailImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    func setThumbnailImageViewProperties() {
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
    }
    
    // MARK: Title Label Methods
    func addTitleLabel() {
        addSubview(titleLabel)
        setTitleLabelLayout()
        setTitleLabelProperties()
    }
    
    func setTitleLabelLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor, constant: -20).isActive = true
    }
    
    func setTitleLabelProperties() {
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    
    // MARK: Publisher Label Methods
    func addPublisherLabel() {
        addSubview(publisherLabel)
        setPublisherLabelLayout()
        setPublisherLabelProperties()
    }
    
    func setPublisherLabelLayout() {
        publisherLabel.translatesAutoresizingMaskIntoConstraints = false
        publisherLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3).isActive = true
        publisherLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        publisherLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
    }
    
    func setPublisherLabelProperties() {
        publisherLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 12, weight: .light)
    }
    
    // MARK: Data
    func setData(channel: Channel) {
        titleLabel.text = channel.title
        publisherLabel.text = channel.publisher
        fetchImage(imageUrl: channel.image)
    }
    
    func fetchImage(imageUrl: String) {
        FetchImageService.shared.execute(imageUrl: imageUrl) { [weak self] image in
            guard let self = self else { return }
            self.thumbnailImageView.image = image
        }
    }
}
