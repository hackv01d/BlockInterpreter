//
//  CodeBlocksCoordinator.swift
//  BlockInterpreter
//

import UIKit
import Combine

protocol CodeBlocksCoordinatorDelegate: AnyObject {
    func goToWorkspace()
}

final class CodeBlocksCoordinator: BaseCoordinator {
    
    weak var delegate: CodeBlocksCoordinatorDelegate?
    private var subscriptions = Set<AnyCancellable>()
    
    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let codeBlocksViewModel = CodeBlocksViewModel()
        let codeBlocksViewController = CodeBlocksViewController(with: codeBlocksViewModel)
        
        codeBlocksViewModel.didGoToWorkspaceScreen
            .sink(receiveValue: { [weak self] in self?.delegate?.goToWorkspace() })
            .store(in: &subscriptions)
        
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(codeBlocksViewController, animated: true)
    }
}
