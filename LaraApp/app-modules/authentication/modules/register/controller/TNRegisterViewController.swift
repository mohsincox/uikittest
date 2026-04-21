import UIKit

final class TNRegisterViewController: TNController<TNRegisterViewModel>, TNHostingVCProtocol {
    private var registerContentView: TNRegisterContentView

    override init(viewModel: TNRegisterViewModel) {
        registerContentView = TNRegisterContentView(viewModel: viewModel)
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        configureHostingView(swiftUIView: registerContentView)
    }
}
