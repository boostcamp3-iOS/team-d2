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
        TabContent(tabColor: UIColor.blue, tabTitle: "", tabIndex: 0),
        TabContent(tabColor: UIColor.red, tabTitle: "캐시", tabIndex: 1),
        TabContent(tabColor: UIColor.brown, tabTitle: "연재", tabIndex: 2),
        TabContent(tabColor: UIColor.purple, tabTitle: "기다무", tabIndex: 3),
        TabContent(tabColor: UIColor.blue, tabTitle: "완결", tabIndex: 4),
        TabContent(tabColor: UIColor.red, tabTitle: "", tabIndex: 5)
    ]
    
    private let initialIndex = 1
    private let tabWidth = UIScreen.main.bounds.width - 20
    private let tabHeight: CGFloat = 30.0
    private var symbolView = SymbolView(frame: CGRect(origin: CGPoint(x: 50, y: 50), size: CGSize(width: 100, height: 100)))
    private let tabBarView = TabBarView()
    private let tabContainerView = UIView()
    private let tabScrollView = UIScrollView(frame: CGRect(x: 0, y: 0,
                                                           width: UIScreen.main.bounds.width,
                                                           height: UIScreen.main.bounds.height))
    private var lastContentOffset: CGFloat = 0
    private var contentOffsetInPage: CGFloat = 0
    private var currentIndex = 0
    lazy var splashView = SplashView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        splashView.delegate = self
        
        initializeTabScrollView()
        initializeTabContainer()
        initializeTabViewControllersContentSize()
        initializeTabViewControllers()
        initializeSymbolView()
        
        showCurrentTab(currentIndex: initialIndex)
        scrollToTab(currentIndex: initialIndex)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setSplashViewLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        splashView.animate()
    }
    
    private func setSplashViewLayout() {
        view.addSubview(splashView)
        splashView.frame = view.bounds
    }
    
    // MARK :- initialize views
    private func initializeTabScrollView() {
        tabScrollView.isPagingEnabled = true
        tabScrollView.showsHorizontalScrollIndicator = false
        tabScrollView.showsVerticalScrollIndicator = false
        tabScrollView.delegate = self
        
        view.addSubview(tabScrollView)
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
    
    private func initializeSymbolView() {
        symbolView.dataSource = self
        self.view.addSubview(symbolView)
    }
    
    // MARK :- private methods
    private func adjustIndexForIndex(currentIndex: Int, previousIndex: Int) -> (Int, Int) {
        if currentIndex > tabContents.count - 2 {
            return (1, tabContents.count - 2)
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
}

// MARK: - Splash View Delegate
extension TabBarViewController: SplashViewDelegate {
    func splashViewDidFinished(_ splashView: SplashView) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.splashView.alpha = 0
        }
    }
    
    func presentTabBarViewController() {
        let tabBarViewController = TabBarViewController()
        present(tabBarViewController, animated: false, completion: nil)
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
        let scrollWidth = tabScrollView.frame.width
        let contentOffset = scrollView.contentOffset.x
        var nextTabIndex = Int(round(contentOffset / scrollWidth))
        if nextTabIndex == 0 {
            nextTabIndex = tabContents.count - 2
        } else if nextTabIndex == tabContents.count - 1 {
            nextTabIndex = 1
        }
        
        slideSymbol(with: contentOffset / scrollWidth)
        
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

// MARK: - Symbol Coordinate Method
extension TabBarViewController {
    private func convertKeys(from keys: String, with shape: Shape.Type) -> [(CGFloat, CGFloat)] {
        var coordinates = [(CGFloat, CGFloat)]()
        for key in keys {
            if shape is ShapeC.Type {
                guard let shapeC = ShapeC(rawValue: String(key)) else { break }
                let fixedShape = scale(with: shapeC)
                coordinates.append(fixedShape)
            } else if shape is ShapeN.Type {
                guard let shapeN = ShapeN(rawValue: String(key)) else { break }
                let fixedShape = scale(with: shapeN)
                coordinates.append(fixedShape)
            } else if shape is ShapeHourglass.Type {
                guard let shapeHourglass = ShapeHourglass(rawValue: String(key)) else { break }
                let fixedShape = scale(with: shapeHourglass)
                coordinates.append(fixedShape)
            } else if shape is ShapeIce.Type {
                guard let shapeIce = ShapeIce(rawValue: String(key)) else { break }
                let fixedShape = scale(with: shapeIce)
                coordinates.append(fixedShape)
            } else if shape is ShapeSquare.Type {
                guard let shapeSquare = ShapeSquare(rawValue: String(key)) else { break }
                let fixedShape = scale(with: shapeSquare)
                coordinates.append(fixedShape)
            }
        }
        return coordinates
    }
    
    // 심볼뷰 크기에 따라 좌표값을 조절합니다.
    private func scale(with shape: Shape) -> (CGFloat, CGFloat) {
        let x = shape.coordinate.0 * symbolView.frame.width
        let y = shape.coordinate.1 * symbolView.frame.height
        return (x, y)
    }
    
    private func coordinate(xys: [(CGFloat, CGFloat)]) -> [CGPoint] {
        var points = [CGPoint]()
        for xy in xys {
            let x = xy.0
            let y = xy.1
            points.append(CGPoint(x: x, y: y))
        }
        return points
    }
    
    private func convertPath(from coordinates: [[CGPoint]]) -> [UIBezierPath] {
        let paths = coordinates.map { self.path(with: $0) }
        return paths
    }
    
    private func path(with coordinates: [CGPoint]) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: coordinates[0])
        path.addLine(to: coordinates[1])
        path.addLine(to: coordinates[2])
        path.addLine(to: coordinates[3])
        path.close()
        return path
    }
    
    private func slideSymbol(with value: CGFloat) {
        let forMaxValueOne = CGFloat(4)
        symbolView.timeOffset(value: Double(value / forMaxValueOne))
    }
}

