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
    private var channels: [Channel] = []
    private let cellIdentifier = "cellIdentifier"
    private let fetcher = BestPodCastsFetcher.shared
    private var hasNextPage = true
    private var currentPage = 1
    
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
        }
    }
    
    private func presentPodCastsViewController(indexPath: IndexPath) {
        guard let podCastsViewController = UIStoryboard.init(name: "PodCast", bundle: nil).instantiateViewController(withIdentifier: "PodCasts") as? PodCastsViewController else { return }
        podCastsViewController.podcastId = channels[indexPath.row].id
        present(podCastsViewController, animated: true, completion: nil)
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
        presentPodCastsViewController(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == channels.count - 1 {
            fetchBestPodCasts()
        }
    }
}
