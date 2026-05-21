//
//  TNDrawerContentView.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/05/20.
//

import UIKit
import SwiftUI

final class TNDrawerContentView: UIView {
    var onMenuItemTapped: ((TNDrawerMenuItem) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        let menuView = TNDrawerMenuView { [weak self] item in
            self?.onMenuItemTapped?(item)
        }
        let host = UIHostingController(rootView: menuView)
        host.view.translatesAutoresizingMaskIntoConstraints = false
        host.view.backgroundColor = .clear
        addSubview(host.view)
        NSLayoutConstraint.activate([
            host.view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            host.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            host.view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
