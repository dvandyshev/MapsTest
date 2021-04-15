//
//  AuthViewController.swift
//  MapsTest
//
//  Created by Dmitry Vandyshev on 06.04.2021.
//

import UIKit
import RxSwift
import RxCocoa

class AuthViewController: UIViewController {

    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
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
        configureLoginBindings()
    }
    
    func configureLoginBindings() {
        Observable.combineLatest(login.rx.text, password.rx.text).map { login, password in
            return !(login ?? "").isEmpty && (password ?? "").count >= 6
        }.bind { [weak loginBtn] inputField in
            loginBtn?.isEnabled = inputField
        }
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
