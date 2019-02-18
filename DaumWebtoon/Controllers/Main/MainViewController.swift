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
        TabContent(tabColor: UIColor.blue, tabTitle: "", tabIndex: 0),
        TabContent(tabColor: UIColor.red, tabTitle: "캐시", tabIndex: 1),
        TabContent(tabColor: UIColor.brown, tabTitle: "연재", tabIndex: 2),
        TabContent(tabColor: UIColor.purple, tabTitle: "기다무", tabIndex: 3),
        TabContent(tabColor: UIColor.blue, tabTitle: "완결", tabIndex: 4),
        TabContent(tabColor: UIColor.red, tabTitle: "", tabIndex: 5)
    ]
    private enum Genre: Int {
        case webDesign = 140
        case programming = 143
        case vrAndAr = 139
        case startup = 157
    }
    private let genres: [Genre?] = [nil, .webDesign, .programming, .vrAndAr, .startup, nil]
    private var scrollDirection: Direction?
    private var tabBarViewCenterYAnchorConstraint: NSLayoutConstraint?
    private var tabBarViewTopAnchorConstraint: NSLayoutConstraint?
    private let menuViewHeight: CGFloat = 80
    private lazy var tabBarViewWidth: CGFloat = view.frame.width - 20
    private lazy var tabBarViewHeight: CGFloat = 30
    private var lastContentOffset: CGFloat = 0
    private var contentOffsetInPage: CGFloat = 0
    private var currentIndex = 1
    private var isSplashViewDidAppear = false
    
    // MARK: Views
    private lazy var splashView = SplashView()
    private lazy var tabBarView = {
        return TabBarView(frame: CGRect(x: 0.0, y: 0.0, width: tabBarViewWidth, height: tabBarViewHeight))
    } ()
    private lazy var scrollView = UIScrollView()
    private lazy var scrollContentView = UIView()
    private lazy var tabBarViewContainer = UIView()
    private lazy var tableView = UITableView()
    private lazy var menuView = UIView()
    private lazy var tableStackView = UIStackView()
    lazy var headerView = HeaderView()
    
    // MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        addScrollView()
        addMenuView()
        addTabBarView()
        addTableStackView()
        addContentViewControllers()
        addHeaderView()
        addSplashView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showCurrentTab(currentIndex: currentIndex)
        animateSplashViewIfViewDidNotAppeared()
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
    
    func animateSplashViewIfViewDidNotAppeared() {
        if !isSplashViewDidAppear {
            isSplashViewDidAppear.toggle()
            splashView.animate()
        }
    }
    
    // MARK: Header View Methods
    func addHeaderView() {
        view.addSubview(headerView)
        headerView.symbolView.dataSource = self
        setHeaderViewLayout()
    }
    
    func setHeaderViewLayout() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: menuView.bottomAnchor).isActive = true
        headerView.bottomAnchor.constraint(lessThanOrEqualTo: tabBarViewContainer.topAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    // MARK: Scroll View Methods
    func addScrollView() {
        scrollView.delegate = self
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        setScrollViewLayout()
        setScrollViewProperties()
    }
    
    func setScrollViewLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        let widthAnchor = scrollContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        scrollContentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        widthAnchor.priority = .defaultLow
        widthAnchor.isActive = true
    }
    
    func setScrollViewProperties() {
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
    }
    
    // MARK: Tab Bar View Methods
    func addTabBarView() {
        tabBarView.dataSource = self
        tabBarView.delegate = self
        scrollContentView.addSubview(tabBarViewContainer)
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
        tabBarViewCenterYAnchorConstraint?.priority = .defaultLow
        tabBarViewCenterYAnchorConstraint?.isActive = true
        tabBarViewContainer.centerYAnchor.constraint(lessThanOrEqualTo: view.centerYAnchor).isActive = true
        tabBarViewContainer.centerYAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: menuViewHeight + (tabBarViewHeight / 2)).isActive = true
        tabBarViewTopAnchorConstraint?.isActive = true
    }
    
    func setTabBarViewProperties() {
        tabBarViewContainer.clipsToBounds = true
        tabBarViewContainer.backgroundColor = .red
    }
    
    func adjustIndexForIndex(currentIndex: Int, previousIndex: Int) -> (Int, Int) {
        if currentIndex > tabContents.count - 2 {
            return (1, tabContents.count - 2)
        } else if currentIndex < 1 {
            return (tabContents.count - 2, 1)
        } else {
            return (currentIndex, previousIndex)
        }
    }
    
    func isInvisibleTabForIndex(contentOffset: CGFloat) -> Bool {
        return contentOffset <= 0.0 ||
            contentOffset >= scrollView.frame.width * CGFloat(tabContents.count - 1)
            ? true : false
    }
    
    func showCurrentTab(currentIndex: Int, animated: Bool = true) {
        let frame = CGRect(
            x: scrollView.frame.width * CGFloat(currentIndex),
            y: 0,
            width: scrollView.frame.width,
            height: scrollView.frame.height)
        scrollView.setContentOffset(frame.origin, animated: animated)
        
        lastContentOffset = scrollView.frame.width * CGFloat(currentIndex)
    }
    
    func scrollToTab(currentIndex: Int, previousIndex: Int = 0) {
        let index = adjustIndexForIndex(currentIndex: currentIndex, previousIndex: previousIndex)
        tabBarView.showEachTabs(currentIndex: index.0)
        tabBarView.showCurrentTabIndicator(currentIndex: index.0, previousIndex: index.1)
    }
    
    // MARK: Menu View Methods
    func addMenuView() {
        view.addSubview(menuView)
        setMenuViewLayout()
        setupSearchView()
    }
    
    func setMenuViewLayout() {
        menuView.translatesAutoresizingMaskIntoConstraints = false
        menuView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        menuView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        menuView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        menuView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    func setupSearchView() {
        let search = UIButton()
        search.addTarget(self, action: #selector(searchTapped(_:)), for: .touchUpInside)
        search.setImage(UIImage(named: "search"), for: .normal)
        menuView.addSubview(search)
        
        search.translatesAutoresizingMaskIntoConstraints = false
        search.widthAnchor.constraint(equalToConstant: 24).isActive = true
        search.heightAnchor.constraint(equalToConstant: 24).isActive = true
        search.trailingAnchor.constraint(equalTo: menuView.trailingAnchor, constant: -70).isActive = true
        search.centerYAnchor.constraint(equalTo: menuView.centerYAnchor).isActive = true
    }
    
    @objc func searchTapped(_ sender: UIButton) {
        let searchViewController = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier: "Search")
        present(searchViewController, animated: false, completion: nil)
    }
    
    // MARK: Content View Controller Methods
    func addContentViewControllers() {
        for index in 0..<tabContents.count {
            let contentViewController = ContentViewController()
            contentViewController.genre = genres[index]?.rawValue
            addChild(contentViewController)
            contentViewController.didMove(toParent: self)
            tableStackView.addArrangedSubview(contentViewController.view)
            contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
            contentViewController.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        }
    }
    
    // MARK: Table Stack View Methods
    func addTableStackView() {
        scrollContentView.addSubview(tableStackView)
        setTableStackViewLayout()
    }
    
    func setTableStackViewLayout() {
        tableStackView.translatesAutoresizingMaskIntoConstraints = false
        tableStackView.topAnchor.constraint(equalTo: tabBarViewContainer.bottomAnchor).isActive = true
        tableStackView.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor).isActive = true
        tableStackView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor).isActive = true
        tableStackView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor).isActive = true
        tableStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: CGFloat(tabContents.count)).isActive = true
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
        let topLimit = menuViewHeight + (tabBarViewHeight / 2) - (scrollView.frame.height / 2)
        if currentTabBarViewCenterYConstant >= CGFloat(0), direction == .down {
            tableView.isScrollEnabled = true
            tabBarViewCenterYAnchorConstraint?.constant = 0
        } else if currentTabBarViewCenterYConstant <= topLimit, direction == .up {
            tableView.isScrollEnabled = true
            tabBarViewCenterYAnchorConstraint?.constant = topLimit
        } else if currentTabBarViewCenterYConstant <= topLimit,
            tableView.contentOffset.y > 0, direction == .down {
            tableView.isScrollEnabled = true
            tabBarViewCenterYAnchorConstraint?.constant = topLimit
        } else {
            tableView.isScrollEnabled = false
            let translation = sender.translation(in: scrollView)
            tabBarViewCenterYAnchorConstraint?.constant = currentTabBarViewCenterYConstant + translation.y
            sender.setTranslation(CGPoint.zero, in: scrollView)
        }
        print(currentTabBarViewCenterYConstant)
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
            self.addPanGestureRecognizer()
        })
    }
}

