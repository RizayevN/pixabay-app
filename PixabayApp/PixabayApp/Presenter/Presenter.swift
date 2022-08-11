//
//  Presenter.swift
//  PixabayApp
//
//  Created by Rizayev Nematzhon on 02.04.2022.
//

import UIKit

protocol MainViewPresenter: AnyObject {
    init(view: MainView)
    func viewDidLoad()
    func refresh()
    func getCurrentPage() -> Int
    // Images
    func getNextPageImage(image: String)
    func findImages(image: String)
    func findVideos(video: String)
}

class MainPresenter: MainViewPresenter {
    
    private weak var view: MainView?
    private var page = 1
    
    let networkingApi: NetworkingService!
    
    // MARK: - Initialization
    
    required init(view: MainView) {
        self.view = view
        self.networkingApi = Networking()
    }
    
    // MARK: - Life Cycle
    
    func viewDidLoad() {
        networkingApi.getImages(image: "flower", page: 1) { [weak self] result in
            self?.page = 1
            let images = result.hits
            self?.view?.onItemsReset(images: images)
        }
    }
    
    func findImages(image: String) {
        networkingApi.getImages(image: image, page: 1) { [weak self] result in
            let images = result.hits
            self?.view?.onItemsReset(images: images)
        }
    }
    
    func findVideos(video: String) {
        networkingApi.getVideos(video: video, page: 1) { [weak self] result in
            let videos = result.hits
            self?.view?.onItemsVideo(videos: videos)
        }
    }
    
    // MARK: - Public Methods
    
    func getCurrentPage() -> Int  {
        return self.page
    }
    
    func refresh() {
        self.page = 1

    }
    func getNextPageImage(image: String) {
        self.page += 1
//        networkingApi.getBeerList(page: self.page, completion: { [weak self] beers in
//            self?.view?.onItemsRetrieval(beers: beers)
//        })
        networkingApi.getImages(image: image, page: self.page) { [weak self] result in
            let images = result.hits
            self?.view?.onItemsRetrieval(images: images)
        }
    }
}
