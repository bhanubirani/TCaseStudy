//
//  Copyright © 2016 Target. All rights reserved.
//

public protocol TempoCoordinator: AnyObject {
    var presenters: [TempoPresenterType] { get set }
    var dispatcher: Dispatcher { get }
    
    func present<VS: TempoViewState>(_ viewState: VS)
}

public extension TempoCoordinator {
    func present<VS: TempoViewState>(_ viewState: VS) {
        for presenter in presenters {
            presenter.present(viewState)
        }
    }
}
