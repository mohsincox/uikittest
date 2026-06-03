//
//  TNProductResponseBody.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/06/03.
//

import Foundation

struct TNProductResponseBody: Decodable, Identifiable {
    let id: Int?
    let name: String?
    let categoryId: Int?
    let price: Double?
    let description: String?
    let category: TNProductCategory?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, description, price, category
        case categoryId = "category_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct TNProductCategory: Decodable {
    let id: Int?
    let name: String?
}

struct TNProductListResponse: Decodable {
    let data: [TNProductResponseBody]
}