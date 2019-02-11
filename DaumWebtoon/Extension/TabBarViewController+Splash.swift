//
//  TabBarViewController+Splash.swift
//  DaumWebtoon
//
//  Created by oingbong on 11/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

extension TabBarViewController: SplashViewDelegate {
    func splashViewDidFinished(_ splashView: SplashView) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.splashView.alpha = 0
        }
    }
}
