//
//  TNBookResponseBody.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/05/04.
//

import Foundation

struct TNBookResponseBody: Decodable, Identifiable {
    let id: Int?
    let title: String?
    let author: String?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, title, author
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
