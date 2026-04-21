import UIKit

class TNRouter: NSObject, TNPresentable {
    let navigationController: UINavigationController
    private var completions: [UIViewController: () -> Void] = [:]

    var viewController: UIViewController { navigationController }

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        navigationController.delegate = self
    }

    func push(_ presentable: TNPresentable, animated: Bool = true, completion: (() -> Void)? = nil) {
        let vc = presentable.viewController
        if let completion { completions[vc] = completion }
        navigationController.pushViewController(vc, animated: animated)
    }

    func pop(animated: Bool = true) {
        if let vc = navigationController.popViewController(animated: animated) {
            runCompletion(for: vc)
        }
    }

    func popToRoot(animated: Bool = true) {
        navigationController.popToRootViewController(animated: animated)?
            .forEach { runCompletion(for: $0) }
    }

    func present(_ presentable: TNPresentable, animated: Bool = true, completion: (() -> Void)? = nil) {
        navigationController.present(presentable.viewController, animated: animated, completion: completion)
    }

    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        navigationController.dismiss(animated: animated, completion: completion)
    }

    func setRoot(_ presentable: TNPresentable, hideBar: Bool = false, completion: (() -> Void)? = nil) {
        navigationController.isNavigationBarHidden = hideBar
        navigationController.setViewControllers([presentable.viewController], animated: false)
        completion?()
    }

    private func runCompletion(for vc: UIViewController) {
        guard let completion = completions[vc] else { return }
        completion()
        completions.removeValue(forKey: vc)
    }
}

extension TNRouter: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                               didShow viewController: UIViewController,
                               animated: Bool) {
        guard let poppedVC = navigationController.transitionCoordinator?.viewController(forKey: .from),
              !navigationController.viewControllers.contains(poppedVC) else { return }
        runCompletion(for: poppedVC)
    }
}
