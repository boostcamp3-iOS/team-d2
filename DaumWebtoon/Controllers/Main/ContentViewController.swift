//
//  ContentViewController.swift
//  DaumWebtoon
//
//  Created by Gaon Kim on 06/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    var fetcher: BestPodCastsFetcher?
    lazy var tableView = UITableView()
    private var channels: [Channel] = []
    private let cellIdentifier = "cellIdentifier"
    private let imageTranslateAnimator = TranslateAnimator()
    private var selectedImage: UIImageView?
    private var selectedCellOriginY: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTableView()
        fetchBestPodCasts()
    }
}

extension ContentViewController {
    private func addTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = view.frame
        tableView.register(ChannelTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    private func fetchBestPodCasts() {
        guard let fetcher = fetcher else { return }
        fetcher.execute { [weak self] bestPodCasts in
            guard let self = self else { return }
            self.channels = bestPodCasts.channels
            self.tableView.reloadData()
        }
    }
    
    private func presentPodCastsViewController(indexPath: IndexPath) {
        guard let podCastsViewController = UIStoryboard(name: "PodCast", bundle: nil).instantiateViewController(withIdentifier: "PodCasts") as? PodCastsViewController else { return }
            
        podCastsViewController.transitioningDelegate = self
        podCastsViewController.podcastId = channels[indexPath.row].id
        podCastsViewController.headerImage = selectedImage?.image
        present(podCastsViewController, animated: true, completion: nil)
    }
}

extension ContentViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ChannelTableViewCell else { return UITableViewCell() }
        let channel = channels[indexPath.row]
        cell.setData(channel: channel)
        return cell
    }
}

extension ContentViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? ChannelTableViewCell else { return }
        
        selectedImage = selectedCell.thumbnailImageView
        selectedCellOriginY = selectedCell.frame.origin.y + view.frame.height
        
        presentPodCastsViewController(indexPath: indexPath)
    }
}
