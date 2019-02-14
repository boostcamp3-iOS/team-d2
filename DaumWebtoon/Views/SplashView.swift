//
//  SplashView.swift
//  DaumWebtoon
//
//  Created by Gaon Kim on 01/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

protocol SplashViewDelegate: class {
    func splashViewDidFinished(_ splashView: SplashView)
}

class SplashView: UIView {
    private lazy var redSquare = UIView()
    private lazy var topWhiteRectangle = UIView()
    private lazy var bottomWhiteRectangle = UIView()
    
    var delegate: SplashViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        setRectanglesBackgroundColor()
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        setRedSquareLayout()
        setTopWhiteRectangleLayout()
        setBottomWhiteRectangleLayout()
    }
    
    private func setRectanglesBackgroundColor() {
        redSquare.backgroundColor = .red
        topWhiteRectangle.backgroundColor = .white
        bottomWhiteRectangle.backgroundColor = .white
    }
    
    private func setRedSquareLayout() {
        addSubview(redSquare)
        redSquare.translatesAutoresizingMaskIntoConstraints = false
        redSquare.heightAnchor.constraint(equalToConstant: 200).isActive = true
        redSquare.widthAnchor.constraint(equalToConstant: 200).isActive = true
        redSquare.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        redSquare.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func setTopWhiteRectangleLayout() {
        addSubview(topWhiteRectangle)
        topWhiteRectangle.translatesAutoresizingMaskIntoConstraints = false
        topWhiteRectangle.heightAnchor.constraint(equalToConstant: 10).isActive = true
        topWhiteRectangle.widthAnchor.constraint(equalToConstant: 200).isActive = true
        topWhiteRectangle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        topWhiteRectangle.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -30).isActive = true
    }
    
    private func setBottomWhiteRectangleLayout() {
        addSubview(bottomWhiteRectangle)
        bottomWhiteRectangle.translatesAutoresizingMaskIntoConstraints = false
        bottomWhiteRectangle.heightAnchor.constraint(equalToConstant: 10).isActive = true
        bottomWhiteRectangle.widthAnchor.constraint(equalToConstant: 200).isActive = true
        bottomWhiteRectangle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        bottomWhiteRectangle.topAnchor.constraint(equalTo: centerYAnchor, constant: 30).isActive = true
    }
    
    func animate() {
        UIView.animate(withDuration: 0.1, delay: 0.5, options: [], animations: { [weak self] in
            guard let self = self else { return }
            self.topWhiteRectangle.constraints[0].constant = 0
            self.bottomWhiteRectangle.constraints[0].constant = 0
            self.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.5, options: [], animations: { [weak self] in
            guard let self = self else { return }
            self.redSquare.constraints[0].constant = 30
            self.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: 0.3, delay: 1.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: { [weak self] in
            guard let self = self else { return }
            self.redSquare.constraints[1].isActive = false
            self.redSquare.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
            self.redSquare.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
            self.layoutIfNeeded()
        }, completion: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.splashViewDidFinished(self)
        })
    }
}

