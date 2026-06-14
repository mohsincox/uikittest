//
//  TNDateWiseCategoriesViewController.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/06/14.
//

import UIKit

final class TNDateWiseCategoriesViewController: TNController<TNDateWiseCategoriesViewModel>, TNHostingVCProtocol {
    private var dateWiseCategoriesContentView: TNDateWiseCategoriesContentView

    override init(viewModel: TNDateWiseCategoriesViewModel) {
        dateWiseCategoriesContentView = TNDateWiseCategoriesContentView(viewModel: viewModel)
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        configureHostingView(swiftUIView: dateWiseCategoriesContentView)
    }
}
