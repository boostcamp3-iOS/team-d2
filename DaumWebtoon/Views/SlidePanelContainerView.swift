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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        configureFirstView()
        configureSecondView()
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
}
