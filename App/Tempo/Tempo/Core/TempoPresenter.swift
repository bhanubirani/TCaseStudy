//
//  Copyright © 2015 Target. All rights reserved.
//

public protocol TempoPresenterType: AnyObject {
    func present<ViewState: TempoViewState>(_ viewState: ViewState)
}

public protocol TempoPresenter: TempoPresenterType {
    associatedtype ViewState
    func present(_ viewState: ViewState)
}

extension TempoPresenter {
    public func present<ViewState: TempoViewState>(_ viewState: ViewState) {
        if let viewState = viewState as? Self.ViewState {
            present(viewState)
        }
    }
}
