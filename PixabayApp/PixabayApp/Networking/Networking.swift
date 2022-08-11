//
//  Networking.swift
//  PixabayApp
//
//  Created by Rizayev Nematzhon on 02.04.2022.
//

import Foundation

protocol NetworkingService {
    func getImages(image: String?, page: Int, completion: @escaping (PixabayImagesApi) -> ())
    func getVideos(video: String?, page: Int, completion: @escaping (PixabayVideosApi) -> ())
}

class Networking: NetworkingService {
    
    let session = URLSession.shared
    
    func getImages(image: String?, page: Int, completion: @escaping (PixabayImagesApi) -> ()) {
        let request = URLRequest(url: URL(
            string: "https://pixabay.com/api/?page=\(page)&q=\(image ?? "")%20&key=25564618-4b55ae01c1ae6b1da2f1339cb")!)
        let task = session.dataTask(with: request) { (data, _, _) in
            DispatchQueue.main.async {
                guard let data = data,
                      let response = try? JSONDecoder().decode(PixabayImagesApi.self, from: data) else {
                        return
                }
                completion(response)
            }
        }
        task.resume()
    }
    
    func getVideos(video: String?, page: Int, completion: @escaping (PixabayVideosApi) -> ()) {
        let request = URLRequest(url: URL(string: "https://pixabay.com/api/videos/?key=25564618-4b55ae01c1ae6b1da2f1339cb&q=yellow+flowers")!)
        let task = session.dataTask(with: request) { (data, _, _) in
            DispatchQueue.main.async {
                guard
                    let data = data,
                    let response = try? JSONDecoder().decode(PixabayVideosApi.self, from: data)
                else { return }
                completion(response)
            }
        }
        task.resume()
    }
}
