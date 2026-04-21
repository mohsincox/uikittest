import UIKit

final class TNLoginViewController: TNController<TNLoginViewModel>, TNHostingVCProtocol {
    private var loginContentView: TNLoginContentView

    override init(viewModel: TNLoginViewModel) {
        loginContentView = TNLoginContentView(viewModel: viewModel)
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        configureHostingView(swiftUIView: loginContentView)
    }
}
