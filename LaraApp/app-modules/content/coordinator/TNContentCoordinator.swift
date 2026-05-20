//
//  TNContentCoordinator.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/04/22.
//

import UIKit
import Combine

final class TNContentCoordinator: TNCoordinator {
    override func start() {
        showContentsList()
    }

    override func bindStepper() {
        coordinatorStepper
            .receive(on: DispatchQueue.main)
            .sink { [weak self] step in
                switch step {
                case .contentDetailRequired(let post): self?.showPostDetail(post: post)
                case .createContentRequired:           self?.showContentForm(mode: .create)
                case .editContentRequired(let post):   self?.showContentForm(mode: .edit(content: post))
                case .popRequired:                  self?.router.pop()
                default: break
                }
            }
            .store(in: &cancellables)
    }

    private func showContentsList() {
        let vm = TNContentListViewModel()
        vm.bindStepper(to: coordinatorStepper)
        router.setRoot(TNContentListViewController(viewModel: vm), hideBar: true)
    }

    private func showPostDetail(post: TNContentResponseBody) {
        let vm = TNContentDetailViewModel(content: post)
        vm.bindStepper(to: coordinatorStepper)
        router.push(TNContentDetailViewController(viewModel: vm))
    }

    private func showContentForm(mode: TNContentFormMode) {
        let vm = TNContentFormViewModel(mode: mode)
        vm.bindStepper(to: coordinatorStepper)
        router.push(TNContentFormViewController(viewModel: vm))
    }
}
