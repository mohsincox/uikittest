//
//  TNBookEditViewController.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/05/11.
//

import Foundation

final class TNBookEditViewController: TNController<TNBookEditViewModel>, TNHostingVCProtocol {
    private var bookEditContentView: TNBookEditContentView

    override init(viewModel: TNBookEditViewModel) {
        bookEditContentView = TNBookEditContentView(viewModel: viewModel)
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        configureHostingView(swiftUIView: bookEditContentView)
    }
}
