import UIKit
import Combine

final class TNPostsCoordinator: TNCoordinator {
    override func start() {
        showPostsList()
    }

    override func bindStepper() {
        coordinatorStepper
            .receive(on: DispatchQueue.main)
            .sink { [weak self] step in
                switch step {
                case .postDetailRequired(let post): self?.showPostDetail(post: post)
                case .createPostRequired:           self?.showPostForm(mode: .create)
                case .editPostRequired(let post):   self?.showPostForm(mode: .edit(post: post))
                case .popRequired:                  self?.router.pop()
                default: break
                }
            }
            .store(in: &cancellables)
    }

    private func showPostsList() {
        let vm = TNPostsListViewModel()
        vm.bindStepper(to: coordinatorStepper)
        router.setRoot(TNPostsListViewController(viewModel: vm), hideBar: true)
    }

    private func showPostDetail(post: TNPostResponseBody) {
        let vm = TNPostDetailViewModel(post: post)
        vm.bindStepper(to: coordinatorStepper)
        router.push(TNPostDetailViewController(viewModel: vm))
    }

    private func showPostForm(mode: TNPostFormMode) {
        let vm = TNPostFormViewModel(mode: mode)
        vm.bindStepper(to: coordinatorStepper)
        router.push(TNPostFormViewController(viewModel: vm))
    }
}
