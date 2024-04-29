//
//  RepositoryDetailViewController.swift
//  GithubMobile
//
//  Created by dearboy on 2024/04/29.
//

import UIKit
import WebKit

class RepositoryDetailViewController: UIViewController {
    @IBOutlet weak var webview: WKWebView!
    
    var repository: Repository?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let action = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(openUrl))
        navigationItem.rightBarButtonItem = action
    }
    
    @objc func openUrl() {
        if let repository = repository, let url = URL(string: repository.htmlUrl) {
            UIApplication.shared.open(url)
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let repository = repository {
            title = repository.name
            
            if let url = URL(string: repository.htmlUrl) {
                let request = URLRequest(url: url)
                webview.load(request)
            }
        }
    }

}
