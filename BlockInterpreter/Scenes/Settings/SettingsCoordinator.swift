//
//  SettingsCoordinator.swift
//  BlockInterpreter
//
//  Created by Ivan Semenov on 01.05.2023.
//

import UIKit

final class SettingsCoordinator: BaseCoordinator {
    
    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let settingsViewModel = SettingsViewModel()
        let settingsViewController = SettingsViewController(with: settingsViewModel)
        
        navigationController.pushViewController(settingsViewController, animated: true)
    }
}