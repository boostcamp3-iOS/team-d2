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
    private let tabBarView = TabBarView()
    
    private var tabScrollView = UIScrollView()
    private var lastContentOffset: CGFloat = 0
    private var contentOffsetInPage: CGFloat = 0
    private var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeTabScrollView()
        initializeTabContainer()
        initializeTabViewControllersContentSize()
        initializeTabViewControllers()
        
        scrollToTab(currentIndex: initialIndex)
    }
    
    // MARK :- initialize views
    private func initializeTabScrollView() {
        tabScrollView = UIScrollView(frame: CGRect(x: 0, y: 0,
                                                   width: UIScreen.main.bounds.width,
                                                   height: UIScreen.main.bounds.height))
        tabScrollView.isPagingEnabled = true
        tabScrollView.showsHorizontalScrollIndicator = false
        tabScrollView.showsVerticalScrollIndicator = false
        tabScrollView.delegate = self

        view.addSubview(tabScrollView)
    }
    
    private func initializeTabContainer() {
        let tabContainerView = UIView()
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
}

extension TabBarViewController: TabBarDataSource {
    func tabContents(_ tabBarView: TabBarView) -> [TabContent] {
        return tabContents
    }
}

extension TabBarViewController: TabBarDelegate {
    func tabBarView(_ tabBarView: TabBarView, viewControllerAtIndex index: Int?, previousIndex: Int) {
        guard let index = index else { return }
        
        showCurrentTab(currentIndex: index)
    }
}

extension TabBarViewController {
    func showCurrentTab(currentIndex: Int, animated: Bool = true) {
        let frame = CGRect(
            x: tabScrollView.frame.width * CGFloat(currentIndex),
            y: 0,
            width: tabScrollView.frame.width,
            height: tabScrollView.frame.height)
        tabScrollView.setContentOffset(frame.origin, animated: animated)
    }
    
    func scrollToTab(currentIndex: Int, previousIndex: Int = 0, contentOffsetX: CGFloat = 0.01) {
        var currentIndex = currentIndex
        var previousIndex = previousIndex
        
        showCurrentTab(currentIndex: currentIndex)
        
        if currentIndex > tabContents.count - 2 {
            currentIndex = 1
            previousIndex = 5
        } else if currentIndex < 1 {
            currentIndex = tabContents.count - 2
            previousIndex = 1
        }
      
        tabBarView.loadAnimationTabBar(leftAnimationTabBarColorIndex: currentIndex - 1,
                                       rightAnimationTabBarColorIndex: currentIndex + 1)
        tabBarView.showEachTabs(currentIndex: currentIndex)
        tabBarView.showCurrentTabIndicator(currentIndex: currentIndex, previousIndex: previousIndex)
        
        if contentOffsetX == 0.0 ||
            tabScrollView.frame.width * CGFloat(tabContents.count - 1) == contentOffsetX {
            showCurrentTab(currentIndex: currentIndex, animated: false)
        }
    }
}

extension TabBarViewController: UIScrollViewDelegate {
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if contentOffsetInPage < UIScreen.main.bounds.width / 2 { return }
        
        NSObject.cancelPreviousPerformRequests(withTarget: self)

        if lastContentOffset <= scrollView.contentOffset.x {
            tabBarView.drawTabBarColorRightToLeftWhileScrolling(x: tabScrollView.frame.width)
        }
        
        let nextTabIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
        
        scrollToTab(currentIndex: Int(nextTabIndex), previousIndex: Int(currentIndex), contentOffsetX: scrollView.contentOffset.x)
        
        lastContentOffset = scrollView.contentOffset.x
    }

    //http://stackoverflow.com/a/1857162
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView.isTracking || scrollView.isDragging || scrollView.isDecelerating) {
            NSObject.cancelPreviousPerformRequests(withTarget: scrollView)
            perform(#selector(scrollViewDidEndScrollingAnimation(_:)), with: scrollView, afterDelay: 0.0)
        }
        
        let scrollWidth = self.tabScrollView.frame.width
        let contentOffset = scrollView.contentOffset.x
        let nextTabIndex = round(contentOffset / scrollWidth)
        
        let contentOffsetInPage = contentOffset - scrollWidth * floor(contentOffset / scrollWidth)
        if self.lastContentOffset > contentOffset {
            self.tabBarView.drawTabBarColorLeftToRightWhileScrolling(x: abs(contentOffsetInPage - scrollWidth))
            self.contentOffsetInPage = abs(contentOffsetInPage - scrollWidth)
        } else if self.lastContentOffset <= contentOffset && contentOffsetInPage != 0.0 {
            self.tabBarView.drawTabBarColorRightToLeftWhileScrolling(x: contentOffsetInPage)
            self.contentOffsetInPage = contentOffsetInPage
        }
        
        self.tabBarView.showCurrentTabIndicator(currentIndex: Int(nextTabIndex), previousIndex: self.currentIndex)
        
        self.currentIndex = Int(nextTabIndex)
    }
}

