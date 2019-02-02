//
//  TabBarView.swift
//  DaumWebtoon
//
//  Created by Tak on 31/01/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

protocol TabBarDataSource {
    func tabContents(_ tabBarView: TabBarView) -> [TabContent]
}

protocol TabBarDelegate {
    
}

class TabBarView: UIStackView {
    
    var dataSource: TabBarDataSource? {
        didSet {
            reloadData()
        }
    }
    var delegate: TabBarDelegate?
    
    private var tabViews: [TabView] = []
    private var leftToRightAnimationTabBar: UIView?
    private var rightToLeftAnimationTabBar: UIView?
    private var tabContents: [TabContent] = []
    
    private let tabBarWidth = Double(UIScreen.main.bounds.width - 20)
    private let tabBarHeight = 30.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTabBar()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupTabBar()
    }
    
    override func updateConstraints() {
        centerXAnchor.constraint(equalTo: superview!.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: superview!.centerYAnchor).isActive = true
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
    
    func loadAnimationTabBar(leftAnimationTabBarColorIndex: Int, rightAnimationTabBarColorIndex: Int) {
        if let _ = leftToRightAnimationTabBar,
            let _ = rightToLeftAnimationTabBar {
            leftToRightAnimationTabBar?.backgroundColor = tabContents[leftAnimationTabBarColorIndex].tabColor
            rightToLeftAnimationTabBar?.backgroundColor = tabContents[rightAnimationTabBarColorIndex].tabColor
            return
        }
        
        leftToRightAnimationTabBar = UIView(frame: CGRect(x: -Double(UIScreen.main.bounds.width), y: 0,
                                                          width: Double(UIScreen.main.bounds.width), height: tabBarHeight))
        rightToLeftAnimationTabBar = UIView(frame: CGRect(x: tabBarWidth, y: 0,
                                                          width: Double(UIScreen.main.bounds.width), height: tabBarHeight))
        addSubview(leftToRightAnimationTabBar!)
        addSubview(rightToLeftAnimationTabBar!)
    }
    
    func drawTabBarColorLeftToRightWhileScrolling(x: CGFloat) {
        leftToRightAnimationTabBar?.transform = CGAffineTransform(translationX: x, y: 0)
    }

    func drawTabBarColorRightToLeftWhileScrolling(x: CGFloat) {
        rightToLeftAnimationTabBar?.transform = CGAffineTransform(translationX: -x, y: 0)
    }
    
    func showEachTabs(currentIndex: Int = 2, status: Status = .inInit) {
        guard let tabContents = dataSource?.tabContents(self) else { return }
        
        self.tabContents = tabContents
        
        for tabView in tabViews {
            removeArrangedSubview(tabView.containerView)
            tabView.containerView.removeFromSuperview()
        }
        tabViews.removeAll()
        
        tabContents.forEach { (tabContent) in
            let view = UIView()

            let tabLabel = UILabel()
            tabLabel.textAlignment = .center
            tabLabel.autoresizingMask =  [.flexibleWidth, .flexibleHeight]
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
    
    private func setupTabBar() {
        translatesAutoresizingMaskIntoConstraints = false
        axis = .horizontal
        distribution = .fillEqually
        spacing = 0
        setNeedsUpdateConstraints()
        
        showEachTabs()
    }
    
    private func reloadData() {
        showEachTabs()
    }
    
}
