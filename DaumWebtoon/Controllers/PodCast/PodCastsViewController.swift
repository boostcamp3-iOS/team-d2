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
    
    var podcastId: String?
    var headerImage: UIImage?
    
    private var podcast: PodCast?
    private var episodes: [Episode] = []
    private var nextEpisodePubDate: String? = ""
    private var shownIndexes: [IndexPath] = []
    
    private let podcastIdentifier = "PodCastCell"
    private let detailIdentifier = "DetailCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchPodCasts()
        
        initializeCollectionView()
    }

//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
//        collectionView.collectionViewLayout.invalidateLayout()
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let modalViewController = segue.destination as? EpisodeModalViewController,
            let cell: UICollectionViewCell = sender as? UICollectionViewCell else { return }
        
        let indexPath = collectionView?.indexPath(for: cell)
        
        if let selectedIndex = indexPath?.item {
            modalViewController.delegate = self
            modalViewController.episode = episodes[selectedIndex]
        }
    }
    
    private func initializeCollectionView() {
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
        return CGSize(width: collectionView.frame.size.width / 3, height: collectionView.frame.size.width / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        guard let headerView = collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionHeader).first as? PodCastDetailCollectionViewCell else {
//            return CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
//        }

//        let label:UILabel = UILabel(frame: CGRect(0, 0, collectionView.frame.width - 16, CGFloat.max))
//        label.numberOfLines = 0
//        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
//        //here, be sure you set the font type and size that matches the one set in the storyboard label
//        label.font = UIFont(name: "Helvetica", size: 17.0)
//        label.text = labels[section]
//        label.sizeToFit()
        
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
//        headerView.layoutIfNeeded()
//
//        let titleHeight = headerView.podcastTitle.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize).height
//        let descHeight = headerView.podcastDescription.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize).height
//        let publisherHeight = headerView.podcastPublisher.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize).height
        let margin: CGFloat = 12.0
        
        print(title)
        print(publisher)
        print(description)
        
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
        let episode = podcast?.episodes[indexPath.item]
        
        let window = UIApplication.shared.keyWindow
        let appDelegate = UIApplication.shared.delegate
        
        guard let miniPlayerViewController = UIStoryboard(name: "MiniPlayer", bundle: nil).instantiateViewController(withIdentifier: "MiniPlayer") as? MiniPlayerViewController else { return }
        miniPlayerViewController.view.frame = CGRect(x: 0, y: view.bounds.height - 80,
                                                     width: view.bounds.width, height: 80)
        miniPlayerViewController.episode = episode
        
        appDelegate?.window??.rootViewController = miniPlayerViewController
        
        window?.addSubview(miniPlayerViewController.view)
    }
}
