import UIKit
import Combine

final class TNAuthCoordinator: TNCoordinator {
    override func start() {
        showLogin()
    }

    override func bindStepper() {
        coordinatorStepper
            .receive(on: DispatchQueue.main)
            .sink { [weak self] step in
                switch step {
                case .registerRequired:
                    self?.showRegister()
                case .popRequired:
                    self?.router.pop()
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }

    private func showLogin() {
        let vm = TNLoginViewModel()
        vm.bindStepper(to: coordinatorStepper)
        let vc = TNLoginViewController(viewModel: vm)
        router.setRoot(vc, hideBar: true)
    }

    private func showRegister() {
        let vm = TNRegisterViewModel()
        vm.bindStepper(to: coordinatorStepper)
        let vc = TNRegisterViewController(viewModel: vm)
        router.push(vc)
    }
}
