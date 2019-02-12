//
//  TabBarView.swift
//  DaumWebtoon
//
//  Created by Tak on 31/01/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

protocol TabBarDataSource: class {
    func tabContents(_ tabBarView: TabBarView) -> [TabContent]
}

protocol TabBarDelegate: class {
    func tabBarView(_ tabBarView: TabBarView, viewControllerAtIndex index: Int?)
}

class TabBarView: UIStackView {
    
    weak var dataSource: TabBarDataSource? {
        didSet {
            reloadData()
        }
    }
    weak var delegate: TabBarDelegate?
    
    private lazy var leftToRightAnimationTabBars = [
        UIView(frame: CGRect(x: -screenWidth, y: 0, width: screenWidth, height: tabBarHeight)),
        UIView(frame: CGRect(x: -screenWidth, y: 0, width: screenWidth, height: tabBarHeight)),
        UIView(frame: CGRect(x: -screenWidth, y: 0, width: screenWidth, height: tabBarHeight)),
        UIView(frame: CGRect(x: -screenWidth, y: 0, width: screenWidth, height: tabBarHeight)),
        UIView(frame: CGRect(x: -screenWidth, y: 0, width: screenWidth, height: tabBarHeight)),
        UIView(frame: CGRect(x: -screenWidth, y: 0, width: screenWidth, height: tabBarHeight))]
    
    private lazy var rightToLeftAnimationTabBars = [
        UIView(frame: CGRect(x: tabBarWidth, y: 0, width: screenWidth, height: tabBarHeight)),
        UIView(frame: CGRect(x: tabBarWidth, y: 0, width: screenWidth, height: tabBarHeight)),
        UIView(frame: CGRect(x: tabBarWidth, y: 0, width: screenWidth, height: tabBarHeight)),
        UIView(frame: CGRect(x: tabBarWidth, y: 0, width: screenWidth, height: tabBarHeight)),
        UIView(frame: CGRect(x: tabBarWidth, y: 0, width: screenWidth, height: tabBarHeight)),
        UIView(frame: CGRect(x: tabBarWidth, y: 0, width: screenWidth, height: tabBarHeight))]
    
    private var tabViews = [TabView]()
    private var tabContents = [TabContent]()
    
    private lazy var screenWidth = Int(frame.size.width + 20)
    private lazy var tabBarWidth = Int(frame.size.width)
    
    private let tabBarHeight = 30
    private let tabBarMargin = 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTabBar()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupTabBar()
    }
    
    override func updateConstraints() {
        guard let superview = superview else { return }
        
        centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
        widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 20).isActive = true
        heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        super.updateConstraints()
    }
    
    func showCurrentTabIndicator(currentIndex: Int = 1, previousIndex: Int = 0) {
        tabViews[previousIndex].tabLabel.alpha = 0.6
        tabViews[previousIndex].tabLabel.font = UIFont.systemFont(ofSize: 16.0)
        
        tabViews[currentIndex].tabLabel.alpha = 1
        tabViews[currentIndex].tabLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
    }
    
    func drawTabBarColorLeftToRightWhileScrolling(x: CGFloat, currentIndex: Int) {
        bringSubviewToFront(leftToRightAnimationTabBars[currentIndex - 1])
        leftToRightAnimationTabBars[currentIndex - 1].transform = CGAffineTransform(translationX: x, y: 0)
    }

    func drawTabBarColorRightToLeftWhileScrolling(x: CGFloat, currentIndex: Int) {
        bringSubviewToFront(rightToLeftAnimationTabBars[currentIndex + 1])
        rightToLeftAnimationTabBars[currentIndex + 1].transform = CGAffineTransform(translationX: -x, y: 0)
    }
    
    func showEachTabs(currentIndex: Int = 2) {
        guard let tabContents = dataSource?.tabContents(self) else { return }
        
        self.tabContents = tabContents
        
        for tabView in tabViews {
            removeArrangedSubview(tabView.containerView)
            tabView.containerView.removeFromSuperview()
        }
        tabViews.removeAll()
        
        tabContents.forEach { (tabContent) in
            let view = UIView()
            view.isUserInteractionEnabled = true
            view.tag = tabContent.tabIndex
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTabTapped(_:))))
            
            let tabLabel = UILabel()
            tabLabel.textAlignment = .center
            tabLabel.textColor = UIColor.white
            tabLabel.numberOfLines = 0
            tabLabel.adjustsFontSizeToFitWidth = true
            tabLabel.font = UIFont.systemFont(ofSize: 16)
            tabLabel.alpha = 0.6
            tabLabel.text = tabContent.tabTitle
            
            view.addSubview(tabLabel)
            
            tabLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            tabLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            tabLabel.translatesAutoresizingMaskIntoConstraints = false
            
            tabViews.append(TabView(containerView: view, tabLabel: tabLabel))
            
            if tabContent.tabTitle == "" { return }
            
            addArrangedSubview(view)
        }
    }
    
    // MARK :- private methods
    private func reloadData() {
        showEachTabs()
        setupAnimationTabBar()
    }
    
    private func setupTabBar() {
        translatesAutoresizingMaskIntoConstraints = false
        axis = .horizontal
        distribution = .fillEqually
        spacing = 0
        isUserInteractionEnabled = true
        clipsToBounds = true
    
        showEachTabs()
        setupAnimationTabBar()
    }

    private func setupAnimationTabBar() {
        guard let tabContents = dataSource?.tabContents(self) else { return }
        
        for index in 0..<leftToRightAnimationTabBars.count {
            leftToRightAnimationTabBars[index].removeFromSuperview()
            rightToLeftAnimationTabBars[index].removeFromSuperview()
        }
        
        for index in 0..<tabContents.count {
            leftToRightAnimationTabBars[index].backgroundColor = tabContents[index].tabColor
            rightToLeftAnimationTabBars[index].backgroundColor = tabContents[index].tabColor
            
            addSubview(leftToRightAnimationTabBars[index])
            addSubview(rightToLeftAnimationTabBars[index])
        }
    }
    
    // MARK :- tap event
    @objc func didTabTapped(_ recognizer: UITapGestureRecognizer) {
        let view = recognizer.view
        let index = view?.tag
        
        delegate?.tabBarView(self, viewControllerAtIndex: index)
    }
    
}
