import UIKit
import Combine

final class TNAppCoordinator: TNCoordinator {
    private let window: UIWindow

    init(window: UIWindow) {
        let navController = UINavigationController()
        navController.isNavigationBarHidden = true
        self.window = window
        super.init(router: TNRouter(navigationController: navController))
        window.rootViewController = navController
        window.makeKeyAndVisible()
    }

    override func start() {
        if KeychainStorageManager.shared.get(.accessToken) != nil {
            showMainTab()
        } else {
            showAuth()
        }
    }

    override func bindStepper() {
        coordinatorStepper
            .receive(on: DispatchQueue.main)
            .sink { [weak self] step in
                switch step {
                case .mainTabRequired: self?.showMainTab()
                case .loginRequired:   self?.showAuth()
                default: break
                }
            }
            .store(in: &cancellables)
    }

    private func showAuth() {
        childCoordinators.removeAll()
        let coordinator = TNAuthCoordinator(router: router)
        coordinator.coordinatorStepper.subscribe(coordinatorStepper).store(in: &cancellables)
        coordinator.start()
        addChild(coordinator)
    }

    private func showMainTab() {
        childCoordinators.removeAll()
        let coordinator = TNMainTabCoordinator(router: router)
        coordinator.coordinatorStepper.subscribe(coordinatorStepper).store(in: &cancellables)
        coordinator.start()
        addChild(coordinator)
    }
}
