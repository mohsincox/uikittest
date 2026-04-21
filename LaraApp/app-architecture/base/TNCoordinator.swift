import UIKit
import Combine

protocol TNPresentable {
    var viewController: UIViewController { get }
}

class TNCoordinator: NSObject {
    var childCoordinators: [TNCoordinator] = []
    let router: TNRouter
    var cancellables = Set<AnyCancellable>()
    let coordinatorStepper = PassthroughSubject<TNStep, Never>()

    init(router: TNRouter) {
        self.router = router
        super.init()
        print("init: \(type(of: self))🟢")
        bindStepper()
    }

    deinit {
        print("deinit: \(type(of: self))🔴")
    }

    func start() {
        fatalError("start() must be overridden")
    }

    func bindStepper() {}

    func addChild(_ coordinator: TNCoordinator) {
        childCoordinators.append(coordinator)
    }

    func removeChild(_ coordinator: TNCoordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}
