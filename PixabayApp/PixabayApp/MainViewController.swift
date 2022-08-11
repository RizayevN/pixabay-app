//
//  MainViewController.swift
//  PixabayApp
//
//  Created by Rizayev Nematzhon on 02.04.2022.
//

import UIKit
import SnapKit
import AVKit

protocol MainView: AnyObject {
    func onItemsRetrieval(images: [ImagesList])
    func onItemsReset(images: [ImagesList])
    func onItemsVideo(videos: [VideosList])
}

final class MainViewController: UIViewController, UISearchBarDelegate {
    
    private let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: CollectionViewFlowLayout())
    private let segmentedControl: UISegmentedControl = .init(items: ["Images", "Videos"])
    private let searchBar: UISearchBar = .init()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let refreshControl = UIRefreshControl()
    
    private var images: [ImagesList] = .init()
    private var videos: [VideosList] = .init()
    
    var presenter: MainViewPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
        configureMainView()
    }
    
    func configureMainView() {
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            presenter.findImages(image: searchBar.text!)
            onItemsReset(images: images)
            searchBar.text = ""
        } else {
            presenter.findVideos(video: searchBar.text!)
            onItemsVideo(videos: videos)
            searchBar.text = ""
        }
    }
    
    @objc private func resetView() {
        activityIndicator.startAnimating()
        presenter.refresh()
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.activityIndicator.stopAnimating()
        }
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return images.count
        } else {
            return videos.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CollectionViewCell
        if segmentedControl.selectedSegmentIndex == 0 {
            cell?.setupCell(imageURL: images[indexPath.row].previewURL, title: images[indexPath.row].user)
        } else {
            if let id = videos[indexPath.row].pictureId {
              cell?.setupCell(imageURL: "https://i.vimeocdn.com/video/\(id)_200x150.jpg", title: videos[indexPath.row].user)
            }
          }
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if segmentedControl.selectedSegmentIndex == 0 {
            let previewViewController = ImageViewController(image: images[indexPath.row].largeImageURL)
            previewViewController.modalPresentationStyle = .overFullScreen
            UIView.animate(withDuration: 0.3) {
                self.present(previewViewController, animated: true, completion: nil)
            }
        } else {
            guard let url = URL(string: videos[indexPath.row].videos.medium.url) else { return }
            let player = AVPlayer(url: url)
            let vc = AVPlayerViewController()
            vc.player = player
            UIView.animate(withDuration: 0.3) {
              self.present(vc, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
         if (indexPath.row == images.count - 1 ) { //it's your last cell
             presenter.getNextPageImage(image: searchBar.text!)
         }
    }
}



extension MainViewController {
    
    private func setupUI() {
        setupViews()
        setupSearchBar()
        setupSegmentedControl()
        setupCollectionView()
        setupActivityAndRefresh()
    }
    
    private func setupViews() {
        [segmentedControl, searchBar, collectionView, activityIndicator].forEach {
            view.addSubview($0)
        }
        collectionView.addSubview(refreshControl)
        title = "Images and Movies"
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
        searchBar.backgroundImage = UIImage()
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    }
    
    private func setupSegmentedControl() {
        segmentedControl.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.height.equalTo(36)
        }
    }
    
    private func setupSearchBar() {
        searchBar.snp.makeConstraints {
            $0.leading.equalTo(segmentedControl.snp.leading)
            $0.trailing.equalTo(segmentedControl.snp.trailing)
            $0.top.equalTo(segmentedControl.snp.bottom).offset(16)
            $0.height.equalTo(36)
        }
    }
    
    private func setupCollectionView() {
        collectionView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalTo(searchBar.snp.bottom).offset(16)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setupActivityAndRefresh() {
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        refreshControl.addTarget(self, action: #selector(resetView), for: .valueChanged)
    }
}

extension MainViewController: MainView {
    
    func onItemsRetrieval(images: [ImagesList]) {
        self.images += images
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.collectionView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    
    func onItemsReset(images: [ImagesList]) {
        self.images = images
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.collectionView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    
    func onItemsVideo(videos: [VideosList]) {
        self.videos = videos
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.collectionView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
}
