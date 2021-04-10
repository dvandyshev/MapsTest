//
//  RegistrationViewController.swift
//  MapsTest
//
//  Created by Dmitry Vandyshev on 06.04.2021.
//

import UIKit

class RegistrationViewController: UIViewController {

    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var password: UITextField!
    
    lazy var userInfo: UserAuth = {
       UserAuth()
    }()
    
    lazy var router: RegistrationRouter = {
        let router = RegistrationRouter()
        router.controller = self
        return router
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        login.autocorrectionType = .no
        password.isSecureTextEntry = true
    }

    @IBAction func onRegister(_ sender: Any) {
        guard let login = login.text, let password = password.text else {
            return
        }
        let user = User(login: login, password: password)
        userInfo.addUser(user: user)                                  
        UserDefaults.standard.set(true, forKey: "isLogin")
        router.toMain()
    }
    
}
