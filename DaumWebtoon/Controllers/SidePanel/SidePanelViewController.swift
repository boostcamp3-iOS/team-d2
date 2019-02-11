//
//  SlidePanelViewController.swift
//  DaumWebtoon
//
//  Created by Tak on 09/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

protocol SidePanelViewDelegate: class {
    func dismiss()
}

class SidePanelViewController: UIViewController {

    weak var delegate: SidePanelViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.brown
        
        let image = UIImage(named: "hamberger")
        let hambergerButton = UIImageView(image: image)
        hambergerButton.isUserInteractionEnabled = true
        hambergerButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hambergerButtonTapped(_:))))
        hambergerButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(hambergerButton)

        hambergerButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        hambergerButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        hambergerButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
        hambergerButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    @objc func hambergerButtonTapped(_ recognizer: UITapGestureRecognizer) {
        
    }

}
