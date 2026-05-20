//
//  TNContentFormViewController.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/04/22.
//

import UIKit

final class TNContentFormViewController: TNController<TNContentFormViewModel>, TNHostingVCProtocol {
    private var contentFormContentView: TNContentFormContentView

    override init(viewModel: TNContentFormViewModel) {
        contentFormContentView = TNContentFormContentView(viewModel: viewModel)
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        configureHostingView(swiftUIView: contentFormContentView)
    }
}
