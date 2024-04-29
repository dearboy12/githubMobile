//
//  ViewController.swift
//  GithubMobile
//
//  Created by dearboy on 2024/04/28.
//

import UIKit

class ViewController: UIViewController {
    
    let k_USER_CELL_IDENTIFIER = "UserTableViewCellIdentifier"
    
    let K_SEGUE_SHOW_USER_DETAIL = "ShowUserDetail"
    
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
            users = try await NetworkUtil.fetchUsers()
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
        } catch let error {
            print(error)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K_SEGUE_SHOW_USER_DETAIL, let user = sender as? User {
            if let destinationVC = segue.destination as? UserDetailViewController {
                destinationVC.user = user
            }
        }
    }

}


extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = users[indexPath.row]
        performSegue(withIdentifier: K_SEGUE_SHOW_USER_DETAIL, sender: user)
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    
    
}
