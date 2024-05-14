//
//  JSONArticleDecoder.swift
//  EvilNewsCorp
//
//  Created by Rihab Mehboob on 14/05/2024.
//

import Foundation

enum EvilArticleDataNamespace {
    // MARK: - EvilArticleData
    struct EvilArticleData: Codable {
        let article: Article
        let error: Bool
        let message: String
    }
    
    // MARK: - Article
    struct Article: Codable {
        let id: Int
        let title, summary: String
        let image: String
        let datePublished: String
        let feed: Feed
        let categories: [Category]
        let viewCount: Int
        let body: String
        let hasViewed: Bool
        
        enum CodingKeys: String, CodingKey {
            case id, title, summary, image
            case datePublished = "date_published"
            case feed, categories
            case viewCount = "view_count"
            case body, hasViewed
        }
    }
    
    // MARK: - Category
    struct Category: Codable {
        let id: Int
        let name: String
    }
    
    // MARK: - Feed
    struct Feed: Codable {
        let id: Int
        let name: String
        let logo: JSONNull?
    }
    
    // MARK: - Encode/decode helpers
    
    class JSONNull: Codable, Hashable {
        
        public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
        }
        
        public var hashValue: Int {
            return 0
        }
        
        public init() {}
        
        public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        }
    }
}
