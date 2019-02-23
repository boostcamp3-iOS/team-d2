//
//  ContentViewController.swift
//  DaumWebtoon
//
//  Created by Gaon Kim on 06/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {
    
    var genre: Int?
    lazy var tableView = UITableView()
    var channels: [Channel] = []
    private let cellIdentifier = "cellIdentifier"
    private let fetcher = BestPodCastsFetcher.shared
    private var hasNextPage = true
    private var currentPage = 1
    private var shownIndexes: [IndexPath] = []
    private let refreshControl = UIRefreshControl()
    private let imageTranslateAnimator = TranslateAnimator()
    private var selectedImage: UIImageView?
    private var selectedCellOriginY: CGFloat?
    weak var delegate: ContentDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTableView()
        fetchBestPodCasts()
        addRefreshControl()
        addDidFinishChangingContentOffsetNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension ContentViewController {
    private func addTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = view.frame
        tableView.backgroundColor = .clear
        let tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 200))
        tableFooterView.backgroundColor = #colorLiteral(red: 0.8705882353, green: 0.8705882353, blue: 0.8705882353, alpha: 1)
        tableView.tableFooterView = tableFooterView
        tableView.register(ChannelTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.contentInsetAdjustmentBehavior = .never
    }
    
    private func addRefreshControl() {
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshContentData), for: .valueChanged)
    }
    
    @objc func refreshContentData() {
        hasNextPage = true
        currentPage = 1
        shownIndexes = []
        channels = []
        fetchBestPodCasts()
        refreshControl.endRefreshing()
    }
    
    private func fetchBestPodCasts() {
        guard hasNextPage, let genre = genre else { return }
        
        BestPodCastsFetcher.shared.loadPage(genre: genre, currentPage: currentPage) { [weak self] bestPodCasts in
            
            guard let self = self else { return }
            self.channels += bestPodCasts.channels
            if !bestPodCasts.hasNext {
                self.hasNextPage = false
            } else {
                self.currentPage += 1
            }
            self.tableView.reloadData()
            // MARK: - For HeaderView
            self.delegate?.firstGenre(with: bestPodCasts.channels[0], genreId: genre)
        }
    }
    
    private func presentPodCastsViewController(indexPath: IndexPath) {
        guard let podCastsViewController = UIStoryboard(name: "PodCast", bundle: nil).instantiateViewController(withIdentifier: "PodCasts") as? PodCastsViewController else { return }
        
        podCastsViewController.transitioningDelegate = self
        podCastsViewController.podcastId = channels[indexPath.row].id
        podCastsViewController.headerImage = selectedImage?.image
        present(podCastsViewController, animated: true, completion: {
            
        })
    }
    
    func addDidFinishChangingContentOffsetNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(onDidFinishChangingContentOffset(_:)), name: .didFinishChangingContentOffset, object: nil)
    }
    
    @objc func onDidFinishChangingContentOffset(_ notification: Notification) {
        let contentOffset = tableView.contentOffset.y
        if (contentOffset <= 0) || (MainCommon.shared.contentOffset == -tableView.contentInset.top && contentOffset > 0) {
            tableView.setContentOffset(CGPoint(x: 0, y: MainCommon.shared.contentOffset), animated: false)
        }
    }
}

extension ContentViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let imageTranslateAnimator = TranslateAnimator()
        imageTranslateAnimator.selectedImage = selectedImage
        imageTranslateAnimator.selectedCellOriginY = selectedCellOriginY
        
        return imageTranslateAnimator
    }
}

extension ContentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ChannelTableViewCell,
            indexPath.row < channels.count else { return UITableViewCell() }
        let channel = channels[indexPath.row]
        cell.setData(channel: channel)
        return cell
    }
}

extension ContentViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? ChannelTableViewCell else { return }
        
        let rectOfCell = tableView.rectForRow(at: indexPath)
        let originOfCellInPresentedViewController = tableView.convert(rectOfCell.origin, to: presentedViewController?.view)
        
        selectedImage = selectedCell.thumbnailImageView
        selectedCellOriginY = originOfCellInPresentedViewController.y + rectOfCell.height / 2
        
        presentPodCastsViewController(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard shownIndexes.contains(indexPath) == false else { return }
        shownIndexes.append(indexPath)
        cell.alpha = 0
        if indexPath.row < 10 {
            UIView.animate(
                withDuration: 0.5,
                delay: 0.05 * Double(indexPath.row),
                options: [],
                animations: {
                    cell.alpha = 1
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.5
            ) {
                cell.alpha = 1
            }
        }
        
        if indexPath.row == channels.count - 1 {
            fetchBestPodCasts()
        }
    }
}

extension ContentViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = tableView.contentOffset.y
        if -tableView.contentInset.top <= contentOffset,
            contentOffset <= 0 {
            MainCommon.shared.contentOffset = contentOffset
            NotificationCenter.default.post(name: .didChangeContentOffset, object: nil)
        } else if contentOffset < -tableView.contentInset.top,
            MainCommon.shared.contentOffset != -tableView.contentInset.top {
            MainCommon.shared.contentOffset = -tableView.contentInset.top
            NotificationCenter.default.post(name: .didChangeContentOffset, object: nil)
        } else if contentOffset > 0,
            MainCommon.shared.contentOffset != 0 {
            MainCommon.shared.contentOffset = 0
            NotificationCenter.default.post(name: .didChangeContentOffset, object: nil)
        }
    }
    
    func notifyDidFinishChangingContentOffset() {
        let contentOffset = tableView.contentOffset.y
        if -tableView.contentInset.top <= contentOffset,
            contentOffset <= 0 {
            MainCommon.shared.contentOffset = contentOffset
            NotificationCenter.default.post(name: .didFinishChangingContentOffset, object: nil)
        } else if contentOffset <= -tableView.contentInset.top {
            MainCommon.shared.contentOffset = -tableView.contentInset.top
            NotificationCenter.default.post(name: .didFinishChangingContentOffset, object: nil)
        } else if contentOffset >= 0 {
            MainCommon.shared.contentOffset = 0
            NotificationCenter.default.post(name: .didFinishChangingContentOffset, object: nil)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        notifyDidFinishChangingContentOffset()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        notifyDidFinishChangingContentOffset()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        notifyDidFinishChangingContentOffset()
    }
}
