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
    
    private let tabColors: [UIColor] = [
        UIColor.green,
        UIColor.brown,
        UIColor.red,
        UIColor.purple,
        UIColor.blue,
        UIColor.green,
        UIColor.brown]
    
    private let tabTitles = ["", "캐시", "연재", "기다무", "완결", "PICK", ""]
    private let initialIndex = 2
    private let tabHeight: CGFloat = 30.0
    
    private var tabScrollView = UIScrollView()
    private var tabBarContainerView = UIView()
    private var leftToRightAnimationTabBar = UIView()
    private var rightToLeftAnimationTabBar = UIView()
    
    private var isFirst = true
    private var tabTitleLabels: [UILabel] = []
    private var tabViewControllerDictionaries: Dictionary<Int, UIViewController> = [:]
    private var lastContentOffset: CGFloat = 0
    private var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeTabScrollView()
        initializeTabContainer()
        initializeTabs()
        initializeTabViewControllersContentSize()
        
        scrollToTab(currentIndex: initialIndex)
    }
    
    // Mark :- initialize views
    private func initializeTabScrollView() {
        tabScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        tabScrollView.isPagingEnabled = true
        tabScrollView.showsHorizontalScrollIndicator = false
        tabScrollView.showsVerticalScrollIndicator = false
        tabScrollView.backgroundColor = UIColor.white
        tabScrollView.delegate = self
        
        view.addSubview(tabScrollView)
    }
    
    private func initializeTabContainer() {
        tabBarContainerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 20, height: tabHeight))
        tabBarContainerView.backgroundColor = tabColors[2]
        tabBarContainerView.clipsToBounds = true
        
        view.addSubview(tabBarContainerView)
        
        let width = NSLayoutConstraint(
            item: tabBarContainerView,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: UIScreen.main.bounds.width - 20)
        
        let height = NSLayoutConstraint(
            item: tabBarContainerView,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: tabHeight)
        
        let centerX = NSLayoutConstraint(
            item: tabBarContainerView,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: view,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 0)
        
        let centerY = NSLayoutConstraint(
            item: tabBarContainerView,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: view,
            attribute: .centerY,
            multiplier: 1.0,
            constant: 0)
        
        NSLayoutConstraint.activate([width, height, centerX, centerY])
        
        tabBarContainerView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func initializeTabs() {
        let tabWidth = (UIScreen.main.bounds.width - 20) / CGFloat(tabTitles.count - 2)
        
        for (index, tabTitle) in tabTitles.enumerated() {
            let x = CGFloat(index - 1) * tabWidth
            
            let tabLabel = UILabel()
            tabLabel.frame = CGRect(x: x, y: 0, width: tabWidth, height: tabHeight)
            tabLabel.textAlignment = .center
            tabLabel.textColor = UIColor.white
            tabLabel.numberOfLines = 0
            tabLabel.adjustsFontSizeToFitWidth = true
            tabLabel.font = UIFont.systemFont(ofSize: 16)
            tabLabel.alpha = 0.6
            tabLabel.text = tabTitle
            tabLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTabTapped(_:))))
            tabLabel.isUserInteractionEnabled = true
        
            tabTitleLabels.append(tabLabel)
            tabBarContainerView.addSubview(tabLabel)
        }
    }
    
    private func initializeTabViewControllersContentSize() {
        tabScrollView.contentSize = CGSize(
            width: tabScrollView.frame.width * CGFloat(tabViewControllers.count),
            height: tabScrollView.frame.height)
    }
    
    private func tabViewController(tabName: String) -> UIViewController {
        return UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: tabName)
    }
    
    // Mark :- event
    @objc func didTabTapped(_ recognizer: UITapGestureRecognizer) {
        
    }
}

extension TabBarViewController {
    func drawTabBarColorLeftToRightWhileScrolling(x: CGFloat) {
        leftToRightAnimationTabBar.transform = CGAffineTransform(translationX: x, y: 0)
    }
    
    func drawTabBarColorRightToLeftWhileScrolling(x: CGFloat) {
        rightToLeftAnimationTabBar.transform = CGAffineTransform(translationX: -x, y: 0)
    }
    
    func showIndicator(currentIndex: Int, previousIndex: Int) {
        tabTitleLabels[previousIndex].alpha = 0.5
        tabTitleLabels[previousIndex].font = UIFont.systemFont(ofSize: 16.0)
        
        tabTitleLabels[currentIndex].alpha = 1
        tabTitleLabels[currentIndex].font = UIFont.boldSystemFont(ofSize: 16.0)
        
        self.currentIndex = currentIndex
    }
    
