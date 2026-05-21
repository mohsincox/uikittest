import UIKit
import Combine

final class TNMainTabCoordinator: TNCoordinator {
    private let tabBarController = TNMainTabViewController()
    private var drawerViewController: TNDrawerViewController?

    private var postsCoordinator: TNPostsCoordinator?
    private var todosCoordinator: TNTodosCoordinator?
    private var profileCoordinator: TNProfileCoordinator?
    private var contentCoordinator: TNContentCoordinator?
    private var booksCoordinator: TNBooksCoordinator?
    private var categoriesCoordinator: TNCategoriesCoordinator?

    override func start() {
        setupTabs()
        let drawerContent = TNDrawerContentView()
        drawerContent.onMenuItemTapped = { [weak self] item in
            self?.handleDrawerTap(item)
        }
        let drawerVC = TNDrawerViewController(mainContent: tabBarController, drawerContent: drawerContent)
        self.drawerViewController = drawerVC
        router.setRoot(drawerVC, hideBar: true)
    }

    override func bindStepper() {
        coordinatorStepper
            .receive(on: DispatchQueue.main)
            .sink { [weak self] step in
                switch step {
                case .toggleDrawerRequired: self?.drawerViewController?.toggleDrawer()
                case .loginRequired:        self?.coordinatorStepper.send(.loginRequired)
                default: break
                }
            }
            .store(in: &cancellables)
    }

    private func setupTabs() {
        // Posts
        let postsNav = makeNav()
        let postsCoordinator = TNPostsCoordinator(router: TNRouter(navigationController: postsNav))
        postsCoordinator.coordinatorStepper.subscribe(coordinatorStepper).store(in: &cancellables)
        postsCoordinator.start()
        self.postsCoordinator = postsCoordinator
        addChild(postsCoordinator)
        postsNav.tabBarItem = UITabBarItem(title: "Posts", image: UIImage(systemName: "doc.text"), tag: 0)

        // Todos
        let todosNav = makeNav()
        let todosCoordinator = TNTodosCoordinator(router: TNRouter(navigationController: todosNav))
        todosCoordinator.coordinatorStepper.subscribe(coordinatorStepper).store(in: &cancellables)
        todosCoordinator.start()
        self.todosCoordinator = todosCoordinator
        addChild(todosCoordinator)
        todosNav.tabBarItem = UITabBarItem(title: "Todos", image: UIImage(systemName: "checklist"), tag: 1)

        // Profile
        let profileNav = makeNav()
        let profileCoordinator = TNProfileCoordinator(router: TNRouter(navigationController: profileNav))
        profileCoordinator.coordinatorStepper.subscribe(coordinatorStepper).store(in: &cancellables)
        profileCoordinator.start()
        self.profileCoordinator = profileCoordinator
        addChild(profileCoordinator)
        profileNav.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 2)

        tabBarController.setViewControllers([postsNav, todosNav, profileNav], animated: false)
    }

//    private func handleDrawerTap(_ item: TNDrawerMenuItem) {
//        drawerViewController?.closeDrawer()
//        switch item {
//        case .posts:      tabBarController.selectedIndex = 0
//        case .todos:      tabBarController.selectedIndex = 1
//        case .profile:    tabBarController.selectedIndex = 2
//        case .contents:   showSidebar(.content)
//        case .books:      showSidebar(.books)
//        case .categories: showSidebar(.categories)
//        }
//    }
    
    private func handleDrawerTap(_ item: TNDrawerMenuItem) {
        drawerViewController?.closeDrawer()
        switch item {
        case .posts:
            restoreTabBar()
            tabBarController.selectedIndex = 0
        case .todos:
            restoreTabBar()
            tabBarController.selectedIndex = 1
        case .profile:
            restoreTabBar()
            tabBarController.selectedIndex = 2
        case .contents:   showSidebar(.content)
        case .books:      showSidebar(.books)
        case .categories: showSidebar(.categories)
        }
    }


    private enum SidebarDestination { case content, books, categories }

    private func showSidebar(_ destination: SidebarDestination) {
        let sidebarNav = makeNav()
        let coordinator: TNCoordinator
        switch destination {
        case .content:
            let c = TNContentCoordinator(router: TNRouter(navigationController: sidebarNav))
            contentCoordinator = c
            coordinator = c
        case .books:
            let c = TNBooksCoordinator(router: TNRouter(navigationController: sidebarNav))
            booksCoordinator = c
            coordinator = c
        case .categories:
            let c = TNCategoriesCoordinator(router: TNRouter(navigationController: sidebarNav))
            categoriesCoordinator = c
            coordinator = c
        }

        // When root of sidebar sends popRequired → restore tab bar
        coordinator.coordinatorStepper
            .receive(on: DispatchQueue.main)
            .sink { [weak self] step in
                switch step {
                case .popRequired:
                    // Only restore tab bar when popping from the root list screen
                    if coordinator.router.navigationController.viewControllers.count <= 1 {
                        self?.restoreTabBar()
                    }
                case .toggleDrawerRequired:
                    self?.drawerViewController?.toggleDrawer()
                default: break
                }
            }
            .store(in: &cancellables)

        addChild(coordinator)
        coordinator.start()
        drawerViewController?.swapMainContent(sidebarNav)
    }

//    private func restoreTabBar() {
//        drawerViewController?.swapMainContent(tabBarController)
//    }
    private func restoreTabBar() {
        guard drawerViewController?.mainContentController !== tabBarController else { return }
        drawerViewController?.swapMainContent(tabBarController)
    }

    private func makeNav() -> UINavigationController {
        let nav = UINavigationController()
        nav.isNavigationBarHidden = true
        return nav
    }
}
