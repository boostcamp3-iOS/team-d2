//
//  SplashViewController.swift
//  DaumWebtoon
//
//  Created by Gaon Kim on 28/01/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    lazy var redSquare = SplashRectangleView(type: .redSquare)
    lazy var topWhiteRectanlge = SplashRectangleView(type: .topWhiteRectangle)
    lazy var bottomWhiteRectangle = SplashRectangleView(type: .bottomWhiteRectangle)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        redSquare.delegate = self as SplashRectangleAnimationDelegate
        topWhiteRectanlge.delegate = self as SplashRectangleAnimationDelegate
        bottomWhiteRectangle.delegate = self as SplashRectangleAnimationDelegate
        
        redSquare.setLayout()
        topWhiteRectanlge.setLayout()
        bottomWhiteRectangle.setLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        redSquare.animate()
        topWhiteRectanlge.animate()
        bottomWhiteRectangle.animate()
    }
}

// MARK: - Splash Rectangle Animation Delegate
extension SplashViewController: SplashRectangleAnimationDelegate {
    func setRedSquareLayout() {
        view.addSubview(redSquare)
        redSquare.heightAnchor.constraint(equalToConstant: 200).isActive = true
        redSquare.widthAnchor.constraint(equalToConstant: 200).isActive = true
        redSquare.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        redSquare.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func setTopWhiteRectangleLayout() {
        view.addSubview(topWhiteRectanlge)
        topWhiteRectanlge.heightAnchor.constraint(equalToConstant: 10).isActive = true
        topWhiteRectanlge.widthAnchor.constraint(equalToConstant: 200).isActive = true
        topWhiteRectanlge.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topWhiteRectanlge.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -30).isActive = true
    }
    
    func setBottomWhiteRectangleLayout() {
        view.addSubview(bottomWhiteRectangle)
        bottomWhiteRectangle.heightAnchor.constraint(equalToConstant: 10).isActive = true
        bottomWhiteRectangle.widthAnchor.constraint(equalToConstant: 200).isActive = true
        bottomWhiteRectangle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bottomWhiteRectangle.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 30).isActive = true
    }
    
    func animateRedSquare() {
        UIView.animate(withDuration: 0.8, delay: 0.5, options: [], animations: {
            self.redSquare.heightAnchor.constraint(equalToConstant: 30).isActive = true
            self.view.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: 0.3, delay: 1.3, options: [], animations: {
            self.redSquare.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
            self.redSquare.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func animateTopWhiteRectangle() {
        UIView.animate(withDuration: 0.1, delay: 0.5, options: [], animations: {
            self.topWhiteRectanlge.heightAnchor.constraint(equalToConstant: 0).isActive = true
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func animateBottomWhiteRectangle() {
        UIView.animate(withDuration: 0.1, delay: 0.5, options: [], animations: {
            self.bottomWhiteRectangle.heightAnchor.constraint(equalToConstant: 0).isActive = true
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
