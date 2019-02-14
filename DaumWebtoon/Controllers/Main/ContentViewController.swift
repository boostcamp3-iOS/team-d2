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
}

extension ContentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ChannelTableViewCell else { return UITableViewCell() }
        cell.textLabel?.text = channels[indexPath.row].title
        return cell
    }
}

extension ContentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
