//
//  UserDetailViewController.swift
//  GithubMobile
//
//  Created by dearboy on 2024/04/29.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    let k_REPOSITTORY_CELL_IDENTIFIER = "RepositoryTableViewCellIdentifier"
    
    let K_SEGUE_SHOW_REPOSITORY_DETAIL = "ShowRepositoryDetail"
    
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
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reload))
        navigationItem.rightBarButtonItem = refresh
    }
    
    @objc func reload() {
        if let user = user {
            iconImageView.loadImage(url: user.avatarUrl)
            Task {
                await callApi(user: user)
            }
        }
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
            print(repositories)
            
            DispatchQueue.main.async {
                self.nameLabel.text = userDetail.name ?? "-"
                self.followerLabel.text = "Follower: \(userDetail.followers)"
                self.repositoryTableView.reloadData()
            }
            
        } catch let error {
            print(error)
        }
    }
    

  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K_SEGUE_SHOW_REPOSITORY_DETAIL {
            if let destonationVC = segue.destination as? RepositoryDetailViewController, let repository = sender as? Repository {
                destonationVC.repository = repository
            }
        }
    }


}

extension UserDetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let repository = repositories[indexPath.row]
        performSegue(withIdentifier: K_SEGUE_SHOW_REPOSITORY_DETAIL, sender: repository)
    }
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
        cell.nameLabel.text = repository.name
        cell.startCountLabel.text = "★ " + String(repository.stargazersCount)
        cell.languageLabel.text = "Language: \(repository.language ?? "-")"
        cell.descriptionLabel.text = repository.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

