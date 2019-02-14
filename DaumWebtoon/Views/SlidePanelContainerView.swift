//
//  SlidePanelContainerView.swift
//  DaumWebtoon
//
//  Created by Tak on 12/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

class SlidePanelContainerView: UIView {
    private var firstView = UIView()
    private var secondView = UIView()
    private var recentButton = UIButton()
    private var favoriteButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        configureFirstView()
        configureSecondView()
        configureButton()
    }
    
    private func configureFirstView() {
        addSubview(firstView)
        firstView.backgroundColor = .white
        firstView.translatesAutoresizingMaskIntoConstraints = false
        firstView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        firstView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        firstView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        firstView.widthAnchor.constraint(equalToConstant: self.frame.width / 2).isActive = true
    }
    
    private func configureSecondView() {
        addSubview(secondView)
        secondView.backgroundColor = .black
        secondView.translatesAutoresizingMaskIntoConstraints = false
        secondView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        secondView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        secondView.leadingAnchor.constraint(equalTo: firstView.trailingAnchor).isActive = true
        secondView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    private func configureButton() {
        firstView.addSubview(recentButton)
        recentButton.setAttributedTitle(customAttributedString(with: "최근 본 에피소드"), for: .normal)
        recentButton.frame.size = CGSize(width: 100, height: 40)
        recentButton.translatesAutoresizingMaskIntoConstraints = false
        recentButton.centerYAnchor.constraint(equalTo: firstView.centerYAnchor, constant: -30).isActive = true
        recentButton.centerXAnchor.constraint(equalTo: firstView.centerXAnchor).isActive = true
        
        firstView.addSubview(favoriteButton)
        favoriteButton.setAttributedTitle(customAttributedString(with: "좋아하는 에피소드"), for: .normal)
        favoriteButton.frame.size = CGSize(width: 100, height: 40)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.centerYAnchor.constraint(equalTo: firstView.centerYAnchor, constant: 30).isActive = true
        favoriteButton.centerXAnchor.constraint(equalTo: firstView.centerXAnchor).isActive = true
    }
    
    private func customAttributedString(with text: String) -> NSAttributedString {
        var attributedOption = [NSAttributedString.Key: Any]()
        attributedOption.updateValue(2, forKey: .underlineStyle)
        attributedOption.updateValue(UIFont.boldSystemFont(ofSize: 20), forKey: .font)
        let attributedString = NSAttributedString(string: text, attributes: attributedOption)
        return attributedString
    }
}
