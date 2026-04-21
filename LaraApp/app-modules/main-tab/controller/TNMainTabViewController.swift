import UIKit

final class TNMainTabViewController: UITabBarController, TNPresentable {
    var viewController: UIViewController { self }
    init() {
        super.init(nibName: nil, bundle: nil)
        print("init: \(type(of: self))🟢")
    }

    required init?(coder: NSCoder) { nil }

    deinit { print("deinit: \(type(of: self))🔴") }
}
