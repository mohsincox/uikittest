//
//  TNBooksCoordinator.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/05/03.
//

import UIKit
import Combine

final class TNBooksCoordinator: TNCoordinator {
    override func start() {
        showBooksList()
    }
    
    override func bindStepper() {
        coordinatorStepper
            .receive(on: DispatchQueue.main)
            .sink { [weak self] step in
                switch step {
                case .bookDetailRequired(let book): self?.showBookDetail(book: book)
                case .createBookRequired: self?.showBookForm()
                case .editBookRequired(let book): self?.editBookForm(book: book)
                case .popRequired: self?.router.pop()
                default: break
                }
            }
            .store(in: &cancellables)
    }
    
    private func showBooksList() {
        let vm = TNBooksListViewModel()
        vm.bindStepper(to: coordinatorStepper)
        router.setRoot(TNBooksListViewController(viewModel: vm), hideBar: true)
    }

    private func showBookDetail(book: TNBookResponseBody) {
        let vm = TNBookDetailViewModel(book: book)
        vm.bindStepper(to: coordinatorStepper)
        router.push(TNBookDetailViewController(viewModel: vm))
    }
    
    private func showBookForm() {
        let vm = TNBookFormViewModel(title: "", author: "", isLoading: false, errorMessage: "", apiService: TNBookApiService())
        vm.bindStepper(to: coordinatorStepper)
        router.push(TNBookFormViewController(viewModel: vm))
    }
    
    private func editBookForm(book: TNBookResponseBody) {
        let vm = TNBookEditViewModel(id: book.id ?? 0, title: book.title ?? "", author: book.author ?? "", apiService: TNBookApiService())
        vm.bindStepper(to: coordinatorStepper)
        router.push(TNBookEditViewController(viewModel: vm))
    }
}
