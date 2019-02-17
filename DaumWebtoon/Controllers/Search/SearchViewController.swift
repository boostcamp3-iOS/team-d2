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
    @IBOutlet weak var podcastsTableView: UITableView!
    @IBOutlet weak var halfView: UIView!
    @IBOutlet weak var halfViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var keywordInput: UITextField!
    @IBOutlet weak var search: UIButton!
    
    private let imageTranslateAnimator = TranslateAnimator()
    private let collectionCellIdentifier = "recommandCell"
    private let tableviewCellIdentifier = "tableviewCell"
    private var genres: [Genre]?
    private var podcasts: [PodCastSearch]?
    private var selectedImage: UIImageView?
    private var selectedCellFrame: CGRect?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchRecommandationPodcast()

        initializeViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        halfViewHeightConstraint.constant = view.frame.size.height / 2
    }

    private func initializeViews() {
        podcastsTableView.isHidden = true
        search.layer.cornerRadius = search.frame.height / 2
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        keywordInput.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        keywordInput.delegate = self
        recommandCollectionView.dataSource = self
        recommandCollectionView.delegate = self
        podcastsTableView.dataSource = self
        podcastsTableView.delegate = self
    }
    
    private func fetchRecommandationPodcast() {
        PodCastService.shared.fetchPodCastGenres { [weak self] (genres) in
            guard let self = self else { return }
            
            self.genres = genres
            self.recommandCollectionView.reloadData()
        }
    }
    
    private func searchPodCasts(query: String?) {
        halfView.isHidden = true
        
        SearchPodCastsService.shared.searchPodCasts(query: query) { [weak self] (podcasts) in
            guard let self = self else { return }
            
            self.podcastsTableView.isHidden = false
            self.podcasts = podcasts
            self.podcastsTableView.reloadData()
        }
    }
    
    // MARK :- event handling
    @objc func keyboardWillAppear() {
        podcastsTableView.isHidden = false
        halfView.isHidden = true
    }
    
    @objc func keyboardWillDisappear() {
        podcastsTableView.isHidden = true
        halfView.isHidden = false
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let query = textField.text else { return }
        
        if query.isEmpty {
            podcastsTableView.isHidden = true
            halfView.isHidden = false
            return
        }
        
        searchPodCasts(query: query)
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func searchTapped(_ sender: UIButton) {
        guard var query = keywordInput.text, query != "" else { return }
        
        if query.starts(with: "#") {
            query = String(query.suffix(query.count-1))
        }
        
        searchPodCasts(query: query)
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension SearchViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        imageTranslateAnimator.selectedImage = selectedImage
        imageTranslateAnimator.selectedCellFrame = selectedCellFrame
        
        return imageTranslateAnimator
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: tableviewCellIdentifier) as? PodCastTableViewCell,
            let podcast = podcasts?[indexPath.row] else {
            return PodCastTableViewCell()
        }
        
        cell.configure(podcast: podcast)
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let podcast = podcasts?[indexPath.row],
            let podcastsViewController = UIStoryboard(name: "PodCast", bundle: nil).instantiateViewController(withIdentifier: "PodCasts") as? PodCastsViewController,
            let selectedCell = tableView.cellForRow(at: indexPath) as? PodCastTableViewCell else { return }

        self.selectedImage = selectedCell.podcastThumbnail
        self.selectedCellFrame = selectedCell.frame
        
        podcastsViewController.transitioningDelegate = self
        podcastsViewController.podcastId = podcast.id
        podcastsViewController.headerImage = selectedImage?.image
        present(podcastsViewController, animated: true, completion: nil)
    }
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
        
        keywordInput.text = "#\(genre.name)"
        
        searchPodCasts(query: genre.name)
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
