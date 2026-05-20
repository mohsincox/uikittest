//
//  TNBookDetailViewController.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/05/05.
//

import UIKit

final class TNBookDetailViewController: TNController<TNBookDetailViewModel>, TNHostingVCProtocol {
    private var bookDetailContentView: TNBookDetailContentView

    override init(viewModel: TNBookDetailViewModel) {
        bookDetailContentView = TNBookDetailContentView(viewModel: viewModel)
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        configureHostingView(swiftUIView: bookDetailContentView)
    }
}
