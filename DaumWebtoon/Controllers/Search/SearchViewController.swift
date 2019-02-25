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
    private var isFirst = true
    private var genres: [Genre]?
    private var podcasts: [PodCastSearch]?
    private var shownIndexPaths = [IndexPath]()
    private var selectedImage: UIImageView?
    private var selectedCellOriginY: CGFloat?
    private var bottomAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchRecommandationPodcast()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidDisappear), name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirst {
            UIView.animate(withDuration: 0.6, animations: {
                self.halfView.frame.origin.y -= self.view.bounds.height / 2
                self.bottomAnchor = self.halfView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
                self.bottomAnchor?.isActive = true
            })
            isFirst = false
        }
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
    
    private func hideHalfBottomView() {
        UIView.animate(withDuration: 1.0, animations: {
            self.bottomAnchor?.isActive = false
            self.halfView.frame.origin.y += self.view.bounds.height / 2
            self.bottomAnchor = self.halfView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: self.view.bounds.size.height / 2)
            self.bottomAnchor?.isActive = true
        })
    }
    
    private func showHalfBottomView() {
        UIView.animate(withDuration: 0.6, animations: {
            self.bottomAnchor?.isActive = true
            self.halfView.frame.origin.y -= self.view.bounds.height / 2
        })
    }
    
    // MARK :- event handling
    @objc func handleEdgeGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        let percentThreshold: CGFloat = 0.3
        
        let translation = recognizer.translation(in: view)
        let horizontalMovement = translation.x / view.bounds.width
        let rightMovement = fmaxf(Float(horizontalMovement), 0.0)
        let rightMovementPercent = fminf(rightMovement, 1.0)
        let progress = CGFloat(rightMovementPercent)
        
        guard let interactor = interactor else { return }
        
        switch recognizer.state {
        case .began:
            interactor.hasStarted = true
            dismiss(animated: true, completion: nil)
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish
                ? interactor.finish()
                : interactor.cancel()
        default:
            break
        }
    }
    
    @objc func keyboardWillAppear() {
        podcastsTableView.isHidden = false
        hideHalfBottomView()
    }
    
    @objc func keyboardDidDisappear() {
        podcastsTableView.isHidden = true
        showHalfBottomView()
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
        showMiniPlayer()
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let genre = genres?[indexPath.item] else { return CGSize(width: 0, height: 0) }
        
        let recommandTitle = UILabel(frame: CGRect.zero)
        recommandTitle.numberOfLines = 0
        recommandTitle.textAlignment = .center
        recommandTitle.lineBreakMode = NSLineBreakMode.byWordWrapping
        recommandTitle.font = UIFont(name: "System", size: 14.0)
        recommandTitle.text = genre.name
        recommandTitle.sizeToFit()
        
        return CGSize(width: recommandTitle.frame.width + 18, height: 28)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
}
