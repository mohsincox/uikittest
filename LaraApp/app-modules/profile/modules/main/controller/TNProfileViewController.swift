import UIKit

final class TNProfileViewController: TNController<TNProfileViewModel>, TNHostingVCProtocol {
    private var profileContentView: TNProfileContentView

    override init(viewModel: TNProfileViewModel) {
        profileContentView = TNProfileContentView(viewModel: viewModel)
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        configureHostingView(swiftUIView: profileContentView)
    }
}
