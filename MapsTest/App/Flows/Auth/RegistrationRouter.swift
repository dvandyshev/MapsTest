//
//  RegistrationRouter.swift
//  MapsTest
//
//  Created by Dmitry Vandyshev on 06.04.2021.
//

import Foundation
import UIKit

final class RegistrationRouter: BaseRouter {
    func toMain() {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(MenuViewController.self)
        setAsRoot(UINavigationController(rootViewController: controller))
    }
}
