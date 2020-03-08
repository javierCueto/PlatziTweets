//
//  RegisterViewController.swift
//  PlatziTweets
//
//  Created by José Javier Cueto Mejía on 08/03/20.
//  Copyright © 2020 José Javier Cueto Mejía. All rights reserved.
//

import UIKit
import NotificationBannerSwift

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
            NotificationBanner(title: "Error", subtitle: "Ingresa un correo", style: .warning).show()
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            NotificationBanner(title: "Error", subtitle: "Ingresa una contraseña segura", style: .warning).show()
            return
        }
        
        guard let name = nameTextField.text, !name.isEmpty else {
            NotificationBanner(title: "Error", subtitle: "Ingresa nombres en el campo", style: .warning).show()
            return
        }
    }
}
