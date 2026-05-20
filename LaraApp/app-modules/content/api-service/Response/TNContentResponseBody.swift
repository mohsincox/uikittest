//
//  TNContentResponseBody.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/04/22.
//

struct TNContentResponseBody: Decodable, Identifiable {
    let id: Int?
    let userId: Int?
    let title: String?
    let description: String?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, title, description
        case userId    = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
