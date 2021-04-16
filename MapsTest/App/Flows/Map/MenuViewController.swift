//
//  MenuViewController.swift
//  MapsTest
//
//  Created by Dmitry Vandyshev on 06.04.2021.
//

import UIKit

class MenuViewController: UIViewController {

    lazy var router: MenuRouter = {
        let router = MenuRouter()
        router.controller = self
        return router
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onShowMapBtnTapped(_ sender: Any) {
        router.toMap()
    }
    
    @IBAction func onLogoutBtnTapped(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isLogin")
        router.toLaunch()
    }
}
