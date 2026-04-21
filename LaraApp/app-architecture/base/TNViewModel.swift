import Foundation
import Combine

class TNViewModel: NSObject, ObservableObject {
    struct ViewLifeCycle {
        let didLoadSubject = PassthroughSubject<Void, Never>()
        let willAppearSubject = PassthroughSubject<Void, Never>()
        let didAppearSubject = PassthroughSubject<Void, Never>()
        let didDisappearSubject = PassthroughSubject<Void, Never>()
    }

    var cancellables = Set<AnyCancellable>()
    let lifeCycle = ViewLifeCycle()
    let stepper = PassthroughSubject<TNStep, Never>()

    override init() {
        super.init()
        print("init: \(type(of: self))🟢")
    }

    deinit {
        print("deinit: \(type(of: self))🔴")
    }

    func bindStepper(to stepper: PassthroughSubject<TNStep, Never>) {
        self.stepper.subscribe(stepper).store(in: &cancellables)
    }

    func onBackTapped() {
        stepper.send(.popRequired)
    }
}
