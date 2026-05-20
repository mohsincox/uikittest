//
//  TNContentListViewController.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/04/22.
//

import UIKit

final class TNContentListViewController: TNController<TNContentListViewModel>, TNHostingVCProtocol {
    private var contentsListContentView: TNContentListContentView

    override init(viewModel: TNContentListViewModel) {
        contentsListContentView = TNContentListContentView(viewModel: viewModel)
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        configureHostingView(swiftUIView: contentsListContentView)
    }
}
