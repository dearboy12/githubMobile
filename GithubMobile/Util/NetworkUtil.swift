//
//  NetworkUtil.swift
//  GithubMobile
//
//  Created by dearboy on 2024/04/29.
//

import Foundation

let K_TOKEN = <#Token#>

enum NetworkError: Error {
    case invalidUrl
}


struct User: Codable {
    let login: String
    let id: Int
    let nodeId: String
    let avatarUrl: String
    let gravatarId: String
    let url: String
    let htmlUrl: String
    let followersUrl: String
    let followingUrl:String
    let gistsUrl: String
    let starredUrl: String
    let subscriptionsUrl: String
    let organizationsUrl: String
    let reposUrl: String
    let eventsUrl: String
    let receivedEventsUrl: String
    let type: String
}

struct UserDetail: Codable {
    let name: String?
    let followers: Int
}


struct Repository: Codable {
    let name: String
    let language: String?
    let stargazersCount: Int
    let description: String?
    let htmlUrl: String
    let fork: Bool
}


struct NetworkUtil {
    static func fetchUsers() async throws -> [User] {
        
        let url = URL(string: "https://api.github.com/users")
        
        guard url != nil else { throw NetworkError.invalidUrl }
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(K_TOKEN)", forHTTPHeaderField: "Authorization")
        request.setValue("2022-11-28", forHTTPHeaderField: "X-GitHub-Api-Version")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode([User].self, from: data)
    }
    
    
    static func fetchUserDetail(url urlString: String) async throws -> UserDetail {
        
        let url = URL(string: urlString)
        
        guard url != nil else { throw NetworkError.invalidUrl }
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(K_TOKEN)", forHTTPHeaderField: "Authorization")
        request.setValue("2022-11-28", forHTTPHeaderField: "X-GitHub-Api-Version")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(UserDetail.self, from: data)
    }
    
    
    static func fetchRepositories(url urlString: String) async throws -> [Repository] {
        
        let url = URL(string: urlString)
        
        guard url != nil else { throw NetworkError.invalidUrl }
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(K_TOKEN)", forHTTPHeaderField: "Authorization")
        request.setValue("2022-11-28", forHTTPHeaderField: "X-GitHub-Api-Version")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode([Repository].self, from: data)
    }
}
