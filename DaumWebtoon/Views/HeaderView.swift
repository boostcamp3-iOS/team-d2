//
//  HeaderView.swift
//  DaumWebtoon
//
//  Created by oingbong on 12/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    private var titleLabel = UILabel()
    private var descriptionLabel = UILabel()
    private var imageView = UIImageView()
    var symbolView = SymbolView(frame: CGRect(origin: CGPoint(x: 20, y: 20), size: CGSize(width: 100, height: 100)))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func configureSymbolView() {
        addSubview(symbolView)
        symbolView.translatesAutoresizingMaskIntoConstraints = false
        symbolView.topAnchor.constraint(equalTo: self.topAnchor, constant: -20).isActive = true
        symbolView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        symbolView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        symbolView.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func configureData(with channel: Channel?) {
        configureSymbolView()
        guard let channel = channel else { return }
        configureTitle(with: channel.title)
        configureImage(with: channel.image)
        configureDescription(with: channel.description)
    }
    
    private func configureTitle(with title: String) {
        addSubview(titleLabel)
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.frame.size = CGSize(width: 100, height: 40)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: symbolView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: symbolView.bottomAnchor, constant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        titleLabel.numberOfLines = 3
    }
    
    private func configureImage(with image: String) {
        addSubview(imageView)
        FetchImageService.shared.execute(imageUrl: image) {
            self.imageView.image = $0
            self.imageView.contentMode = .scaleAspectFit
        }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        imageView.leadingAnchor.constraint(equalTo: symbolView.trailingAnchor, constant: 20).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
    }
    
    private func configureDescription(with description: String) {
        addSubview(descriptionLabel)
        descriptionLabel.text = description
        descriptionLabel.textColor = .gray
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.frame.size = CGSize(width: 100, height: 40)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.centerXAnchor.constraint(equalTo: symbolView.centerXAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        descriptionLabel.numberOfLines = 4
    }
    
    func timeOffset(value: Double) {
        symbolView.timeOffset(value: value)
    }
}
