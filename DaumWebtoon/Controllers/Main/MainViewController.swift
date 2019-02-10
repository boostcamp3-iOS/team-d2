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
    private var scrollDirection: Direction?
    private var tabBarViewCenterYAnchorConstraint: NSLayoutConstraint?
    
    // MARK: Views
    private lazy var splashView = SplashView()
    private lazy var tabBarView = TabBarView()
    private lazy var scrollView = UIScrollView()
    private lazy var tabBarViewContainer = UIView()
    private lazy var tableView = UITableView()
    
    // MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        addScrollView()
        addTabBarView()
        addTableView()
        addSplashView()
        addPanGestureRecognizer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        splashView.animate()
    }
}

// MARK: - Methods
extension MainViewController {
    // MARK: Splash View Methods
    func addSplashView() {
        splashView.delegate = self
        view.addSubview(splashView)
        setSplashViewLayout()
    }
    
    func setSplashViewLayout() {
        splashView.translatesAutoresizingMaskIntoConstraints = false
        splashView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        splashView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        splashView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        splashView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    // MARK: Scroll View Methods
    func addScrollView() {
        scrollView.delegate = self
        view.addSubview(scrollView)
        setScrollViewLayout()
        setScrollViewProperties()
    }
    
    func setScrollViewLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func setScrollViewProperties() {
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(
            width: view.frame.width * CGFloat(tabContents.count),
            height: view.frame.height)
    }
    
    // MARK: Tab Bar View Methods
    func addTabBarView() {
        tabBarView.dataSource = self
        tabBarView.delegate = self
        scrollView.addSubview(tabBarViewContainer)
        tabBarViewContainer.addSubview(tabBarView)
        tabBarView.showCurrentTabIndicator()
        setTabBarViewLayout()
        setTabBarViewProperties()
    }
    
    func setTabBarViewLayout() {
        tabBarViewContainer.translatesAutoresizingMaskIntoConstraints = false
        tabBarViewContainer.heightAnchor.constraint(equalToConstant: 30).isActive = true
        tabBarViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        tabBarViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        tabBarViewCenterYAnchorConstraint = tabBarViewContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        tabBarViewCenterYAnchorConstraint?.isActive = true
    }
    
    func setTabBarViewProperties() {
        tabBarViewContainer.clipsToBounds = true
        tabBarViewContainer.backgroundColor = .red
    }
    
    // MARK: Table View Methods
    func addTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        scrollView.addSubview(tableView)
        setTableViewLayout()
        setTableViewProperties()
    }
    
    func setTableViewLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: tabBarViewContainer.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func setTableViewProperties() {
        tableView.isScrollEnabled = false
    }
    
    // MARK: Pan Gesture Recognizer Methods
    func addPanGestureRecognizer() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        view.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.delegate = self
    }
    
    @objc func didPan(_ sender: UIPanGestureRecognizer) {
        calculateScrollDirection(sender)
        moveTabBarViewVertically(sender)
    }
    
    func calculateScrollDirection(_ sender: UIPanGestureRecognizer) {
        let velocity = sender.velocity(in: scrollView)
        if abs(velocity.x) > abs(velocity.y) {
            velocity.x < 0 ? (scrollDirection = .left) : (scrollDirection = .right)
        } else {
            velocity.y < 0 ? (scrollDirection = .up) : (scrollDirection = .down)
        }
    }
    
    func moveTabBarViewVertically(_ sender: UIPanGestureRecognizer) {
        guard let direction = scrollDirection,
            let currentTabBarViewCenterYConstant = tabBarViewCenterYAnchorConstraint?.constant,
            (direction == .up || direction == .down) else { return }
        let translation = sender.translation(in: scrollView)
        tabBarViewCenterYAnchorConstraint?.constant = currentTabBarViewCenterYConstant + translation.y
        sender.setTranslation(CGPoint.zero, in: scrollView)
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

// MARK: - Gesture Recognizer Delegate
extension MainViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - Table View Data Source
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 임시 값
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 임시 값
        let cell = UITableViewCell()
        cell.textLabel?.text = "임시 값"
        return cell
    }
}

// MARK: - Table View Delegate
extension MainViewController: UITableViewDelegate {
    
}
