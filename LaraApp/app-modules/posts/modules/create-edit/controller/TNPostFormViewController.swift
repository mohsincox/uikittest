import UIKit

final class TNPostFormViewController: TNController<TNPostFormViewModel>, TNHostingVCProtocol {
    private var postFormContentView: TNPostFormContentView

    override init(viewModel: TNPostFormViewModel) {
        postFormContentView = TNPostFormContentView(viewModel: viewModel)
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        configureHostingView(swiftUIView: postFormContentView)
    }
}
