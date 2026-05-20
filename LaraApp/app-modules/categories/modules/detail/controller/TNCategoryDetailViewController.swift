//
//  TNCategoryDetailViewController.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/05/14.
//

import UIKit

final class TNCategoryDetailViewController: TNController<TNCategoryDetailViewModel>, TNHostingVCProtocol {
    private var bookDetailContentView: TNCategoryDetailContentView

    override init(viewModel: TNCategoryDetailViewModel) {
        bookDetailContentView = TNCategoryDetailContentView(viewModel: viewModel)
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        configureHostingView(swiftUIView: bookDetailContentView)
    }
}
