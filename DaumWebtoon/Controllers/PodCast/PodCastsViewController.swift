//
//  PodCastsViewController.swift
//  DaumWebtoon
//
//  Created by Tak on 12/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

class PodCastsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var podcastId: String?
    
    private var podcast: PodCast?
    
    private let podcastIdentifier = "PodCastCell"
    private let detailIdentifier = "DetailCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchPodCasts()
        
        initializeCollectionView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let modalViewController = segue.destination as? EpisodeModalViewController,
            let cell: UICollectionViewCell = sender as? UICollectionViewCell else { return }
        
        let indexPath = collectionView?.indexPath(for: cell)
        
        if let selectedIndex = indexPath?.item {
            modalViewController.episode = podcast?.episodes[selectedIndex]
        }
    }
    
    private func initializeCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func fetchPodCasts() {
        PodCastService.shared.fetchPodCasts(podcastId: podcastId) { [weak self] (podcast) in
            guard let self = self else { return }
            
            self.podcast = podcast
            self.collectionView.reloadData()
        }
    }
}

extension PodCastsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3, height: collectionView.frame.size.width / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let headerView = collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionHeader).first as? DetailCollectionViewCell else {
            return CGSize(width: 1, height: 1)
        }

        headerView.layoutIfNeeded()

        let height = headerView.contentView.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize).height

        return CGSize(width: collectionView.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

extension PodCastsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return podcast?.episodes.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: detailIdentifier, for: indexPath) as? DetailCollectionViewCell else {
                return UICollectionReusableView()
            }
            
            headerView.configure(title: podcast?.title, description: podcast?.description, publisher: podcast?.publisher)
            
            return headerView
        default:
            assert(false, "invalid type")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let podcastsCell = collectionView.dequeueReusableCell(withReuseIdentifier: podcastIdentifier, for: indexPath) as? PodCastCollectionViewCell,
            let episode = podcast?.episodes[indexPath.item] else {
            return UICollectionViewCell()
        }
        
        podcastsCell.configure(episode, item: indexPath.item, index: collectionView.indexPath(for: podcastsCell) ?? indexPath)
        
        return podcastsCell
    }
}

extension PodCastsViewController: UICollectionViewDelegate {
    
}
