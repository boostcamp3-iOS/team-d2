//
//  TabBarViewController.swift
//  DaumWebtoon
//
//  Created by Tak on 29/01/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

class TabBarViewController: UIViewController {
 
    private let tabContents: [TabContent] = [
        TabContent(tabColor: UIColor.green, tabTitle: "", tabIndex: 0),
        TabContent(tabColor: UIColor.brown, tabTitle: "캐시", tabIndex: 1),
        TabContent(tabColor: UIColor.red, tabTitle: "연재", tabIndex: 2),
        TabContent(tabColor: UIColor.purple, tabTitle: "기다무", tabIndex: 3),
        TabContent(tabColor: UIColor.blue, tabTitle: "완결", tabIndex: 4),
        TabContent(tabColor: UIColor.green, tabTitle: "PICK", tabIndex: 5),
        TabContent(tabColor: UIColor.brown, tabTitle: "", tabIndex: 6)
    ]
    
    private let initialIndex = 2
    private let tabWidth = UIScreen.main.bounds.width - 20
    private let tabHeight: CGFloat = 30.0
    private var sidePanelViewController = SidePanelViewController()
    private let tabBarView = TabBarView()
    private let tabContainerView = UIView()
    private let tabScrollView = UIScrollView(frame: CGRect(x: 0, y: 0,
                                                           width: UIScreen.main.bounds.width,
                                                           height: UIScreen.main.bounds.height))
    private var lastContentOffset: CGFloat = 0
    private var contentOffsetInPage: CGFloat = 0
    private var currentIndex = 0
    private var sidePanelBaseView: UIView!
    private var baseViewMaxX: CGFloat = 0.0
    private var scrollViewPanGestureRecognizer: UIPanGestureRecognizer?
    private var screenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self,
                                                                                  action: #selector(handleScreenEdgePanGesture(recognizer:)))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeTabScrollView()
        initializeTabContainer()
        initializeTabViewControllersContentSize()
        initializeTabViewControllers()
        initializeHambergerButton()
        initializeSidePanelView()
        
