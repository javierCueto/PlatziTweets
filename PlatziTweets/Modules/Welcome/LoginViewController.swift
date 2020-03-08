//
//  LoginViewController.swift
//  PlatziTweets
//
//  Created by José Javier Cueto Mejía on 08/03/20.
//  Copyright © 2020 José Javier Cueto Mejía. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import Simple_Networking
import SVProgressHUD


class LoginViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func loginButtonAction(){
        view.endEditing(true)
        performLogin()
    }
    

        override func viewDidLoad() {
            super.viewDidLoad()

            setupUI()
        }
        
        // MARK: - Private Methods
        
        private func setupUI() {
            loginButton.layer.cornerRadius = 25
        }
        
        private func performLogin() {
            guard let email = emailTextField.text, !email.isEmpty else {
                NotificationBanner(title: "Error", subtitle: "Debes especificar un correo.", style: .warning).show()
                
                return
            }
            
            guard let password = passwordTextField.text, !password.isEmpty else {
                NotificationBanner(title: "Error", subtitle: "Debes especificar una contraseña.", style: .warning).show()
                
                return
            }
            
            // Crear request
            let request = LoginRequest(email: email, password: password)
            
            // Iniciamos la carga
            SVProgressHUD.show()
            
            // Llamar a librería de red
            SN.post(endpoint: Endpoints.login,
                    model: request) { (response: SNResultWithEntity<LoginResponse, ErrorResponse>) in
                        
                        SVProgressHUD.dismiss()
                        
                        switch response {
                        case .success(let user):
                            NotificationBanner(subtitle: "Bienveido \(user.user.names)", style: .success).show()
                            
                        case .error(let error):
                            print(error.localizedDescription)
                            return
                            // todo lo malo :(
                            
                        case .errorResult(let entity):
                            return
                            // error pero no tan malo :)
                        }
                
            }
            
            // performSegue(withIdentifier: "showHome", sender: nil)
            
            // Iniciar sesión aquí!
        }
    }
