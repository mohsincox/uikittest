import UIKit
import SwiftUI
import Combine

protocol TNHostingVCProtocol: AnyObject {}

extension TNHostingVCProtocol where Self: UIViewController {
    func configureHostingView<V: View>(swiftUIView: V) {
        let hostingVC = UIHostingController(rootView: swiftUIView)
        addChild(hostingVC)
        view.addSubview(hostingVC.view)
        hostingVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        hostingVC.didMove(toParent: self)
    }
}

class TNController<VM: TNViewModel>: UIViewController, TNPresentable {
    let viewModel: VM
    var cancellables = Set<AnyCancellable>()

    var viewController: UIViewController { self }

    init(viewModel: VM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        print("init: \(type(of: self))🟢")
    }

    required init?(coder: NSCoder) { nil }

    deinit {
        print("deinit: \(type(of: self))🔴")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        viewModel.lifeCycle.didLoadSubject.send()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.lifeCycle.willAppearSubject.send()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.lifeCycle.didAppearSubject.send()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.lifeCycle.didDisappearSubject.send()
    }
}
