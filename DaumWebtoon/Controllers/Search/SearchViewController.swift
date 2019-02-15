//
//  SearchViewController.swift
//  DaumWebtoon
//
//  Created by Tak on 15/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var recommandCollectionView: UICollectionView!
    @IBOutlet weak var halfView: UIView!
    @IBOutlet weak var halfViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var keywordInput: UITextField!
    @IBOutlet weak var search: UIButton!
    
    private let collectionCellIdentifier = "recommandCell"
    private var genres: [Genre]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchRecommandationPodcast()
     
        initializeViews()
    }
    
    override func viewDidLayoutSubviews() {
        halfViewHeightConstraint.constant = view.frame.size.height / 2
    }

    private func initializeViews() {
        search.layer.cornerRadius = search.frame.height / 2
        keywordInput.delegate = self
        recommandCollectionView.dataSource = self
        recommandCollectionView.delegate = self
    }
    
    private func fetchRecommandationPodcast() {
        PodCastService.shared.fetchPodCastGenres { [weak self] (genres) in
            guard let self = self else { return }
            
            self.genres = genres
            self.recommandCollectionView.reloadData()
        }
    }
    
    @IBAction func searchTapped(_ sender: UIButton) {
        guard let input = keywordInput.text, input != "" else { return }
        
        
    }
    
}

extension SearchViewController: UITextFieldDelegate {
    
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellIdentifier, for: indexPath) as? SearchRecommandCollectionViewCell,
            let genre = genres?[indexPath.item] else {
            return UICollectionViewCell()
        }
        
        cell.configure(genre: genre)
        
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let genre = genres?[indexPath.item] else { return }
        
        keywordInput.text = genre.name
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
}
