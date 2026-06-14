//
//  TNChapterResponseBody.swift
//  LaraApp
//
//  Created by TN-LAP-0134 on 9/6/26.
//

import Foundation

struct TNChapterResponseBody: Decodable, Identifiable {
    let id: Int?
    let name: String?
    let bookId: Int?
    let content: String?
    let book: TNChapterBook?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, content, book
        case bookId = "book_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct TNChapterBook: Decodable {
    let id: Int?
    let title: String?
}

struct TNChapterListResponse: Decodable {
    let data: [TNChapterResponseBody]
}

/*
 import Foundation

 // MARK: - WelcomeElement
 struct WelcomeElement: Codable {
     let id: Int
     let name, content: String
     let bookID: Int
     let book: Book
     let createdAt, updatedAt: Date

     enum CodingKeys: String, CodingKey {
         case id, name, content
         case bookID = "book_id"
         case book
         case createdAt = "created_at"
         case updatedAt = "updated_at"
     }
 }

 // MARK: - Book
 struct Book: Codable {
     let id: Int
     let title: String
 }

 typealias Welcome = [WelcomeElement]
 */
