//
//  TNCategoryTabViewController.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/06/03.
//

import UIKit

final class TNCategoryTabViewController: TNController<TNCategoryTabViewModel>, TNHostingVCProtocol {
    private var categoryTabContentView: TNCategoryTabContentView

    override init(viewModel: TNCategoryTabViewModel) {
        categoryTabContentView = TNCategoryTabContentView(viewModel: viewModel)
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        configureHostingView(swiftUIView: categoryTabContentView)
    }
}