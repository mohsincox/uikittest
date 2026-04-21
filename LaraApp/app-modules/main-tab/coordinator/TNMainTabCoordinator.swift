import UIKit
import Combine

final class TNMainTabCoordinator: TNCoordinator {
    private let tabBarController = TNMainTabViewController()

    private var postsCoordinator: TNPostsCoordinator?
    private var todosCoordinator: TNTodosCoordinator?
    private var profileCoordinator: TNProfileCoordinator?

    override func start() {
        setupTabs()
        router.setRoot(tabBarController, hideBar: true)
    }

    override func bindStepper() {
        coordinatorStepper
            .receive(on: DispatchQueue.main)
            .sink { [weak self] step in
                switch step {
                case .loginRequired:
                    self?.coordinatorStepper.send(.loginRequired)
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }

    private func setupTabs() {
        let postsNav = makeNav()
        let postsCoordinator = TNPostsCoordinator(router: TNRouter(navigationController: postsNav))
        postsCoordinator.coordinatorStepper.subscribe(coordinatorStepper).store(in: &cancellables)
        postsCoordinator.start()
        self.postsCoordinator = postsCoordinator
        addChild(postsCoordinator)
        postsNav.tabBarItem = UITabBarItem(title: "Posts", image: UIImage(systemName: "doc.text"), tag: 0)

        let todosNav = makeNav()
        let todosCoordinator = TNTodosCoordinator(router: TNRouter(navigationController: todosNav))
        todosCoordinator.coordinatorStepper.subscribe(coordinatorStepper).store(in: &cancellables)
        todosCoordinator.start()
        self.todosCoordinator = todosCoordinator
        addChild(todosCoordinator)
        todosNav.tabBarItem = UITabBarItem(title: "Todos", image: UIImage(systemName: "checklist"), tag: 1)

        let profileNav = makeNav()
        let profileCoordinator = TNProfileCoordinator(router: TNRouter(navigationController: profileNav))
        profileCoordinator.coordinatorStepper.subscribe(coordinatorStepper).store(in: &cancellables)
        profileCoordinator.start()
        self.profileCoordinator = profileCoordinator
        addChild(profileCoordinator)
        profileNav.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 2)

        tabBarController.setViewControllers([postsNav, todosNav, profileNav], animated: false)
    }

    private func makeNav() -> UINavigationController {
        let nav = UINavigationController()
        nav.isNavigationBarHidden = true
        return nav
    }
}
