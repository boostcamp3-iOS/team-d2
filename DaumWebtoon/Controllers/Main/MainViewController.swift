//
//  MainViewController.swift
//  DaumWebtoon
//
//  Created by Gaon Kim on 06/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    // MARK: - Properties
    private let tabContents: [TabContent] = [
        TabContent(tabColor: UIColor.brown, tabTitle: "캐시", tabIndex: 0),
        TabContent(tabColor: UIColor.red, tabTitle: "연재", tabIndex: 1),
        TabContent(tabColor: UIColor.purple, tabTitle: "기다무", tabIndex: 2),
        TabContent(tabColor: UIColor.blue, tabTitle: "완결", tabIndex: 3),
        TabContent(tabColor: UIColor.green, tabTitle: "PICK", tabIndex: 4)
    ]
    private var tabBarViewCenterYAnchor: NSLayoutConstraint?
    
    // MARK: Views
    private lazy var splashView = SplashView()
    private lazy var tabBarView = TabBarView()
    private lazy var scrollView = UIScrollView()
    private lazy var tabBarViewContainer = UIView()
    
    // MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        splashView.delegate = self
        scrollView.delegate = self
        tabBarView.dataSource = self
        tabBarView.delegate = self
        
        initScrollView()
        setTabBarViewProperties()
        setSplashViewLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        splashView.animate()
    }
}

// MARK: - Splash View Methods
extension MainViewController {
    func setSplashViewLayout() {
        view.addSubview(splashView)
        view.translatesAutoresizingMaskIntoConstraints = false
        splashView.translatesAutoresizingMaskIntoConstraints = false
        splashView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        splashView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        splashView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        splashView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

// MARK: - Scroll View Methods
extension MainViewController {
    func setScrollViewLayout() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func initScrollView() {
        setScrollViewLayout()
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(
            width: view.frame.width * CGFloat(tabContents.count),
            height: view.frame.height)
    }
    
    func setTabBarViewLayout() {
        scrollView.addSubview(tabBarViewContainer)
        tabBarViewContainer.translatesAutoresizingMaskIntoConstraints = false
        tabBarViewContainer.heightAnchor.constraint(equalToConstant: 30).isActive = true
        tabBarViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        tabBarViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        tabBarViewCenterYAnchor = tabBarViewContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        tabBarViewCenterYAnchor?.isActive = true
        tabBarViewContainer.addSubview(tabBarView)
    }
    
    func setTabBarViewProperties() {
        setTabBarViewLayout()
        tabBarViewContainer.clipsToBounds = true
        tabBarViewContainer.backgroundColor = .red
    }
}

// MARK: - Splash View Delegate
extension MainViewController: SplashViewDelegate {
    func splashViewDidFinished(_ splashView: SplashView) {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else { return }
            self.splashView.alpha = 0
        }, completion: { [weak self] _ in
            guard let self = self else { return }
            self.splashView.removeFromSuperview()
        })
    }
}

// MARK: - Scroll View Delegate
extension MainViewController: UIScrollViewDelegate {
    
}

// MARK: - Tab Bar View Data Source
extension MainViewController: TabBarDataSource {
    func tabContents(_ tabBarView: TabBarView) -> [TabContent] {
        return tabContents
    }
}

// MARK: - Tab Bar View Delegate
extension MainViewController: TabBarDelegate {
    func tabBarView(_ tabBarView: TabBarView, viewControllerAtIndex index: Int?) {
        
    }
}
