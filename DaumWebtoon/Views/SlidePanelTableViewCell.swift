//
//  SlidePanelTableViewCell.swift
//  DaumWebtoon
//
//  Created by oingbong on 14/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

class SlidePanelTableViewCell: UITableViewCell {
    private let imageEpisode = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
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
        configureAutolayout()
    }
    
    func configure(with episode: Episode) {
        FetchImageService.shared.execute(imageUrl: episode.image) {
            self.imageEpisode.image = $0
        }
        titleLabel.text = episode.title.deleteHTMLTag
        descriptionLabel.text = episode.description.deleteHTMLTag
    }
    
    // MARK: - For AutoLayout
    private func configureAutolayout() {
        self.backgroundColor = .black
        contentView.addSubview(imageEpisode)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        imageEpisode.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        imageEpisode.contentMode = .scaleAspectFit
        imageEpisode.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        imageEpisode.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        imageEpisode.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        imageEpisode.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: imageEpisode.bottomAnchor, constant: 8).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        
        descriptionLabel.textColor = .gray
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        descriptionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
    }
}
