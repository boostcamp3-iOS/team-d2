//
//  TabBarViewController.swift
//  DaumWebtoon
//
//  Created by Tak on 29/01/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

class TabBarViewController: UIViewController {
    
    private lazy var tabViewControllers: [UIViewController] = {
        return [tabViewController(tabName: "Pick"),
                tabViewController(tabName: "Cache"),
                tabViewController(tabName: "Series"),
                tabViewController(tabName: "ComingSoonFree"),
                tabViewController(tabName: "Completion"),
                tabViewController(tabName: "Pick"),
                tabViewController(tabName: "Cache")]
    } ()
    
    private let tabContents: [TabContent] = [
        TabContent(tabColor: UIColor.green, tabTitle: ""),
        TabContent(tabColor: UIColor.brown, tabTitle: "캐시"),
        TabContent(tabColor: UIColor.red, tabTitle: "연재"),
        TabContent(tabColor: UIColor.purple, tabTitle: "기다무"),
        TabContent(tabColor: UIColor.blue, tabTitle: "완결"),
        TabContent(tabColor: UIColor.green, tabTitle: "PICK"),
        TabContent(tabColor: UIColor.brown, tabTitle: "")
    ]
    
    private let initialIndex = 2
    private let tabWidth = UIScreen.main.bounds.width - 20
    private let tabHeight: CGFloat = 30.0
    
    private var tabScrollView = UIScrollView()
    private let tabBarView = TabBarView()
    
    private var isFirst = true
    private var tabViewControllerDictionaries: Dictionary<Int, UIViewController> = [:]
    private var lastContentOffset: CGFloat = 0
    private var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeTabScrollView()
        initializeTabContainer()
        initializeTabViewControllersContentSize()
        
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
        tabScrollView.backgroundColor = UIColor.white
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
        
        tabBarView.clipsToBounds = true
        tabBarView.dataSource = self
        
        tabContainerView.addSubview(tabBarView)
    }
    
    private func initializeTabViewControllersContentSize() {
        tabScrollView.contentSize = CGSize(
            width: tabScrollView.frame.width * CGFloat(tabViewControllers.count),
            height: tabScrollView.frame.height)
    }
    
    private func tabViewController(tabName: String) -> UIViewController {
        return UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: tabName)
    }
    
    // MARK :- event
    @objc func didTabTapped(_ recognizer: UITapGestureRecognizer) {
        
    }
}

extension TabBarViewController: TabBarDataSource {
    func tabContents(_ tabBarView: TabBarView) -> [TabContent] {
        return tabContents
    }
}

extension TabBarViewController {
    func showCurrentTab(currentIndex: Int) {
        let iframe = CGRect(
            x: tabScrollView.frame.width * CGFloat(currentIndex),
            y: 0,
            width: tabScrollView.frame.width,
            height: tabScrollView.frame.height)
        tabScrollView.setContentOffset(iframe.origin, animated: false)
    }
    
    func loadTabViews(currentIndex: Int) {
        for i in max(0, currentIndex - 1)...min(currentIndex + 1, tabViewControllers.count) {
            loadTabViewAtIndex(index: i)
        }
    }
    
    func loadTabViewAtIndex(index: Int) {
        let tabViewController = tabViewControllers[index]
        tabViewController.view.frame = CGRect(x: tabScrollView.frame.width * CGFloat(index),
                                              y: 0,
                                              width: tabScrollView.frame.width,
                                              height: tabScrollView.frame.height)

        if tabViewControllerDictionaries[index] == nil {
            tabViewControllerDictionaries[index] = tabViewController
            tabScrollView.addSubview(tabViewController.view)
        } else {
            tabViewControllerDictionaries[index] = tabViewController
        }
    }
}

extension TabBarViewController {
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
        
        loadTabViews(currentIndex: currentIndex)
        
        if currentIndex - 1 >= 0 && currentIndex + 1 < tabContents.count {
            tabBarView.loadAnimationTabBar(leftAnimationTabBarColorIndex: currentIndex - 1, rightAnimationTabBarColorIndex: currentIndex + 1)
        }
        
        tabBarView.showEachTabs(currentIndex: currentIndex, status: .inProgress)
        tabBarView.showCurrentTabIndicator(currentIndex: currentIndex, previousIndex: previousIndex)
        
        if contentOffsetX == 0.0 ||
            tabScrollView.frame.width * CGFloat(tabViewControllers.count - 1) == contentOffsetX {
            showCurrentTab(currentIndex: currentIndex)
        }
        
        self.currentIndex = currentIndex
    }
}

extension TabBarViewController: UIScrollViewDelegate {
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if isFirst == true {
            isFirst = false
            return
        }
        
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        
        if lastContentOffset <= scrollView.contentOffset.x {
            tabBarView.drawTabBarColorRightToLeftWhileScrolling(x: tabScrollView.frame.width)
        }
        
        let nextTabIndex = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        
        scrollToTab(currentIndex: Int(nextTabIndex), previousIndex: Int(currentIndex), contentOffsetX: scrollView.contentOffset.x)
        
        lastContentOffset = scrollView.contentOffset.x
    }

    //http://stackoverflow.com/a/1857162
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView.isTracking || scrollView.isDragging || scrollView.isDecelerating) {
            NSObject.cancelPreviousPerformRequests(withTarget: scrollView)
            perform(#selector(scrollViewDidEndScrollingAnimation(_:)), with: scrollView, afterDelay: 0.0)
            
            let width = tabScrollView.frame.width
            let contentOffset = scrollView.contentOffset.x
            
            let tabBarAnimationProgress = contentOffset - width * floor(contentOffset / width)
            if lastContentOffset > scrollView.contentOffset.x {
                tabBarView.drawTabBarColorLeftToRightWhileScrolling(x: abs(tabBarAnimationProgress - width))
            } else if lastContentOffset <= scrollView.contentOffset.x && tabBarAnimationProgress != 0.0 {
                tabBarView.drawTabBarColorRightToLeftWhileScrolling(x: tabBarAnimationProgress)
            }
        }
    }
}

