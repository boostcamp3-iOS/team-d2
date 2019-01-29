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
        return [tabViewController(tabName: "Cache"),
                tabViewController(tabName: "Series"),
                tabViewController(tabName: "ComingSoonFree"),
                tabViewController(tabName: "Completion"),
                tabViewController(tabName: "Pick")]
    } ()
    
    private let tabColors: [UIColor] = [
        UIColor.brown,
        UIColor.red,
        UIColor.purple,
        UIColor.blue,
        UIColor.green]
    
    private let tabTitles = ["캐시", "연재", "기다무", "완결", "PICK"]
    private let initialIndex = 2
    private let tabHeight: CGFloat = 35.0
    
    private var pageContainerScrollView: UIScrollView!
    private var tabContainer: UIView!
    private var tabViews: [UILabel] = []
    private var itemViews: Dictionary<Int, UIViewController> = [:]
    private var lastContentOffset: CGFloat = 0
    private var contentOffset: CGFloat = 0
    private var currentPosition = 0
    private var isFirst = true
    private var limit: CGFloat!
    private var currentIndex = 0
    private var leftToRightAnimationTabBar: UIView!
    private var rightToLeftAnimationTabBar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
        setupTabContainer()
        setupAnimationTabBar()
        setupTabs()
        setupTabViews()
        
        scrollToPage(currentPage: initialIndex, previousIndex: 0)
    }
    
    private func setupScrollView() {
        pageContainerScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        pageContainerScrollView.isPagingEnabled = true
        pageContainerScrollView.showsHorizontalScrollIndicator = false
        pageContainerScrollView.showsVerticalScrollIndicator = false
        pageContainerScrollView.backgroundColor = UIColor.white
        pageContainerScrollView.delegate = self
        
        view.addSubview(pageContainerScrollView)
    }
    
    private func setupTabContainer() {
        tabContainer = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: tabHeight))
        
        tabContainer.clipsToBounds = true
        
        view.addSubview(tabContainer)
        
        let width = NSLayoutConstraint(
            item: tabContainer,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: UIScreen.main.bounds.width - 32)
        
        let height = NSLayoutConstraint(
            item: tabContainer,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: tabHeight)
        
        let centerX = NSLayoutConstraint(
            item: tabContainer,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: view,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 0)
        
        let centerY = NSLayoutConstraint(
            item: tabContainer,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: view,
            attribute: .centerY,
            multiplier: 1.0,
            constant: 0)
        
        NSLayoutConstraint.activate([width, height, centerX, centerY])
        
        tabContainer.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupTabs() {
        let tabWidth = (UIScreen.main.bounds.width - 32) / CGFloat(tabTitles.count)
        
        for (index, tabTitle) in tabTitles.enumerated() {
            let x = CGFloat(index) * tabWidth
            
            let tabLabel = UILabel()
            tabLabel.frame = CGRect(x: x, y: 0, width: tabWidth, height: tabHeight)
            tabLabel.textAlignment = .center
            tabLabel.textColor = UIColor.white
            tabLabel.numberOfLines = 0
            tabLabel.adjustsFontSizeToFitWidth = true
            tabLabel.font = UIFont.systemFont(ofSize: 16)
            tabLabel.alpha = 0.6
            tabLabel.text = tabTitle
            
            tabViews.append(tabLabel)
            tabContainer.addSubview(tabLabel)
        }
    }
    
    private func setupTabViews() {
        pageContainerScrollView.contentSize = CGSize(
            width: pageContainerScrollView.frame.width * CGFloat(tabTitles.count),
            height: pageContainerScrollView.frame.height)
        loadTabViews(index: 1)
    }
    
    private func loadTabViews(index: Int){
        for i in (index - 1)...(index + 1) {
            if(i >= 0 && i < tabTitles.count){
                loadTabViewAtIndex(index: i)
            }
        }
    }
    
    private func loadTabViewAtIndex(index: Int){
        let tabViewController = tabViewControllers[index]
        tabViewController.view.frame = CGRect(x: pageContainerScrollView.frame.width * CGFloat(index),
                                              y: 0,
                                              width: pageContainerScrollView.frame.width,
                                              height: pageContainerScrollView.frame.height)
        
        if(itemViews[index] == nil) {
            itemViews[index] = tabViewController
            
//            let tap = UITapGestureRecognizer(target: self, action:  #selector(self.handleTapSubView))
//            itemViews[index]?.view!.addGestureRecognizer(tap)
            
            pageContainerScrollView.addSubview(itemViews[index]!.view)
        } else {
            itemViews[index] = tabViewController
        }
    }
    
    private func scrollToPage(currentPage: Int, previousIndex: Int) {
        if(currentPage <= tabTitles.count && currentPage > 0) {
            let index = currentPage - 1
            let iframe = CGRect(
                x: pageContainerScrollView.frame.width * CGFloat(index),
                y: 0,
                width: pageContainerScrollView.frame.width,
                height: pageContainerScrollView.frame.height)
            pageContainerScrollView.setContentOffset(iframe.origin, animated: true)
            
            loadTabViews(index: index)
            
            setupCurrentIndicator(currentIndex: index, previousIndex: previousIndex)
            
            if index - 1 >= 0 && index + 1 < 5 {
                leftToRightAnimationTabBar = UIView(frame: CGRect(x: -pageContainerScrollView.frame.width, y: 0, width: UIScreen.main.bounds.width, height: tabHeight))
                leftToRightAnimationTabBar.backgroundColor = tabColors[index - 1]
                
                rightToLeftAnimationTabBar = UIView(frame: CGRect(x: tabContainer.frame.width, y: 0, width: UIScreen.main.bounds.width, height: tabHeight))
                rightToLeftAnimationTabBar.backgroundColor = tabColors[index + 1]
                
                tabContainer.addSubview(leftToRightAnimationTabBar)
                tabContainer.addSubview(rightToLeftAnimationTabBar)
            }
            
            tabContainer.backgroundColor = tabColors[index]
            
            tabViews.forEach { (label) in
                tabContainer.addSubview(label)
            }
        }
    }
    
    private func setupAnimationTabBar() {
        leftToRightAnimationTabBar = UIView(frame: CGRect(x: -pageContainerScrollView.frame.width, y: 0, width: UIScreen.main.bounds.width, height: tabHeight))
        leftToRightAnimationTabBar.backgroundColor = tabColors[0]
        
        rightToLeftAnimationTabBar = UIView(frame: CGRect(x: tabContainer.frame.width, y: 0, width: UIScreen.main.bounds.width, height: tabHeight))
        rightToLeftAnimationTabBar.backgroundColor = tabColors[2]
        
        tabContainer.addSubview(leftToRightAnimationTabBar)
        tabContainer.addSubview(rightToLeftAnimationTabBar)
    }
    
    private func drawTabBarColorLeftToRightWhileScrolling(x: CGFloat) {
        leftToRightAnimationTabBar.transform = CGAffineTransform(translationX: x, y: 0)
    }
    
    private func drawTabBarColorRightToLeftWhileScrolling(x: CGFloat) {
        rightToLeftAnimationTabBar.transform = CGAffineTransform(translationX: -x, y: 0)
    }

    private func setupCurrentIndicator(currentIndex: Int?, previousIndex: Int) {
        guard let currentIndex = currentIndex else { return }
        
        self.currentIndex = currentIndex
        
        tabViews[previousIndex].alpha = 0.5
        tabViews[previousIndex].font = UIFont.systemFont(ofSize: 16.0)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.tabViews[currentIndex].alpha = 1
            self.tabViews[currentIndex].font = UIFont.boldSystemFont(ofSize: 16.0)
        })
    }
    
    private func tabViewController(tabName: String) -> UIViewController {
        return UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: tabName)
    }

}

extension TabBarViewController: UIScrollViewDelegate {
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        
        var pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageNumber = pageNumber + 1
        
        scrollToPage(currentPage: Int(pageNumber), previousIndex: Int(currentIndex))
        
        lastContentOffset = scrollView.contentOffset.x
    }
    
    //http://stackoverflow.com/a/1857162
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isFirst {
            isFirst = false
            return
        }
        
        NSObject.cancelPreviousPerformRequests(withTarget: scrollView)
        perform(#selector(scrollViewDidEndScrollingAnimation(_:)), with: scrollView, afterDelay: 0.0)
        
        let width = pageContainerScrollView.frame.width
        
        contentOffset = scrollView.contentOffset.x
        
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
        default: tabBarAnimationProgress = 0.0
        }
        
        if (lastContentOffset > scrollView.contentOffset.x) {
            drawTabBarColorLeftToRightWhileScrolling(x: abs(tabBarAnimationProgress - width))
        }
        else if (lastContentOffset < scrollView.contentOffset.x) {
            drawTabBarColorRightToLeftWhileScrolling(x: tabBarAnimationProgress)
        }
        
    }
}

