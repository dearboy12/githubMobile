//
//  ViewController.swift
//  GithubMobile
//
//  Created by dearboy on 2024/04/28.
//

import UIKit

class ViewController: UIViewController {
    
    let k_USER_CELL_IDENTIFIER = "UserTableViewCellIdentifier"
    
    @IBOutlet weak var tableview: UITableView!
    var users: [User] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpView()
        Task {
            await callApi()
        }
        
    }
    
    func setUpView() {
        title = "Users"
        tableview.dataSource = self
        tableview.delegate = self
    }

    func callApi() async {
        do {
            users = try await NetworkUtil.performUserListApiCall()
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
            print(users)
        } catch let error {
            print(error)
        }
    }

}


extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: k_USER_CELL_IDENTIFIER, for: indexPath) as! UserTableViewCell
        let user = users[indexPath.row]
        cell.usernameLabel.text = user.login
        cell.userImageView?.loadImage(url: user.avatarUrl)
        return cell
        
    }
    
    
}
