//
//  TNDateWiseBooksViewController.swift
//  LaraApp
//
//  Created by TN-LAP-0134 on 15/6/26.
//

import UIKit

final class TNDateWiseBooksViewController: TNController<TNDateWiseBooksViewModel>, TNHostingVCProtocol {
    private var dateWiseBooksContentView: TNDateWiseBooksContentView

    override init(viewModel: TNDateWiseBooksViewModel) {
        dateWiseBooksContentView = TNDateWiseBooksContentView(viewModel: viewModel)
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        configureHostingView(swiftUIView: dateWiseBooksContentView)
    }
}
