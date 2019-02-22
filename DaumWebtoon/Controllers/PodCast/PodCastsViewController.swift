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
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var headerBackgroundImage: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var headerImageViewWidth: NSLayoutConstraint!
    
    var podcastId: String?
    var headerImage: UIImage?
    
    private var podcast: PodCast?
    private var episodes: [Episode] = []
    private var nextEpisodePubDate: String? = ""
    private var shownIndexes: [IndexPath] = []
    private var miniPlayerViewController: MiniPlayerViewController?
    
    private let podcastIdentifier = "PodCastCell"
    private let detailIdentifier = "DetailCell"
    private let footerIdentifier = "FooterCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchPodCasts()
        
        setupMiniPlayer()
        setupViews()
        setupCollectionView()
    }
    
    private func setupMiniPlayer() {
        let window = UIApplication.shared.keyWindow
        
        miniPlayerViewController = UIStoryboard(name: "MiniPlayer", bundle: nil).instantiateViewController(withIdentifier: "MiniPlayer") as? MiniPlayerViewController
        miniPlayerViewController?.delegate = self
        miniPlayerViewController?.view.frame = CGRect(x: 0, y: view.bounds.height - 80,
                                                     width: view.bounds.width, height: 80)
        miniPlayerViewController?.view.isHidden = true
        
        window?.addSubview(miniPlayerViewController?.view ?? UIView())
    }
    
    private func setupViews() {
        if UIDevice.current.hasNotch {
            headerImageViewWidth.constant = 200.0
            headerImageViewHeight.constant = 210.0
        } else {
            headerImageViewWidth.constant = 100.0
            headerImageViewHeight.constant = 100.0
        }
    }

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func fetchPodCasts() {
        guard let podcastId = podcastId else { return }
        PodCastService.shared.fetchPodCasts(podcastId: podcastId, nextEpisodePubDate: nextEpisodePubDate) { [weak self] (podcast) in
            guard let self = self,
                let nextEpisodePubDate = podcast.nextEpisodePubDate else { return }
            
            self.podcast = podcast
            self.episodes += podcast.episodes
            self.nextEpisodePubDate = String(nextEpisodePubDate)
            self.collectionView.reloadData()
        }
    }
    
    // MARK :- event handling
    @IBAction func backTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension PodCastsViewController: EpisodeModalViewDelegate {
    func playPauseAudio(state: Bool) { }
    
    func showHeaderImageView() {
        headerBackgroundImage.image = UIImage(named: "lightGray")
        headerImageView.image = headerImage
        view.sendSubviewToBack(headerBackgroundImage)
        view.bringSubviewToFront(headerImageView)
    }
}

extension PodCastsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3 - 4, height: collectionView.frame.size.width / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        title.numberOfLines = 0
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.font = UIFont.boldSystemFont(ofSize: 22.0)
        title.text = podcast?.title
        title.sizeToFit()
        
        let publisher = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        publisher.numberOfLines = 0
        publisher.lineBreakMode = NSLineBreakMode.byWordWrapping
        publisher.font = UIFont(name: "System", size: 16.0)
        publisher.text = podcast?.publisher
        publisher.sizeToFit()
        
        let description = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        description.numberOfLines = 0
        description.lineBreakMode = NSLineBreakMode.byWordWrapping
        description.font = UIFont(name: "System", size: 17.0)
        description.text = podcast?.description
        description.sizeToFit()

        let margin: CGFloat = 12.0
        
        return CGSize(width: collectionView.frame.width, height: title.frame.height + publisher.frame.height + description.frame.height + margin)
    }
}

extension PodCastsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: detailIdentifier, for: indexPath) as? PodCastDetailCollectionViewCell else {
                return UICollectionReusableView()
            }
            
            headerView.configure(title: podcast?.title, description: podcast?.description, publisher: podcast?.publisher)
            
            return headerView
        case UICollectionView.elementKindSectionFooter:
            guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerIdentifier, for: indexPath) as? PodCastFooterCollectionReusableView else {
                return UICollectionReusableView()
            }
            
            return footerView
        default:
            assert(false, "invalid type")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let podcastsCell = collectionView.dequeueReusableCell(withReuseIdentifier: podcastIdentifier, for: indexPath) as? PodCastCollectionViewCell else {
            return UICollectionViewCell()
        }
        let episode = episodes[indexPath.item]
        
        podcastsCell.configure(episode, item: indexPath.item, index: collectionView.indexPath(for: podcastsCell) ?? indexPath)
        
        return podcastsCell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
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
            UIView.animate(withDuration: 0.5) {
                cell.alpha = 1
            }
        }
        
        if indexPath.item == episodes.count - 10 || episodes.count - 10 < 0 {
            fetchPodCasts()
        }
    }
}

extension PodCastsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let episode = episodes[indexPath.item]
        
        if miniPlayerViewController == nil {
            setupMiniPlayer()
        }
        
        miniPlayerViewController?.view.isHidden = false
        miniPlayerViewController?.episode = episode
    }
}

extension PodCastsViewController: MiniPlayerDelegate {
    func removeMiniPlayer() {
        miniPlayerViewController = nil
    }
}
