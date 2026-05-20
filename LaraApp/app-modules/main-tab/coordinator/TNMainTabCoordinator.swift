import UIKit
import Combine

final class TNMainTabCoordinator: TNCoordinator {
    private let tabBarController = TNMainTabViewController()

    private var postsCoordinator: TNPostsCoordinator?
    private var todosCoordinator: TNTodosCoordinator?
    private var profileCoordinator: TNProfileCoordinator?
    private var contentCoordinator: TNContentCoordinator?
    private var booksCoordinator: TNBooksCoordinator?
    private var categoriesCoordinator: TNCategoriesCoordinator?

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

        let contentNav = makeNav()
        let contentCoordinator = TNContentCoordinator(router: TNRouter(navigationController: contentNav))
        contentCoordinator.coordinatorStepper.subscribe(coordinatorStepper).store(in: &cancellables)
        contentCoordinator.start()
        self.contentCoordinator = contentCoordinator
        addChild(contentCoordinator)
        contentNav.tabBarItem = UITabBarItem(title: "Contents", image: UIImage(systemName: "rectangle.stack"), tag: 3)
        
        let booksNav = makeNav()
        let booksCoordinator = TNBooksCoordinator(router: TNRouter(navigationController: booksNav))
        booksCoordinator.coordinatorStepper.subscribe(coordinatorStepper).store(in: &cancellables)
        booksCoordinator.start()
        self.booksCoordinator = booksCoordinator
        addChild(booksCoordinator)
        booksNav.tabBarItem = UITabBarItem(title: "Books", image: UIImage(systemName: "books.vertical"), tag: 4)
        
        let categoriesNav = makeNav()
        let categoriesCoordinator = TNCategoriesCoordinator(router: TNRouter(navigationController: categoriesNav))
        categoriesCoordinator.coordinatorStepper.subscribe(coordinatorStepper).store(in: &cancellables)
        categoriesCoordinator.start()
        self.categoriesCoordinator = categoriesCoordinator
        addChild(categoriesCoordinator)
        categoriesNav.tabBarItem = UITabBarItem(title: "Categories", image: UIImage(systemName: "list.bullet"), tag: 5)

        tabBarController.setViewControllers([postsNav, todosNav, profileNav, contentNav, booksNav, categoriesNav], animated: false)
    }

    private func makeNav() -> UINavigationController {
        let nav = UINavigationController()
        nav.isNavigationBarHidden = true
        return nav
    }
}
