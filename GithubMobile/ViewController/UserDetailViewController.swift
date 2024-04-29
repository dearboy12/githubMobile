//
//  UserDetailViewController.swift
//  GithubMobile
//
//  Created by dearboy on 2024/04/29.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    let k_REPOSITTORY_CELL_IDENTIFIER = "RepositoryTableViewCellIdentifier"
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var repositoryTableView: UITableView!
    
    var user: User?
    var repositories: [Repository] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
        
    }
    
    func setUpView() {
        repositoryTableView.dataSource = self
        repositoryTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let user = user {
            title = user.login
            usernameLabel.text = user.login
            iconImageView.loadImage(url: user.avatarUrl)
            Task {
                await callApi(user: user)
            }
        }
        
    }
    
    
    func callApi(user: User) async {
        do {
            let userDetail = try await NetworkUtil.fetchUserDetail(url: user.url)
            let allReps = try await NetworkUtil.fetchRepositories(url: user.reposUrl)
            repositories = allReps.filter({ res in
                return !res.fork
            })
            
            DispatchQueue.main.async {
                self.nameLabel.text = userDetail.name ?? "-"
                self.followerLabel.text = "Follower: \(userDetail.followers)"
                self.repositoryTableView.reloadData()
            }
            
        } catch let error {
            print(error)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UserDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Not Fork Repositories \(repositories.count)"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: k_REPOSITTORY_CELL_IDENTIFIER, for: indexPath) as! RepositoryTableViewCell
        let repository = repositories[indexPath.row]
        cell.textLabel?.text = repository.name + String(repository.stargazersCount)
        return cell
    }
}


extension UserDetailViewController: UITableViewDelegate {
    
}
