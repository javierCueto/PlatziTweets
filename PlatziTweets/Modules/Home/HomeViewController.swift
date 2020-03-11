//
//  HomeViewController.swift
//  PlatziTweets
//
//  Created by José Javier Cueto Mejía on 09/03/20.
//  Copyright © 2020 Mejia Garcia. All rights reserved.
//

import UIKit
import Simple_Networking
import SVProgressHUD
import NotificationBannerSwift

class HomeViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - properties
    private let celId = "TweetTableViewCell"
    private var dataSource = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getPost()
    }
    

    private func setupUI(){
        tableView.dataSource = self
        tableView.register(UINib(nibName: celId, bundle: nil), forCellReuseIdentifier: celId)
    }
    
    
    private func getPost(){
        SVProgressHUD.show()
        SN.get(endpoint: Endpoints.getPosts) { (response: SNResultWithEntity<[Post] , ErrorResponse>) in
            SVProgressHUD.dismiss()
             switch response {
               case .success(let post):
                self.dataSource = post
                self.tableView.reloadData()
                   
               case .error(let error):
                   NotificationBanner(title: "Error", subtitle: error.localizedDescription, style: .danger).show()
                   
               case .errorResult(let entity):
                   NotificationBanner(title: "Error", subtitle: entity.error, style: .warning).show()
               }
        }
    }

}


//MARK: - UITableviewDataSource
extension HomeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: celId, for: indexPath)
        if let cell = cell as? TweetTableViewCell{
            cell.setupCellWith(post: dataSource[indexPath.row])
        }
        
        return cell
    }
    
    
}