// MARK: - Scroll View Delegate
extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard contentOffsetInPage >= UIScreen.main.bounds.width / 2 else { return }
        
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        
        if lastContentOffset <= scrollView.contentOffset.x {
            tabBarView.drawTabBarColorRightToLeftWhileScrolling(x: scrollView.frame.width, currentIndex: currentIndex - 1)
        }
        
        let nextTabIndex = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        showCurrentTab(currentIndex: nextTabIndex)
        scrollToTab(currentIndex: nextTabIndex, previousIndex: currentIndex)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollWidth = scrollView.frame.width
        let contentOffset = scrollView.contentOffset.x
        var nextTabIndex = Int(round(contentOffset / scrollWidth))
        if nextTabIndex == 0 {
            nextTabIndex = tabContents.count - 2
        } else if nextTabIndex == tabContents.count - 1 {
            nextTabIndex = 1
        }
        
        slideSymbol(with: contentOffset / scrollWidth - 1)
        
        let contentOffsetInPage = contentOffset - scrollWidth * floor(contentOffset / scrollWidth)
        if (scrollView.isTracking || scrollView.isDragging || scrollView.isDecelerating),
            let direction = scrollDirection, (direction == .left || direction == .right) {
            NSObject.cancelPreviousPerformRequests(withTarget: scrollView)
            perform(#selector(scrollViewDidEndScrollingAnimation(_:)), with: scrollView, afterDelay: 0.0)
            
            if lastContentOffset > contentOffset {
                let index = contentOffsetInPage >= view.bounds.width / 2 ? nextTabIndex : nextTabIndex + 1
                tabBarView.drawTabBarColorLeftToRightWhileScrolling(x: abs(contentOffsetInPage - scrollWidth), currentIndex: index)
                self.contentOffsetInPage = abs(contentOffsetInPage - scrollWidth)
            } else if lastContentOffset <= contentOffset && contentOffsetInPage != 0.0 {
                let index = contentOffsetInPage >= view.bounds.width / 2 ? nextTabIndex - 1 : nextTabIndex
                tabBarView.drawTabBarColorRightToLeftWhileScrolling(x: contentOffsetInPage, currentIndex: index)
                self.contentOffsetInPage = contentOffsetInPage
            }
        } else {
            if lastContentOffset > contentOffset {
                let index = contentOffsetInPage >= view.bounds.width / 2 ? nextTabIndex - 1 : nextTabIndex
                tabBarView.drawTabBarColorRightToLeftWhileScrolling(x: contentOffsetInPage, currentIndex: index)
                self.contentOffsetInPage = contentOffsetInPage
            } else if lastContentOffset <= contentOffset && contentOffsetInPage != 0.0 {
                let index = contentOffsetInPage >= view.bounds.width / 2 ? nextTabIndex : nextTabIndex + 1
                tabBarView.drawTabBarColorLeftToRightWhileScrolling(x: abs(contentOffsetInPage - scrollWidth), currentIndex: index)
                self.contentOffsetInPage = abs(contentOffsetInPage - scrollWidth)
            }
        }
        
        tabBarView.showEachTabs(currentIndex: currentIndex)
        tabBarView.showCurrentTabIndicator(currentIndex: nextTabIndex, previousIndex: currentIndex)
        if isInvisibleTabForIndex(contentOffset: contentOffset) {
            showCurrentTab(currentIndex: nextTabIndex, animated: false)
        }
        
        currentIndex = Int(nextTabIndex)
    }
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
        guard let index = index else { return }
        
        showCurrentTab(currentIndex: index)
    }
}

// MARK: - Gesture Recognizer Delegate
extension MainViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
