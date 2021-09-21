//
//  PlacesModel.swift
//  CollectionView
//
//  Created by Felipe Gil on 2021-09-13.
//

import Foundation

struct PlacesResponse: Decodable {
    let places: [PlacesModel]
    
}

struct PlacesModel: Decodable, Identifiable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        imageName = try container.decode(String.self, forKey: .imageName)
        imageURL = try container.decode(String.self, forKey: .imageURL)
    }
    
    public let id: Int
    public let imageName: String
    public let imageURL: String
    
    private enum CodingKeys: String, CodingKey {
        case id, imageName, imageURL
    }
}
