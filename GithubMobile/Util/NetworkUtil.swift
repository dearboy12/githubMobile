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

struct NetworkUtil {
    static func performUserListApiCall() async throws -> [User] {
        
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
}
