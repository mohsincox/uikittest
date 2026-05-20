//
//  TNBooksListViewController.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/05/03.
//

import UIKit

final class TNBooksListViewController: TNController<TNBooksListViewModel>, TNHostingVCProtocol {
    private var postsListContentView: TNBooksListContentView

    override init(viewModel: TNBooksListViewModel) {
        postsListContentView = TNBooksListContentView(viewModel: viewModel)
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        configureHostingView(swiftUIView: postsListContentView)
    }
}
