//
//  MainPresenter.swift
//  DaumWebtoon
//
//  Created by Tak on 04/03/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import Foundation
import UIKit

protocol MainView: class {
    func slideSymbolAnimation(with: CGFloat)
    func cancelPreviousPerformRequests()
    func drawTabBarColorLeftToRightWhileScrolling(x: CGFloat, currentIndex: Int)
    func drawTabBarColorRightToLeftWhileScrolling(x: CGFloat, currentIndex: Int)
    func showEachTabs(currentIndex: Int)
    func showCurrentTabIndicator(currentIndex: Int, previousIndex: Int)
    func showCurrentTab(currentIndex: Int, animated: Bool)
    func scrollToTab(index: (Int, Int))
}

class MainPresenter {
    
    var currentIndex = 1
    var lastContentOffset: CGFloat = 0
    
    private weak var view: MainView?
    private var contentOffsetInPage: CGFloat = 0
    
    private let tabCount: Int
    
    init(tabCount: Int) {
        self.tabCount = tabCount
    }
 
    func scrollViewDidScroll(scrollView: UIScrollView, viewWidth: CGFloat) {
        let scrollWidth = scrollView.frame.width
        let contentOffset = scrollView.contentOffset.x
        var nextTabIndex = Int(round(contentOffset / scrollWidth))
        if nextTabIndex == 0 {
            nextTabIndex = tabCount - 2
        } else if nextTabIndex == tabCount - 1 {
            nextTabIndex = 1
        }
       
        view?.slideSymbolAnimation(with: contentOffset / scrollWidth - 1)
        
        let contentOffsetInPage = contentOffset - scrollWidth * floor(contentOffset / scrollWidth)
        if scrollView.isTracking || scrollView.isDragging || scrollView.isDecelerating {
            view?.cancelPreviousPerformRequests()

            if lastContentOffset > contentOffset {
                let index = contentOffsetInPage >= viewWidth / 2 ? nextTabIndex : nextTabIndex + 1
                view?.drawTabBarColorLeftToRightWhileScrolling(x: abs(contentOffsetInPage - scrollWidth), currentIndex: index)
                self.contentOffsetInPage = abs(contentOffsetInPage - scrollWidth)
            } else if lastContentOffset <= contentOffset && contentOffsetInPage != 0.0 {
                let index = contentOffsetInPage >= viewWidth / 2 ? nextTabIndex - 1 : nextTabIndex
                view?.drawTabBarColorRightToLeftWhileScrolling(x: contentOffsetInPage, currentIndex: index)
                self.contentOffsetInPage = contentOffsetInPage
            }
        } else {
            if lastContentOffset > contentOffset {
                let index = contentOffsetInPage >= viewWidth / 2 ? nextTabIndex - 1 : nextTabIndex
                view?.drawTabBarColorRightToLeftWhileScrolling(x: contentOffsetInPage, currentIndex: index)
                self.contentOffsetInPage = contentOffsetInPage
            } else if lastContentOffset <= contentOffset && contentOffsetInPage != 0.0 {
                let index = contentOffsetInPage >= viewWidth / 2 ? nextTabIndex : nextTabIndex + 1
                view?.drawTabBarColorLeftToRightWhileScrolling(x: abs(contentOffsetInPage - scrollWidth), currentIndex: index)
                self.contentOffsetInPage = abs(contentOffsetInPage - scrollWidth)
            }
        }
        
        view?.showEachTabs(currentIndex: currentIndex)
        view?.showCurrentTabIndicator(currentIndex: nextTabIndex, previousIndex: currentIndex)
        if isInvisibleTabForIndex(contentOffset: contentOffset, scrollView: scrollView) {
            view?.showCurrentTab(currentIndex: nextTabIndex, animated: false)
        }
        
        currentIndex = Int(nextTabIndex)
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        guard contentOffsetInPage >= UIScreen.main.bounds.width / 2 else { return }

        NSObject.cancelPreviousPerformRequests(withTarget: self)

        if lastContentOffset <= scrollView.contentOffset.x {
            view?.drawTabBarColorRightToLeftWhileScrolling(x: scrollView.frame.width, currentIndex: currentIndex - 1)
        }

        let nextTabIndex = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        view?.showCurrentTab(currentIndex: nextTabIndex, animated: true)
        let index = adjustIndexForIndex(currentIndex: nextTabIndex, previousIndex: currentIndex)
        view?.scrollToTab(index: index)
    }
    
    func attachView(view: MainView) {
        self.view = view
    }
    
    func detachView() {
        view = nil
    }
    
    private func isInvisibleTabForIndex(contentOffset: CGFloat, scrollView: UIScrollView) -> Bool {
        return contentOffset <= 0.0 ||
            contentOffset >= scrollView.frame.width * CGFloat(tabCount - 1)
            ? true : false
    }
    
    private func adjustIndexForIndex(currentIndex: Int, previousIndex: Int = 0) -> (Int, Int) {
        if currentIndex > tabCount - 2 {
            return (1, tabCount - 2)
        } else if currentIndex < 1 {
            return (tabCount - 2, 1)
        } else {
            return (currentIndex, previousIndex)
        }
    }
}