        showCurrentTab(currentIndex: initialIndex)
        scrollToTab(currentIndex: initialIndex)
    }
    
    // MARK :- initialize views
    private func initializeTabScrollView() {
        tabScrollView.isPagingEnabled = true
        tabScrollView.showsHorizontalScrollIndicator = false
        tabScrollView.showsVerticalScrollIndicator = false
        tabScrollView.delegate = self
        
        screenEdgePanGestureRecognizer.edges = UIRectEdge.right
        screenEdgePanGestureRecognizer.delegate = self
        
        tabScrollView.isUserInteractionEnabled = true
        tabScrollView.addGestureRecognizer(screenEdgePanGestureRecognizer)
        
        view.addSubview(tabScrollView)
        
        scrollViewPanGestureRecognizer = tabScrollView.panGestureRecognizer
    }
    
    private func initializeTabContainer() {
        tabContainerView.clipsToBounds = true
        tabContainerView.backgroundColor = UIColor.red
        tabContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tabContainerView)
        
        tabContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tabContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        tabContainerView.widthAnchor.constraint(equalToConstant: tabWidth).isActive = true
        tabContainerView.heightAnchor.constraint(equalToConstant: tabHeight).isActive = true
        
        tabBarView.dataSource = self
        tabBarView.delegate = self
        
        tabContainerView.addSubview(tabBarView)
    }
    
    private func initializeTabViewControllersContentSize() {
        tabScrollView.contentSize = CGSize(
            width: tabScrollView.frame.width * CGFloat(tabContents.count),
            height: tabScrollView.frame.height)
    }
    
    private func initializeTabViewControllers() {
        for index in 0..<tabContents.count {
            let tabViewController = TabViewController()
            
            addChild(tabViewController)
            tabScrollView.addSubview(tabViewController.view)
            tabViewController.didMove(toParent: self)
            tabViewController.view.frame = CGRect(x: tabScrollView.frame.width * CGFloat(index),
                                                  y: 0,
                                                  width: tabScrollView.frame.width,
                                                  height: tabScrollView.frame.height)
        }
    }
    
    private func initializeHambergerButton() {
        let image = UIImage(named: "hamberger")
        let hambergerButton = UIImageView(image: image)
        hambergerButton.isUserInteractionEnabled = true
        hambergerButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hambergerButtonTapped(_:))))
        hambergerButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(hambergerButton)
        
        hambergerButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        hambergerButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
        hambergerButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
        hambergerButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    private func initializeSidePanelView() {
        sidePanelBaseView = UIView(frame: CGRect(x: view.bounds.size.width, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
        sidePanelBaseView.backgroundColor = UIColor.clear
        baseViewMaxX = sidePanelBaseView.frame.maxX
        
        addChild(sidePanelViewController)
        sidePanelViewController.didMove(toParent: self)
        sidePanelViewController.view.frame = CGRect(x: 0, y: 0, width: sidePanelBaseView.bounds.size.width, height: sidePanelBaseView.bounds.size.height)
        sidePanelViewController.delegate = self
        sidePanelBaseView.addSubview(sidePanelViewController.view)
        
        view.addSubview(sidePanelBaseView)
        view.bringSubviewToFront(sidePanelBaseView)
    }
    
    // MARK :- private methods
    private func adjustIndexForIndex(currentIndex: Int, previousIndex: Int) -> (Int, Int) {
        if currentIndex > tabContents.count - 2 {
            return (1, 5)
        } else if currentIndex < 1 {
            return (tabContents.count - 2, 1)
        } else {
            return (currentIndex, previousIndex)
        }
    }
    
    private func isInvisibleTabForIndex(contentOffset: CGFloat) -> Bool {
        return contentOffset <= 0.0 ||
            contentOffset >= tabScrollView.frame.width * CGFloat(tabContents.count - 1)
            ? true : false
    }
    
    // MARK :- event handling
    @objc func hambergerButtonTapped(_ recognizer: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.5) {
            self.sidePanelBaseView.frame.origin.x = 0
        }
    }
    
    @objc func handleScreenEdgePanGesture(recognizer: UIScreenEdgePanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        
        switch recognizer.state {
        case .changed:
            UIView.animate(withDuration: 0.2) {
                self.sidePanelBaseView.center = CGPoint(x: self.sidePanelBaseView.center.x + translation.x, y: self.sidePanelBaseView.center.y)
                recognizer.setTranslation(CGPoint.zero, in: self.sidePanelBaseView)
            }
        case .ended:
            if self.sidePanelBaseView.frame.origin.x < view.frame.size.width / 2 {
                UIView.animate(withDuration: 0.6, animations: {
                    self.sidePanelBaseView.frame.origin.x = 0
                    recognizer.setTranslation(CGPoint.zero, in: self.sidePanelBaseView)
                })
            } else {
                UIView.animate(withDuration: 0.6, animations: {
                    self.sidePanelBaseView.frame.origin.x = self.baseViewMaxX
                    recognizer.setTranslation(CGPoint.zero, in: self.sidePanelBaseView)
                }) { (success) in
                    if success {
                        self.removeSidePanelView()
                        self.initializeSidePanelView()
                    }
                }
            }
        default: print("default")
        }
    }
}

extension TabBarViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension TabBarViewController: SidePanelViewDelegate {
    func dismiss() {
        UIView.animate(withDuration: 0.6, animations: {
            self.sidePanelBaseView.frame.origin.x = self.baseViewMaxX
        }) { (success) in
            if success {
                self.removeSidePanelView()
                self.initializeSidePanelView()
            }
        }
    }
    
    func panGestureDraggingEnded() {
        removeSidePanelView()
        initializeSidePanelView()
    }
}

extension TabBarViewController: TabBarDataSource {
    func tabContents(_ tabBarView: TabBarView) -> [TabContent] {
        return tabContents
    }
}

extension TabBarViewController: TabBarDelegate {
    func tabBarView(_ tabBarView: TabBarView, viewControllerAtIndex index: Int?) {
        guard let index = index else { return }
        
        showCurrentTab(currentIndex: index)
    }
}

