//
//  TNCategoryCreateViewController.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/05/18.
//

import UIKit

final class TNCategoryCreateViewController: TNController<TNCategoryCreateViewModel>, TNHostingVCProtocol {
    private var categoriesListContentView: TNCategoryCreateContentView

    override init(viewModel: TNCategoryCreateViewModel) {
        categoriesListContentView = TNCategoryCreateContentView(viewModel: viewModel)
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        configureHostingView(swiftUIView: categoriesListContentView)
    }
}
