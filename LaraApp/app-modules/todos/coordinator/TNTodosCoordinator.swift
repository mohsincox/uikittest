import UIKit
import Combine

final class TNTodosCoordinator: TNCoordinator {
    override func start() {
        let vm = TNTodosListViewModel()
        vm.bindStepper(to: coordinatorStepper)
        router.setRoot(TNTodosListViewController(viewModel: vm), hideBar: true)
    }

    override func bindStepper() {
        coordinatorStepper
            .receive(on: DispatchQueue.main)
            .sink { [weak self] step in
                switch step {
                case .popRequired: self?.router.pop()
                default: break
                }
            }
            .store(in: &cancellables)
    }
}
