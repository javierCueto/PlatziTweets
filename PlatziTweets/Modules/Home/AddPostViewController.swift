//
//  AddPostViewController.swift
//  PlatziTweets
//
//  Created by José Javier Cueto Mejía on 10/03/20.
//  Copyright © 2020 José Javier Cueto Mejía. All rights reserved.
//

import UIKit

class AddPostViewController: UIViewController {

    
    //MARK: - IBOulets
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var addPostButton: UIButton!
    
    //MARK: - Acctions
    @IBAction func addPostAction(){
        
    }
        
    @IBAction func dismissAction(){
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    
      private func setupUI(){
           addPostButton.layer.cornerRadius = 25
       }



}
