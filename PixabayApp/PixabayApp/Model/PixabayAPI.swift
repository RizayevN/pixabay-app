//
//  PixabayAPI.swift
//  PixabayApp
//
//  Created by Rizayev Nematzhon on 02.04.2022.
//

import Foundation

// Images
struct PixabayImagesApi: Decodable {
    let hits: [ImagesList]
}

struct ImagesList: Decodable {
    let user: String
    let previewURL: String
    let largeImageURL: String
}

// Videos
struct PixabayVideosApi: Decodable {
    let hits: [VideosList]
}

struct VideosList: Decodable {
    let user: String
    let videos: Videos
    let pictureId: String?
    
    enum CodingKeys: String, CodingKey {
      case pictureId = "picture_id"
      case videos
      case user
    }
}

struct Videos: Decodable {
    let large: LargeVideo
    let medium: MediumVideo
}

struct LargeVideo: Decodable {
    let url: String
}

struct MediumVideo: Decodable {
    let url: String
}





