//
//  SlidePanelViewController.swift
//  DaumWebtoon
//
//  Created by Tak on 12/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

protocol SlidePanelViewDelegate: class {
    func dismiss()
    func panGestureDraggingEnded()
}

class SlidePanelViewController: UIViewController {
    
    weak var delegate: SlidePanelViewDelegate?
    
    private let containerView = SlidePanelContainerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeContainerView()
        initializeExitButton()
    }
    
    // MARK :- initialize views
    private func initializeContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:))))
        view.addSubview(containerView)
        
        containerView.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: view.bounds.height).isActive = true
    }
    
    private func initializeExitButton() {
        let exit = UIImageView(image: UIImage(named: "exit"))
        exit.isUserInteractionEnabled = true
        exit.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(exitTapped(_:))))
        exit.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(exit)
        
        exit.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        exit.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
        exit.widthAnchor.constraint(equalToConstant: 36).isActive = true
        exit.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    // MARK :- event handling
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: containerView)
        print(self.view.frame.origin.x)
        switch recognizer.state {
        case .changed:
            UIView.animate(withDuration: 0.2) {
                self.view.center = CGPoint(x: self.view.center.x + translation.x, y: self.view.center.y)
                recognizer.setTranslation(CGPoint.zero, in: self.view)
            }
        case .ended:
            if view.frame.origin.x < view.frame.size.width / 2 {
                UIView.animate(withDuration: 0.6, animations: {
                    self.view.frame.origin.x = 0
                    recognizer.setTranslation(CGPoint.zero, in: self.view)
                })
            } else {
                UIView.animate(withDuration: 0.6, animations: {
                    self.view.frame.origin.x = self.view.frame.maxX
                    recognizer.setTranslation(CGPoint.zero, in: self.view)
                }) { (success) in
                    if success {
                        self.delegate?.panGestureDraggingEnded()
                    }
                }
            }
        default: print("default")
        }
    }
    
    @objc func exitTapped(_ recognizer: UITapGestureRecognizer) {
        delegate?.dismiss()
    }
    
}
