import UIKit

final class TNPostDetailViewController: TNController<TNPostDetailViewModel>, TNHostingVCProtocol {
    private var postDetailContentView: TNPostDetailContentView

    override init(viewModel: TNPostDetailViewModel) {
        postDetailContentView = TNPostDetailContentView(viewModel: viewModel)
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        configureHostingView(swiftUIView: postDetailContentView)
    }
}
