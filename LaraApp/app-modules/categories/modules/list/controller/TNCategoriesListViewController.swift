//
//  TNCategoriesListViewController.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/05/11.
//

import UIKit

final class TNCategoriesListViewController: TNController<TNCategoriesListViewModel>, TNHostingVCProtocol {
    private var categoriesListContentView: TNCategoriesListContentView

    override init(viewModel: TNCategoriesListViewModel) {
        categoriesListContentView = TNCategoriesListContentView(viewModel: viewModel)
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        configureHostingView(swiftUIView: categoriesListContentView)
    }
}

