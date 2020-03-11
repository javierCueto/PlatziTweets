//
//  AddPostViewController.swift
//  PlatziTweets
//
//  Created by José Javier Cueto Mejía on 10/03/20.
//  Copyright © 2020 José Javier Cueto Mejía. All rights reserved.
//

import UIKit
import Simple_Networking
import NotificationBannerSwift
import SVProgressHUD

class AddPostViewController: UIViewController {

    
    //MARK: - IBOulets
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var addPostButton: UIButton!
    
    //MARK: - Acctions
    @IBAction func addPostAction(){
        savePost()
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
    
    
    private func savePost(){
        
        let request = PostRequest(text: postTextView.text, imageUrl: nil, videoUrl: nil, location: nil)
        
        SVProgressHUD.show()
        
        SN.post(endpoint: Endpoints.post, model: request) { (response: SNResultWithEntity<Post, ErrorResponse>) in
           
            SVProgressHUD.dismiss()
            switch response {
              case .success:
                self.dismiss(animated: true, completion: nil)
              case .error(let error):
                NotificationBanner(title: "Error", subtitle: error.localizedDescription, style: .danger).show()
                  
              case .errorResult(let entity):
                  NotificationBanner(title: "Error", subtitle: entity.error, style: .warning).show()
              }
        }
    }


}
