//
//  TNCategoriesCoordinator.swift
//  LaraApp
//
//  Created by TechnoNext on 2026/05/11.
//

import UIKit
import Combine

final class TNCategoriesCoordinator: TNCoordinator {
    override func start() {
        showBooksList()
    }
    
    override func bindStepper() {
            coordinatorStepper
                .receive(on: DispatchQueue.main)
                .sink { [weak self] step in
                    switch step {
                    case .categoryDetailRequired(let category): self?.showCategoryDetail(category: category)
                    case .createCategoryRequired: self?.showCategoryForm()
                    case .editCategoryRequired(let category): self?.editCategory(category: category)
                    case .categoryTabRequired: self?.showCategoryTab()
                    case .dateWiseCategoriesRequired: self?.showDateWiseCategories()
//                    case .editBookRequired(let book): self?.editBookForm(book: book)
                    case .popRequired: self?.router.pop()
                    default: break
                    }
                }
                .store(in: &cancellables)
        }
    
    private func showBooksList() {
        let vm = TNCategoriesListViewModel()
        vm.bindStepper(to: coordinatorStepper)
        router.setRoot(TNCategoriesListViewController(viewModel: vm), hideBar: true)
    }

    private func showDateWiseCategories() {
        let vm = TNDateWiseCategoriesViewModel(apiService: TNCategoryApiService())
        vm.bindStepper(to: coordinatorStepper)
        router.push(TNDateWiseCategoriesViewController(viewModel: vm))
    }

    private func showCategoryTab() {
        let vm = TNCategoryTabViewModel()
        vm.bindStepper(to: coordinatorStepper)
        router.push(TNCategoryTabViewController(viewModel: vm))
    }

    private func showCategoryDetail(category: TNCategoryResponseBody) {
        print("category ddddddd")
            let vm = TNCategoryDetailViewModel(category: category)
            vm.bindStepper(to: coordinatorStepper)
            router.push(TNCategoryDetailViewController(viewModel: vm))
    }
    
    private func showCategoryForm() {
        print("category form")
        let vm = TNCategoryCreateViewModel(name: "", remark: "", isLoading: false, errorMessage: "", apiService: TNCategoryApiService())
        vm.bindStepper(to: coordinatorStepper)
        router.push(TNCategoryCreateViewController(viewModel: vm))
    }
    
    private func editCategory(category: TNCategoryResponseBody) {
        print("edit category")
        let vm = TNCategoryEditViewModel(id: category.id ?? 0, name: category.name ?? "", remark: category.remark ?? "", apiService: TNCategoryApiService())
        vm.bindStepper(to: coordinatorStepper)
        router.push(TNCategoryEditViewController(viewModel: vm))
    }
}
