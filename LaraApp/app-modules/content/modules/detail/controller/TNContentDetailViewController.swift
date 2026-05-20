//
//  TNContentDetailViewController.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/04/22.
//

import UIKit

final class TNContentDetailViewController: TNController<TNContentDetailViewModel>, TNHostingVCProtocol {
    private var contentDetailContentView: TNContentDetailContentView

    override init(viewModel: TNContentDetailViewModel) {
        contentDetailContentView = TNContentDetailContentView(viewModel: viewModel)
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        configureHostingView(swiftUIView: contentDetailContentView)
    }
}
