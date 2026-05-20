//
//  TNCategoryEditViewController.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/05/19.
//

import UIKit

final class TNCategoryEditViewController: TNController<TNCategoryEditViewModel>, TNHostingVCProtocol {
    private var bookDetailContentView: TNCategoryEditContentView

    override init(viewModel: TNCategoryEditViewModel) {
        bookDetailContentView = TNCategoryEditContentView(viewModel: viewModel)
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        configureHostingView(swiftUIView: bookDetailContentView)
    }
}