// MARK: - Symbol Coordinate By Shape
extension TabBarViewController: SymbolDatasource {
    public func shapeC() -> [UIBezierPath] {
        var coordinates = [[CGPoint]]()
        let keys1 = convertKeys(from: "aegh", with: ShapeC.self)
        let keys2 = convertKeys(from: "cahi", with: ShapeC.self)
        let keys3 = convertKeys(from: "cijf", with: ShapeC.self)
        let keys4 = convertKeys(from: "cijf", with: ShapeC.self)
        let keys5 = convertKeys(from: "jkbf", with: ShapeC.self)
        let keys6 = convertKeys(from: "kldb", with: ShapeC.self)
        let keys7 = convertKeys(from: "gedl", with: ShapeC.self)
        let keys8 = convertKeys(from: "gedl", with: ShapeC.self)
        coordinates.append(coordinate(xys: keys1))
        coordinates.append(coordinate(xys: keys2))
        coordinates.append(coordinate(xys: keys3))
        coordinates.append(coordinate(xys: keys4))
        coordinates.append(coordinate(xys: keys5))
        coordinates.append(coordinate(xys: keys6))
        coordinates.append(coordinate(xys: keys7))
        coordinates.append(coordinate(xys: keys8))
        let paths = convertPath(from: coordinates)
        return paths
    }
    
    public func shapeCtoN() -> [UIBezierPath] {
        var coordinates = [[CGPoint]]()
        let keys1 = convertKeys(from: "qpor", with: ShapeSquare.self)
        let keys2 = convertKeys(from: "aqrb", with: ShapeSquare.self)
        let keys3 = convertKeys(from: "adts", with: ShapeSquare.self)
        let keys4 = convertKeys(from: "stgf", with: ShapeSquare.self)
        let keys5 = convertKeys(from: "ewzf", with: ShapeSquare.self)
        let keys6 = convertKeys(from: "wlkz", with: ShapeSquare.self)
        let keys7 = convertKeys(from: "uvkj", with: ShapeSquare.self)
        let keys8 = convertKeys(from: "mpvu", with: ShapeSquare.self)
        coordinates.append(coordinate(xys: keys1))
        coordinates.append(coordinate(xys: keys2))
        coordinates.append(coordinate(xys: keys3))
        coordinates.append(coordinate(xys: keys4))
        coordinates.append(coordinate(xys: keys5))
        coordinates.append(coordinate(xys: keys6))
        coordinates.append(coordinate(xys: keys7))
        coordinates.append(coordinate(xys: keys8))
        let paths = convertPath(from: coordinates)
        return paths
    }
    
