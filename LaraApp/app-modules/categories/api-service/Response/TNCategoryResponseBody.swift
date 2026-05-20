//
//  TNCategoryResponseBody.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/05/11.
//

import Foundation

struct TNCategoryResponseBody: Decodable, Identifiable {
    let id: Int?
    let name: String?
    let remark: String?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, remark
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
