//
//  TNDrawerMenuView.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/05/20.
//

import SwiftUI

struct TNDrawerMenuView: View {
    var onMenuItemTapped: ((TNDrawerMenuItem) -> Void)?

    private let items: [(TNDrawerMenuItem, String, String)] = [
        (.posts,      "Posts",      "doc.text"),
        (.todos,      "Todos",      "checklist"),
        (.profile,    "Profile",    "person.circle"),
        (.contents,   "Contents",   "rectangle.stack"),
        (.books,      "Books",      "books.vertical"),
        (.categories, "Categories", "list.bullet")
    ]

    var body: some View {
        VStack(spacing: 0) {
            Text("Menu")
                .font(.headline)
                .padding(.vertical, 24)

            Divider()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach(items, id: \.0) { item, title, icon in
                        Button {
                            onMenuItemTapped?(item)
                        } label: {
                            HStack(spacing: 14) {
                                Image(systemName: icon)
                                    .font(.system(size: 18))
                                    .foregroundColor(.blue)
                                    .frame(width: 28)
                                Text(title)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.primary)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 14)
                        }
                        Divider().padding(.leading, 62)
                    }
                }
            }
        }
        .background(Color(.systemBackground))
    }
}