    public func shapeN() -> [UIBezierPath] {
        var coordinates = [[CGPoint]]()
        let keys1 = convertKeys(from: "mdcn", with: ShapeN.self)
        let keys2 = convertKeys(from: "amnb", with: ShapeN.self)
        let keys3 = convertKeys(from: "iclk", with: ShapeN.self)
        let keys4 = convertKeys(from: "klje", with: ShapeN.self)
        let keys5 = convertKeys(from: "eopf", with: ShapeN.self)
        let keys6 = convertKeys(from: "ohgp", with: ShapeN.self)
        let keys7 = convertKeys(from: "klje", with: ShapeN.self)
        let keys8 = convertKeys(from: "iclk", with: ShapeN.self)
        coordinates.append(coordinate(xys: keys1))
        coordinates.append(coordinate(xys: keys2))
        coordinates.append(coordinate(xys: keys3))
        coordinates.append(coordinate(xys: keys4))
        coordinates.append(coordinate(xys: keys5))
        coordinates.append(coordinate(xys: keys6))
        coordinates.append(coordinate(xys: keys7))
        coordinates.append(coordinate(xys: keys8))
        let paths = convertPath(from: coordinates)
        return paths
    }
    
    public func shapeNtoHourglass() -> [UIBezierPath] {
        var coordinates = [[CGPoint]]()
        let keys1 = convertKeys(from: "qpor", with: ShapeSquare.self)
        let keys2 = convertKeys(from: "aqrb", with: ShapeSquare.self)
        let keys3 = convertKeys(from: "adts", with: ShapeSquare.self)
        let keys4 = convertKeys(from: "stgf", with: ShapeSquare.self)
        let keys5 = convertKeys(from: "ewzf", with: ShapeSquare.self)
        let keys6 = convertKeys(from: "wlkz", with: ShapeSquare.self)
        let keys7 = convertKeys(from: "uvkj", with: ShapeSquare.self)
        let keys8 = convertKeys(from: "mpvu", with: ShapeSquare.self)
        coordinates.append(coordinate(xys: keys1))
        coordinates.append(coordinate(xys: keys2))
        coordinates.append(coordinate(xys: keys3))
        coordinates.append(coordinate(xys: keys4))
        coordinates.append(coordinate(xys: keys5))
        coordinates.append(coordinate(xys: keys6))
        coordinates.append(coordinate(xys: keys7))
        coordinates.append(coordinate(xys: keys8))
        let paths = convertPath(from: coordinates)
        return paths
    }
    
    public func shapeHourglass() -> [UIBezierPath] {
        var coordinates = [[CGPoint]]()
        let keys1 = convertKeys(from: "abji", with: ShapeHourglass.self)
        let keys2 = convertKeys(from: "abji", with: ShapeHourglass.self)
        let keys3 = convertKeys(from: "aenm", with: ShapeHourglass.self)
        let keys4 = convertKeys(from: "mngc", with: ShapeHourglass.self)
        let keys5 = convertKeys(from: "kldc", with: ShapeHourglass.self)
        let keys6 = convertKeys(from: "kldc", with: ShapeHourglass.self)
        let keys7 = convertKeys(from: "mndf", with: ShapeHourglass.self)
        let keys8 = convertKeys(from: "hbnm", with: ShapeHourglass.self)
        coordinates.append(coordinate(xys: keys1))
        coordinates.append(coordinate(xys: keys2))
        coordinates.append(coordinate(xys: keys3))
        coordinates.append(coordinate(xys: keys4))
        coordinates.append(coordinate(xys: keys5))
        coordinates.append(coordinate(xys: keys6))
        coordinates.append(coordinate(xys: keys7))
        coordinates.append(coordinate(xys: keys8))
        let paths = convertPath(from: coordinates)
        return paths
    }
    
    public func shapeHourglassToIce() -> [UIBezierPath] {
        var coordinates = [[CGPoint]]()
        let keys1 = convertKeys(from: "qpor", with: ShapeSquare.self)
        let keys2 = convertKeys(from: "aqrb", with: ShapeSquare.self)
        let keys3 = convertKeys(from: "adts", with: ShapeSquare.self)
        let keys4 = convertKeys(from: "stgf", with: ShapeSquare.self)
        let keys5 = convertKeys(from: "ewzf", with: ShapeSquare.self)
        let keys6 = convertKeys(from: "wlkz", with: ShapeSquare.self)
        let keys7 = convertKeys(from: "uvkj", with: ShapeSquare.self)
        let keys8 = convertKeys(from: "mpvu", with: ShapeSquare.self)
        coordinates.append(coordinate(xys: keys1))
        coordinates.append(coordinate(xys: keys2))
        coordinates.append(coordinate(xys: keys3))
        coordinates.append(coordinate(xys: keys4))
        coordinates.append(coordinate(xys: keys5))
        coordinates.append(coordinate(xys: keys6))
        coordinates.append(coordinate(xys: keys7))
        coordinates.append(coordinate(xys: keys8))
        let paths = convertPath(from: coordinates)
        return paths
    }
    
