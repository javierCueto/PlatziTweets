//
//  RegisterViewController.swift
//  PlatziTweets
//
//  Created by José Javier Cueto Mejía on 08/03/20.
//  Copyright © 2020 José Javier Cueto Mejía. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import Simple_Networking
import SVProgressHUD

class RegisterViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBAction func registerButtonAction(){
        //end the keyboard and focus
        view.endEditing(true)
        performRegister()
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI(){
        registerButton.layer.cornerRadius = 25
    }
    
    private func performRegister(){
        guard let email = emailTextField.text, !email.isEmpty else {
                   NotificationBanner(title: "Error", subtitle: "Debes especificar un correo.", style: .warning).show()
                   
                   return
               }
               
               guard let password = passwordTextField.text, !password.isEmpty else {
                   NotificationBanner(title: "Error", subtitle: "Debes especificar una contraseña.", style: .warning).show()
                   
                   return
               }
               
               guard let names = nameTextField.text, !names.isEmpty else {
                   NotificationBanner(title: "Error", subtitle: "Debes especificar tu nombre y apellido.", style: .warning).show()
                   
                   return
               }
               
               let request = RegisterRequest(email: email, password: password, names: names)
               
               SVProgressHUD.show()
               
               
               SN.post(endpoint: Endpoints.register,
                       model: request) { (response: SNResultWithEntity<LoginResponse, ErrorResponse>) in
                           
                           SVProgressHUD.dismiss()
                           
                           switch response {
                           case .success(let user):
                               self.performSegue(withIdentifier: "showHome", sender: nil)
                               SimpleNetworking.setAuthenticationHeader(prefix: "", token: user.token)
                               
                           case .error(let error):
                               NotificationBanner(title: "Error", subtitle: error.localizedDescription, style: .danger).show()
                               
                           case .errorResult(let entity):
                               NotificationBanner(title: "Error", subtitle: entity.error, style: .warning).show()
                           }
                   
               }
    }
}
