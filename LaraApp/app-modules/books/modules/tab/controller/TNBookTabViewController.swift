//
//  TNBookTabViewController.swift
//  LaraApp
//
//  Created by TN-LAP-0134 on 10/6/26.
//

import UIKit

final class TNBookTabViewController: TNController<TNBookTabViewModel>, TNHostingVCProtocol {
    private var bookTabContentView: TNBookTabContentView

    override init(viewModel: TNBookTabViewModel) {
        bookTabContentView = TNBookTabContentView(viewModel: viewModel)
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        configureHostingView(swiftUIView: bookTabContentView)
    }
}
