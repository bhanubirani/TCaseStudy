//
//  ListCoordinator.swift
//  ProductViewer
//
//  Copyright © 2016 Target. All rights reserved.
//

import Foundation
import Tempo

/// Coordinator for the product list
final class ListCoordinator: TempoCoordinator {
    
    // MARK: Presenters, view controllers, view state.
    
    var presenters = [TempoPresenterType]() {
        didSet {
            present(viewState)
        }
    }
    
    private(set) var viewState: ListViewState {
        didSet {
            present(viewState)
        }
    }
    
    let dispatcher = Dispatcher()
    
    weak var viewController: ListViewController?
    
    // MARK: Init
    
    required init() {
        viewState = ListViewState(listItems: [])
        updateState()
        registerListeners()
    }
    
    // MARK: ListCoordinator
    
    private func registerListeners() {
        dispatcher.addObserver(ListItemPressed.self) { [weak self] e in
            let alert = UIAlertController(title: "Item selected!", message: "🐶", preferredStyle: .alert)
            alert.addAction( UIAlertAction(title: "OK", style: .cancel, handler: nil) )
            self?.viewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    private func updateState() {
        viewState.listItems = (1..<10).map { index in
            ListItem(title: "Puppies!!!", price: "$9.99", image: UIImage(named: "\(index)"))
        }
    }
}
