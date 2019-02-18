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
        symbolView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        symbolView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        symbolView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        symbolView.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func configureData(title: String, with image: String) {
        configureSymbolView()
        configureTitle(with: title)
        configureImage(with: image)
    }
    
    private func configureTitle(with title: String) {
        addSubview(titleLabel)
        titleLabel.text = title
        titleLabel.frame.size = CGSize(width: 100, height: 40)
        titleLabel.backgroundColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: symbolView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: symbolView.bottomAnchor, constant: 20).isActive = true
    }
    
    private func configureImage(with image: String) {
        addSubview(imageView)
        imageView.image = UIImage(named: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: symbolView.trailingAnchor, constant: 20).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    func timeOffset(value: Double) {
        symbolView.timeOffset(value: value)
    }
}
