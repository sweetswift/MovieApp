//
//  MovieModel.swift
//  MovieApp
//
//  Created by chungwoolee on 2023/01/04.
//

import Foundation

struct MovieModel: Codable {
    let resultCount: Int
    let results: [Result]
}

struct Result: Codable {
    let trackName: String
    let previewUrl: String
    let image: String
    let shortDescription: String?
    let longDescription: String
    let trackPrice: Double
    let currency: String
    
    enum CodingKeys: String, CodingKey {
        case image = "artworkUrl100"
        case trackName
        case previewUrl
        case shortDescription
        case longDescription
        case trackPrice
        case currency
    }
}
