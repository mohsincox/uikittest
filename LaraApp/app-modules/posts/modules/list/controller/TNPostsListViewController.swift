import UIKit

final class TNPostsListViewController: TNController<TNPostsListViewModel>, TNHostingVCProtocol {
    private var postsListContentView: TNPostsListContentView

    override init(viewModel: TNPostsListViewModel) {
        postsListContentView = TNPostsListContentView(viewModel: viewModel)
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        configureHostingView(swiftUIView: postsListContentView)
    }
}
