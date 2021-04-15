//
//  RegistrationViewController.swift
//  MapsTest
//
//  Created by Dmitry Vandyshev on 06.04.2021.
//

import UIKit
import RxSwift
import RxCocoa

class RegistrationViewController: UIViewController {

    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var registrationBtn: UIButton!
    
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
        configureRegistrationBindings()
    }
    
    func configureRegistrationBindings() {
        Observable.combineLatest(login.rx.text, password.rx.text).map { login, password in
            return !(login ?? "").isEmpty && (password ?? "").count >= 6
        }.bind { [weak registrationBtn] inputField in
            registrationBtn?.isEnabled = inputField
        }
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