extension TabBarViewController {
    func removeSidePanelView() {
        sidePanelViewController.willMove(toParent: nil)
        sidePanelViewController.view.removeFromSuperview()
        sidePanelViewController.removeFromParent()
        
        sidePanelBaseView.willRemoveSubview(sidePanelViewController.view)
        sidePanelBaseView.removeFromSuperview()
    }
    
    func showCurrentTab(currentIndex: Int, animated: Bool = true) {
        let frame = CGRect(
            x: tabScrollView.frame.width * CGFloat(currentIndex),
            y: 0,
            width: tabScrollView.frame.width,
            height: tabScrollView.frame.height)
        tabScrollView.setContentOffset(frame.origin, animated: animated)
        
        lastContentOffset = tabScrollView.frame.width * CGFloat(currentIndex)
    }
    
    func scrollToTab(currentIndex: Int, previousIndex: Int = 0) {
        let index = adjustIndexForIndex(currentIndex: currentIndex, previousIndex: previousIndex)
        tabBarView.showEachTabs(currentIndex: index.0)
        tabBarView.showCurrentTabIndicator(currentIndex: index.0, previousIndex: index.1)
    }
}

extension TabBarViewController: UIScrollViewDelegate {
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard contentOffsetInPage >= UIScreen.main.bounds.width / 2 else { return }
        
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        
        if lastContentOffset <= scrollView.contentOffset.x {
            tabBarView.drawTabBarColorRightToLeftWhileScrolling(x: tabScrollView.frame.width, currentIndex: currentIndex - 1)
        }
        
        let nextTabIndex = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        showCurrentTab(currentIndex: nextTabIndex)
        scrollToTab(currentIndex: nextTabIndex, previousIndex: currentIndex)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isEdgeScrolling == false else { return }
        
        let scrollWidth = tabScrollView.frame.width
        let contentOffset = scrollView.contentOffset.x
        var nextTabIndex = Int(round(contentOffset / scrollWidth))
        if nextTabIndex == 0 {
            nextTabIndex = 5
        } else if nextTabIndex == tabContents.count - 1 {
            nextTabIndex = 1
        }
        
        let contentOffsetInPage = contentOffset - scrollWidth * floor(contentOffset / scrollWidth)
        if(scrollView.isTracking || scrollView.isDragging || scrollView.isDecelerating) {
            NSObject.cancelPreviousPerformRequests(withTarget: scrollView)
            perform(#selector(scrollViewDidEndScrollingAnimation(_:)), with: scrollView, afterDelay: 0.0)
            
            if lastContentOffset > contentOffset {
                let index = contentOffsetInPage >= UIScreen.main.bounds.width / 2 ? nextTabIndex : nextTabIndex + 1
                tabBarView.drawTabBarColorLeftToRightWhileScrolling(x: abs(contentOffsetInPage - scrollWidth), currentIndex: index)
                self.contentOffsetInPage = abs(contentOffsetInPage - scrollWidth)
            } else if lastContentOffset <= contentOffset && contentOffsetInPage != 0.0 {
                let index = contentOffsetInPage >= UIScreen.main.bounds.width / 2 ? nextTabIndex - 1 : nextTabIndex
                tabBarView.drawTabBarColorRightToLeftWhileScrolling(x: contentOffsetInPage, currentIndex: index)
                self.contentOffsetInPage = contentOffsetInPage
            }
        } else {
            if lastContentOffset > contentOffset {
                let index = contentOffsetInPage >= UIScreen.main.bounds.width / 2 ? nextTabIndex - 1 : nextTabIndex
                tabBarView.drawTabBarColorRightToLeftWhileScrolling(x: contentOffsetInPage, currentIndex: index)
                self.contentOffsetInPage = contentOffsetInPage
            } else if lastContentOffset <= contentOffset && contentOffsetInPage != 0.0 {
                let index = contentOffsetInPage >= UIScreen.main.bounds.width / 2 ? nextTabIndex : nextTabIndex + 1
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

