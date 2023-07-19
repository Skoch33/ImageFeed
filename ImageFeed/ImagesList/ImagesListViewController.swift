//
//  ViewController.swift
//  ImageFeed
//
//  Created by Semen Kocherga on 30.04.2023.
//

import UIKit
import Kingfisher

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    func updateTableViewAnimated()
    var photos: [Photo] { get set }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
}

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    
    //MARK: - UIStatusBarStyle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - IBOutlet
    
    @IBOutlet private var tableView: UITableView!
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        presenter?.view = self
        presenter?.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: ImagesListService.DidChangeNotification, object: nil)
    }
    
    // MARK: - Functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let photo = photos[indexPath.row]
            guard let imageURL = URL(string: photo.largeImageURL!) else { return }
            viewController.imageURL = imageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        guard let newCount = presenter?.imagesListService.photos.count else { return }
        guard let newPhotos = presenter?.imagesListService.photos else { return }
        photos = newPhotos
        if oldCount != newCount {
            tableView.performBatchUpdates{
                let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
                tableView.insertRows(at: indexPaths, with: .bottom)
            } completion: { _ in }
        }
    }
    
    //MARK: - Private Properties
    lazy var presenter: ImagesListPresenterProtocol? = {
        return ImagesListPresenter()
    } ()
    var photos: [Photo] = []
    private let imagesListService = ImagesListService.shared
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
}

//MARK: - ImagesListViewController

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with IndexPath: IndexPath) {
        let imageUrl = photos[IndexPath.row].thumbImageURL!
        let url = URL(string: imageUrl)
        let placeholder = UIImage(named: "Stub")
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: url, placeholder: placeholder) { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadRows(at: [IndexPath], with: .automatic)
            cell.cellImage.kf.indicatorType = .none
        }
        if let date = imagesListService.photos[IndexPath.row].createdAt {
            cell.dateLabel.text = dateFormatter.string(from: date)
        } else {
            cell.dateLabel.text = ""
        }
        let isLiked = imagesListService.photos[IndexPath.row].isLiked == false
        cell.likeButton.accessibilityIdentifier = "likeButton"
        let likeImage = isLiked ? UIImage(named: "like_button_off") : UIImage(named: "like_button_on")
        cell.likeButton.setImage(likeImage, for: .normal)
        cell.selectionStyle = .none
    }
}

//MARK: - UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = photos[indexPath.row]
        let imageSize = CGSize(width: cell.width, height: cell.height)
        let aspectRatio = imageSize.width / imageSize.height
        return tableView.frame.width / aspectRatio
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let visibleIndexPaths = tableView.indexPathsForVisibleRows, visibleIndexPaths.contains(indexPath) {
            presenter?.checkCompletedList(indexPath)
        }
    }
}


//MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        imageListCell.delegate = self
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

//MARK: - ImagesListCellDelegate

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        presenter?.setLike(photoId: photo.id, isLike: photo.isLiked) { result in
            DispatchQueue.main.async {
                switch result {
                case.success:
                    guard let newPhotos = self.presenter?.imagesListService.photos else { return }
                    self.photos = newPhotos
                    cell.setIsLiked(isLiked: self.photos[indexPath.row].isLiked)
                    UIBlockingProgressHUD.dismiss()
                case.failure(let error):
                    UIBlockingProgressHUD.dismiss()
                    self.showLikeErrorAlert(with: error)
                }
            }
        }
    }
    
    func showLikeErrorAlert(with error: Error)  {
        guard let alert = presenter?.makeAlert(with: Error.self as! Error) else { return }
        present(alert, animated: true, completion: nil)
    }
}