    public func shapeIce() -> [UIBezierPath] {
        var coordinates = [[CGPoint]]()
        let keys1 = convertKeys(from: "odcp", with: ShapeIce.self)
        let keys2 = convertKeys(from: "aopb", with: ShapeIce.self)
        let keys3 = convertKeys(from: "efnm", with: ShapeIce.self)
        let keys4 = convertKeys(from: "mnhg", with: ShapeIce.self)
        let keys5 = convertKeys(from: "aopb", with: ShapeIce.self)
        let keys6 = convertKeys(from: "odcp", with: ShapeIce.self)
        let keys7 = convertKeys(from: "mnji", with: ShapeIce.self)
        let keys8 = convertKeys(from: "lknm", with: ShapeIce.self)
        coordinates.append(coordinate(xys: keys1))
        coordinates.append(coordinate(xys: keys2))
        coordinates.append(coordinate(xys: keys3))
        coordinates.append(coordinate(xys: keys4))
        coordinates.append(coordinate(xys: keys5))
        coordinates.append(coordinate(xys: keys6))
        coordinates.append(coordinate(xys: keys7))
        coordinates.append(coordinate(xys: keys8))
        let paths = convertPath(from: coordinates)
        return paths
    }
    
    public func shapeIceToC() -> [UIBezierPath] {
        var coordinates = [[CGPoint]]()
        let keys1 = convertKeys(from: "qpor", with: ShapeSquare.self)
        let keys2 = convertKeys(from: "aqrb", with: ShapeSquare.self)
        let keys3 = convertKeys(from: "adts", with: ShapeSquare.self)
        let keys4 = convertKeys(from: "stgf", with: ShapeSquare.self)
        let keys5 = convertKeys(from: "ewzf", with: ShapeSquare.self)
        let keys6 = convertKeys(from: "wlkz", with: ShapeSquare.self)
        let keys7 = convertKeys(from: "uvkj", with: ShapeSquare.self)
        let keys8 = convertKeys(from: "mpvu", with: ShapeSquare.self)
        coordinates.append(coordinate(xys: keys1))
        coordinates.append(coordinate(xys: keys2))
        coordinates.append(coordinate(xys: keys3))
        coordinates.append(coordinate(xys: keys4))
        coordinates.append(coordinate(xys: keys5))
        coordinates.append(coordinate(xys: keys6))
        coordinates.append(coordinate(xys: keys7))
        coordinates.append(coordinate(xys: keys8))
        let paths = convertPath(from: coordinates)
        return paths
    }
    
    // 좌표값이 초기 C와 동일하기 때문에 무한스크롤 할 때는 삭제하고 초기 C를 사용하면 됩니다.
    public func shapeAnotherC() -> [UIBezierPath] {
        var coordinates = [[CGPoint]]()
        let keys1 = convertKeys(from: "aegh", with: ShapeC.self)
        let keys2 = convertKeys(from: "cahi", with: ShapeC.self)
        let keys3 = convertKeys(from: "cijf", with: ShapeC.self)
        let keys4 = convertKeys(from: "cijf", with: ShapeC.self)
        let keys5 = convertKeys(from: "jkbf", with: ShapeC.self)
        let keys6 = convertKeys(from: "kldb", with: ShapeC.self)
        let keys7 = convertKeys(from: "gedl", with: ShapeC.self)
        let keys8 = convertKeys(from: "gedl", with: ShapeC.self)
        coordinates.append(coordinate(xys: keys1))
        coordinates.append(coordinate(xys: keys2))
        coordinates.append(coordinate(xys: keys3))
        coordinates.append(coordinate(xys: keys4))
        coordinates.append(coordinate(xys: keys5))
        coordinates.append(coordinate(xys: keys6))
        coordinates.append(coordinate(xys: keys7))
        coordinates.append(coordinate(xys: keys8))
        let paths = convertPath(from: coordinates)
        return paths
    }
}
