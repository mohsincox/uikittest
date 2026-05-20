//
//  TNBookFormViewController.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/05/07.
//

import Foundation

final class TNBookFormViewController: TNController<TNBookFormViewModel>, TNHostingVCProtocol {
    private var bookFormContentView: TNBookFormContentView

    override init(viewModel: TNBookFormViewModel) {
        bookFormContentView = TNBookFormContentView(viewModel: viewModel)
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        configureHostingView(swiftUIView: bookFormContentView)
    }
}
