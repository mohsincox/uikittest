//
//  TNDrawerViewController.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/05/20.
//

import UIKit

final class TNDrawerViewController: UIViewController {
    private let containerView = UIView()
    private let drawerOverlay = UIView()
    private let drawerContentView: UIView
    private(set) var mainContentController: UIViewController
    private var drawerLeadingConstraint: NSLayoutConstraint?
    private var isDrawerOpen = false

    init(mainContent: UIViewController, drawerContent: UIView) {
        self.mainContentController = mainContent
        self.drawerContentView = drawerContent
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        addChild(mainContentController)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        mainContentController.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(mainContentController.view)
        mainContentController.didMove(toParent: self)

        drawerOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        drawerOverlay.alpha = 0
        drawerOverlay.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(drawerOverlay)
        drawerOverlay.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeDrawerTapped)))

        drawerContentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(drawerContentView)

        let leading = drawerContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -TNConstants.drawerWidth)
        drawerLeadingConstraint = leading

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            mainContentController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            mainContentController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            mainContentController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            mainContentController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            drawerOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            drawerOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            drawerOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            drawerOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            drawerContentView.topAnchor.constraint(equalTo: view.topAnchor),
            leading,
            drawerContentView.widthAnchor.constraint(equalToConstant: TNConstants.drawerWidth),
            drawerContentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func closeDrawerTapped() { closeDrawer() }

    func openDrawer() {
        guard !isDrawerOpen else { return }
        isDrawerOpen = true
        drawerLeadingConstraint?.constant = 0
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
            self.drawerOverlay.alpha = 1
        }
    }

    func closeDrawer() {
        guard isDrawerOpen else { return }
        isDrawerOpen = false
        drawerLeadingConstraint?.constant = -TNConstants.drawerWidth
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
            self.drawerOverlay.alpha = 0
        }
    }

    func toggleDrawer() {
        isDrawerOpen ? closeDrawer() : openDrawer()
    }

    func swapMainContent(_ newVC: UIViewController) {
        mainContentController.willMove(toParent: nil)
        mainContentController.view.removeFromSuperview()
        mainContentController.removeFromParent()

        addChild(newVC)
        newVC.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(newVC.view)
        NSLayoutConstraint.activate([
            newVC.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            newVC.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            newVC.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            newVC.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        newVC.didMove(toParent: self)
        mainContentController = newVC
    }
}

extension TNDrawerViewController: TNPresentable {
    var viewController: UIViewController { self }
}
