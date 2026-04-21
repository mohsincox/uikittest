import UIKit

final class TNTodosListViewController: TNController<TNTodosListViewModel>, TNHostingVCProtocol {
    private var todosListContentView: TNTodosListContentView

    override init(viewModel: TNTodosListViewModel) {
        todosListContentView = TNTodosListContentView(viewModel: viewModel)
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        configureHostingView(swiftUIView: todosListContentView)
    }
}
