//
//  HeaderView.swift
//  DaumWebtoon
//
//  Created by oingbong on 12/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    private var tabTitleLabel = UILabel()
    private var titleLabel = UILabel()
    private var descriptionLabel = UILabel()
    var symbolView = SymbolView(frame: CGRect(origin: CGPoint(x: 20, y: 20), size: CGSize(width: 100, height: 100)))
    private var headerImageView = HeaderImageView()
    private var headerContentsDictionary = [Int: HeaderContent]()
    weak var delegate: HeaderDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure() {
        configureSymbolView()
        configureImageView()
    }
    
    private func configureSymbolView() {
        addSubview(symbolView)
        symbolView.translatesAutoresizingMaskIntoConstraints = false
        symbolView.topAnchor.constraint(equalTo: self.topAnchor, constant: -20).isActive = true
        symbolView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        symbolView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        symbolView.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    private func configureImageView() {
        addSubview(headerImageView)
        headerImageView.roundedCorner()
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        headerImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 35).isActive = true
        headerImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -42).isActive = true
        headerImageView.leadingAnchor.constraint(equalTo: symbolView.trailingAnchor, constant: 20).isActive = true
        headerImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
    }
    
    private func configureTabTitle(with tabContent: TabContent) {
        addSubview(tabTitleLabel)
        tabTitleLabel.text = tabContent.tabTitle
        tabTitleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        tabTitleLabel.textColor = tabContent.tabColor
        tabTitleLabel.frame.size = CGSize(width: 100, height: 40)
        tabTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        tabTitleLabel.centerXAnchor.constraint(equalTo: symbolView.centerXAnchor).isActive = true
        tabTitleLabel.topAnchor.constraint(equalTo: symbolView.bottomAnchor, constant: 20).isActive = true
        tabTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        tabTitleLabel.numberOfLines = 1
        opacityAnimation(to: tabTitleLabel)
    }
    
    private func configureTitle(with title: String) {
        addSubview(titleLabel)
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.frame.size = CGSize(width: 100, height: 40)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: symbolView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: tabTitleLabel.bottomAnchor, constant: 18).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        titleLabel.numberOfLines = 2
        opacityAnimation(to: titleLabel)
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
        descriptionLabel.numberOfLines = 5
        opacityAnimation(to: descriptionLabel)
    }
    
    private func opacityAnimation(to label: UILabel) {
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.duration = 1
        opacityAnimation.isRemovedOnCompletion = false
        opacityAnimation.values = [1,0,1,0,1,0,1,0,1]
        label.layer.timeOffset = 0
        label.layer.speed = 0
        label.layer.add(opacityAnimation, forKey: nil)
    }
    
    func timeOffset(value: Double) {
        contentTimeOffset(with: value)
        
        let genre = MainViewController.Genre.self
        let firstId = genre.webDesign.rawValue
        let secondId = genre.programming.rawValue
        let thirdId = genre.vrAndAr.rawValue
        let fourthId = genre.startup.rawValue

        switch value {
        case 0..<0.125:
            configureContent(with: firstId, tabIndex: 1)
        case 0.125..<0.375:
            configureContent(with: secondId, tabIndex: 2)
        case 0.375..<0.625:
            configureContent(with: thirdId, tabIndex: 3)
        case 0.625..<0.875:
            configureContent(with: fourthId, tabIndex: 4)
        default:
            configureContent(with: firstId, tabIndex: 1)
        }
    }
    
    private func contentTimeOffset(with value: Double) {
        symbolView.timeOffset(value: value)
        headerImageView.timeOffset(with: value)
        tabTitleLabel.layer.timeOffset = value
        titleLabel.layer.timeOffset = value
        descriptionLabel.layer.timeOffset = value
    }
    
    private func configureContent(with genreId: Int, tabIndex: Int) {
        guard let (headerContent, tabContents) = delegate?.content(from: genreId) else { return }
        tabTitleLabel.text = tabContents[tabIndex].tabTitle
        tabTitleLabel.textColor = tabContents[tabIndex].tabColor
        titleLabel.text = headerContent.title
        descriptionLabel.text = headerContent.description
    }
    
    func configureFirstContent(with headerContentsDictionary: [Int: HeaderContent]) {
        headerImageView.configure(with: headerContentsDictionary)
        
        let genre = MainViewController.Genre.self
        let firstId = genre.webDesign.rawValue
        
        guard let (headerContent, tabContents) = delegate?.content(from: firstId) else { return }
        configureText(headerContent: headerContent, tabContent: tabContents[1])
    }
    
    private func configureText(headerContent: HeaderContent, tabContent: TabContent) {
        configureTabTitle(with: tabContent)
        configureTitle(with: headerContent.title)
        configureDescription(with: headerContent.description)
    }
}