    func showCurrentTab(currentIndex: Int) {
        let iframe = CGRect(
            x: tabScrollView.frame.width * CGFloat(currentIndex),
            y: 0,
            width: tabScrollView.frame.width,
            height: tabScrollView.frame.height)
        tabScrollView.setContentOffset(iframe.origin, animated: false)
    }
    
    func loadTabViews(currentIndex: Int) {
        for i in (currentIndex - 1)...(currentIndex + 1) {
            if(i >= 0 && i < tabViewControllers.count) {
                loadTabViewAtIndex(index: i)
            }
        }
    }
    
    func loadTabViewAtIndex(index: Int){
        let tabViewController = tabViewControllers[index]
        tabViewController.view.frame = CGRect(x: tabScrollView.frame.width * CGFloat(index),
                                              y: 0,
                                              width: tabScrollView.frame.width,
                                              height: tabScrollView.frame.height)
        
        if(tabViewControllerDictionaries[index] == nil) {
            tabViewControllerDictionaries[index] = tabViewController
            tabScrollView.addSubview(tabViewControllerDictionaries[index]!.view)
        } else {
            tabViewControllerDictionaries[index] = tabViewController
        }
    }
    
    func loadAnimationTabBar(leftAnimationTabBarIndex: Int, rightAnimationTabBarColorIndex: Int) {
        leftToRightAnimationTabBar = UIView(frame: CGRect(x: -tabScrollView.frame.width, y: 0, width: UIScreen.main.bounds.width, height: tabHeight))
        leftToRightAnimationTabBar.backgroundColor = tabColors[leftAnimationTabBarIndex]
        
        rightToLeftAnimationTabBar = UIView(frame: CGRect(x: tabBarContainerView.frame.width, y: 0, width: UIScreen.main.bounds.width, height: tabHeight))
        rightToLeftAnimationTabBar.backgroundColor = tabColors[rightAnimationTabBarColorIndex]
        
        tabBarContainerView.addSubview(leftToRightAnimationTabBar)
        tabBarContainerView.addSubview(rightToLeftAnimationTabBar)
    }
}

extension TabBarViewController {
    func scrollToTab(currentIndex: Int, previousIndex: Int = 0, contentOffsetX: CGFloat = 0.01) {
        var currentIndex = currentIndex
        var previousIndex = previousIndex
        
        showCurrentTab(currentIndex: currentIndex)
        loadTabViews(currentIndex: currentIndex)
        
        if currentIndex > tabTitles.count - 2 {
            currentIndex = 1
            previousIndex = 5
        } else if currentIndex < 1 {
            currentIndex = tabTitles.count - 2
            previousIndex = 1
        }
        
        showIndicator(currentIndex: currentIndex, previousIndex: previousIndex)
        
        if currentIndex - 1 >= 0 && currentIndex + 1 < tabTitles.count {
            loadAnimationTabBar(leftAnimationTabBarIndex: currentIndex - 1, rightAnimationTabBarColorIndex: currentIndex + 1)
        }
        
        tabTitleLabels.forEach { (label) in
            tabBarContainerView.addSubview(label)
        }
        
        if contentOffsetX == 0.0 ||
            tabScrollView.frame.width * CGFloat(tabViewControllers.count - 1) == contentOffsetX {
            
            showCurrentTab(currentIndex: currentIndex)
        }
    }
}

extension TabBarViewController: UIScrollViewDelegate {
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if isFirst == true {
            isFirst = false
            return
        }
        
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        
        if (lastContentOffset <= scrollView.contentOffset.x) {
            drawTabBarColorRightToLeftWhileScrolling(x: tabScrollView.frame.width)
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
            
            var tabBarAnimationProgress: CGFloat
            switch contentOffset {
            case 0..<width:
                tabBarAnimationProgress = contentOffset
            case width..<width * 2:
                tabBarAnimationProgress = contentOffset - width
            case width * 2..<width * 3:
                tabBarAnimationProgress = contentOffset - width * 2
            case width * 3..<width * 4:
                tabBarAnimationProgress = contentOffset - width * 3
            case width * 4..<width * 5:
                tabBarAnimationProgress = contentOffset - width * 4
            case width * 5..<width * 6:
                tabBarAnimationProgress = contentOffset - width * 5
            case width * 6..<width * 7:
                tabBarAnimationProgress = contentOffset - width * 6
            default: tabBarAnimationProgress = 0.0
            }
            
            if (lastContentOffset > scrollView.contentOffset.x) {
                drawTabBarColorLeftToRightWhileScrolling(x: abs(tabBarAnimationProgress - width))
            } else if (lastContentOffset <= scrollView.contentOffset.x && tabBarAnimationProgress != 0.0) {
                drawTabBarColorRightToLeftWhileScrolling(x: tabBarAnimationProgress)
            }
        }
        
    }
}

