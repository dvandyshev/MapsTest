//
//  MenuRouter.swift
//  MapsTest
//
//  Created by Dmitry Vandyshev on 06.04.2021.
//

import Foundation
import UIKit

final class MenuRouter: BaseRouter {
    func toMap() {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(MapViewController.self)
        show(controller)
    }
    
    func toLaunch() {
        let controller = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(AuthViewController.self)
        setAsRoot(UINavigationController(rootViewController: controller))
    }
}
