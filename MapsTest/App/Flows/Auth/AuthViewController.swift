//
//  AuthViewController.swift
//  MapsTest
//
//  Created by Dmitry Vandyshev on 06.04.2021.
//

import UIKit

class AuthViewController: UIViewController {

    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var password: UITextField!
    
    lazy var userInfo: UserAuth = {
       UserAuth()       
    }()
    
    lazy var router: AuthRouter = {
        let router = AuthRouter()
        router.controller = self
        return router
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        login.autocorrectionType = .no
        password.isSecureTextEntry = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func onLogin(_ sender: Any) {
        guard let login = login.text, let password = password.text, userInfo.isUserRegistered(user: User(login: login, password: password)) else {
            return
        }
        UserDefaults.standard.set(true, forKey: "isLogin")
        router.toMain()
    }
    
    @IBAction func onRegistration(_ sender: Any) {
        router.onRegister()
    }
    
}
