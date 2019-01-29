//
//  SplashViewController.swift
//  DaumWebtoon
//
//  Created by Gaon Kim on 28/01/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    lazy var redSquare = RectangleView(backgroundColor: .red)
    lazy var whiteRectangle1 = RectangleView(backgroundColor: .white)
    lazy var whiteRectangle2 = RectangleView(backgroundColor: .white)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateRedSquare()
        animateWhiteRectangles()
    }
}

extension SplashViewController {
    func setViews() {
        setRedSquareLayout()
        setWhiteRectanglesLayout()
    }
    
    func setRedSquareLayout() {
        view.addSubview(redSquare)
        redSquare.heightAnchor.constraint(equalToConstant: 200).isActive = true
        redSquare.widthAnchor.constraint(equalToConstant: 200).isActive = true
        redSquare.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        redSquare.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func setWhiteRectanglesLayout() {
        view.addSubview(whiteRectangle1)
        whiteRectangle1.heightAnchor.constraint(equalToConstant: 10).isActive = true
        whiteRectangle1.widthAnchor.constraint(equalToConstant: 200).isActive = true
        whiteRectangle1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        whiteRectangle1.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -30).isActive = true
        
        view.addSubview(whiteRectangle2)
        whiteRectangle2.heightAnchor.constraint(equalToConstant: 10).isActive = true
        whiteRectangle2.widthAnchor.constraint(equalToConstant: 200).isActive = true
        whiteRectangle2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        whiteRectangle2.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 30).isActive = true
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
    
    func animateWhiteRectangles() {
        UIView.animate(withDuration: 0.1, delay: 0.5, options: [], animations: {
            self.whiteRectangle1.heightAnchor.constraint(equalToConstant: 0).isActive = true
            self.whiteRectangle2.heightAnchor.constraint(equalToConstant: 0).isActive = true
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
