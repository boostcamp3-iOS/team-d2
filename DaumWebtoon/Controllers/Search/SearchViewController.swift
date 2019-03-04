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
    @IBOutlet weak var keywordInput: UITextField!
    @IBOutlet weak var search: UIButton!
    
    var interactor: Interactor?
    
    private let collectionCellIdentifier = "recommandCell"
    private let tableviewCellIdentifier = "tableviewCell"
    private let presenter = SearchPresenter(searchService: SearchPodCastsService.shared,
                                            podcastService: PodCastService.shared)
    
    private var isFirst = true
    private var genres: [Genre]?
    private var podcasts: [PodCastSearch]?
    private var shownIndexPaths = [IndexPath]()
    private var selectedImage: UIImageView?
    private var selectedCellOriginY: CGFloat?
    private var bottomAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.attachView(view: self)
        presenter.fetchRecommandationPodcast()

        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidDisappear), name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter.viewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupViews() {
        search.layer.cornerRadius = search.frame.height / 2
        
        keywordInput.delegate = self
        recommandCollectionView.dataSource = self
        recommandCollectionView.delegate = self
        recommandCollectionView.collectionViewLayout = CenterAlignedCollectionViewFlowLayout()
        podcastsTableView.dataSource = self
        podcastsTableView.delegate = self
        
        hideMiniPlayer()
        setupBottomHalfView()
        setupGestures()
    }
    
    private func hideMiniPlayer() {
        let window = UIApplication.shared.keyWindow
        window?.viewWithTag(100)?.isHidden = true
    }
    
    private func showMiniPlayer() {
        let window = UIApplication.shared.keyWindow
        window?.viewWithTag(100)?.isHidden = false
    }
    
    private func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        keywordInput.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgeGesture(_:)))
        edgeGesture.edges = .left
        view.addGestureRecognizer(edgeGesture)
    }
    
    private func setupBottomHalfView() {
        halfView.translatesAutoresizingMaskIntoConstraints = false
        halfView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        halfView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        halfView.heightAnchor.constraint(equalToConstant: view.bounds.height / 2).isActive = true
    }
    
    private func animateDownRecommandHalfBottomView() {
        UIView.animate(withDuration: 1.0, animations: {
            self.bottomAnchor?.isActive = false
            self.halfView.frame.origin.y += self.view.bounds.height / 2
            self.bottomAnchor = self.halfView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: self.view.bounds.size.height / 2)
            self.bottomAnchor?.isActive = true
        })
    }
    
    // MARK :- event handling
    @objc func handleEdgeGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        let horizontalMovement = translation.x / view.bounds.width

        presenter.calculateEdgeGestureRecognizer(horizontalMovement: horizontalMovement,
                                                 recognizerState: recognizer.state,
                                                 interactor: interactor)
    }
    
    @objc func keyboardWillAppear() {
        showPodcastsTableView()
        hideRecommanHalfdBottomView()
        animateDownRecommandHalfBottomView()
    }
    
    @objc func keyboardDidDisappear() {
        hidePodcastsTableView()
        showRecommandHalfBottomView()
        animateUpRecommandHalfBottomView()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        presenter.textFieldDidChange(query: textField.text)
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        dismiss()
        showMiniPlayer()
    }
    
    @IBAction func searchTapped(_ sender: UIButton) {
        presenter.searchPodCasts(query: keywordInput.text)
    }
}


// MARk :- SearchView
extension SearchViewController: SearchView {
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    func showPodcasts(podcasts: [PodCastSearch]) {
        self.podcasts = podcasts
        podcastsTableView.reloadData()
    }
    
    func showPodcastsTableView() {
        podcastsTableView.isHidden = false
    }
    
    func hidePodcastsTableView() {
        podcastsTableView.isHidden = true
    }
    
    func showRecommandHalfBottomView() {
        halfView.isHidden = false
    }
    
    func hideRecommanHalfdBottomView() {
        halfView.isHidden = true
    }
    
    func showRecommandPodCastGenres(genres: [Genre]?) {
        self.genres = genres
        recommandCollectionView.reloadData()
    }
    
    func showKeywordInput(keyword: String) {
        keywordInput.text = keyword
    }
    
    func animateTableViewCell(cell: UITableViewCell, row: Int) {
        UIView.animate(
            withDuration: 0.5,
            delay: 0.05 * Double(row),
            options: [],
            animations: {
                cell.alpha = 1
        }, completion: nil)
    }
    
    func disAnimateTableViewCell(cell: UITableViewCell) {
        UIView.animate(withDuration: 0.5) {
            cell.alpha = 1
        }
    }
    
    func animateUpRecommandHalfBottomView() {
        UIView.animate(withDuration: 0.6, animations: {
            self.halfView.frame.origin.y -= self.view.bounds.height / 2
            self.bottomAnchor = self.halfView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            self.bottomAnchor?.isActive = true
        })
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
        
        let imageTranslateAnimator = TranslateAnimator()
        imageTranslateAnimator.selectedImage = selectedImage
        imageTranslateAnimator.selectedCellOriginY = selectedCellOriginY
        
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

        let rectOfCell = tableView.rectForRow(at: indexPath)
        let originOfCellInPresentedViewController = tableView.convert(rectOfCell.origin, to: presentedViewController?.view)
        
        selectedImage = selectedCell.podcastThumbnail
        selectedCellOriginY = originOfCellInPresentedViewController.y + rectOfCell.height / 2
        
        podcastsViewController.transitioningDelegate = self
        podcastsViewController.podcastId = podcast.id
        podcastsViewController.headerImage = selectedImage?.image
        present(podcastsViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard shownIndexPaths.contains(indexPath) == false else { return }
        
        shownIndexPaths.append(indexPath)
        cell.alpha = 0
        presenter.calcuateTableViewRowCount(cell: cell, row: indexPath.row)
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
        presenter.didSelectRecommandPodCast(selectedGenre: genres?[indexPath.item])
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let genre = genres?[indexPath.item] else { return CGSize(width: 0, height: 0) }
        
        let recommandTitle = UILabel(frame: CGRect.zero)
        recommandTitle.numberOfLines = 0
        recommandTitle.textAlignment = .center
        recommandTitle.lineBreakMode = NSLineBreakMode.byWordWrapping
        recommandTitle.font = UIFont(name: "System", size: 14.0)
        recommandTitle.text = genre.name
        recommandTitle.sizeToFit()
        
        return CGSize(width: recommandTitle.frame.width + 20, height: 28)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
}
