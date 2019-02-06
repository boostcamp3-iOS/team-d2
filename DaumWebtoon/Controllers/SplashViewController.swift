//
//  SplashViewController.swift
//  DaumWebtoon
//
//  Created by Gaon Kim on 28/01/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    lazy var splashView = SplashView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        splashView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setSplashViewLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        splashView.animate()
    }
    
    func setSplashViewLayout() {
        view.addSubview(splashView)
        splashView.frame = view.bounds
    }

}

// MARK: - Splash View Delegate
extension SplashViewController: SplashViewDelegate {
    func splashViewDidFinished(_ splashView: SplashView) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.splashView.alpha = 0
        }
    }

    func presentTabBarViewController() {
        let tabBarViewController = TabBarViewController()
        present(tabBarViewController, animated: false, completion: nil)
    }
}
