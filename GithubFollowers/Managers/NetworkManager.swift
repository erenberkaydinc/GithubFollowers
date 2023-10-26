//
//  NetworkManager.swift
//  GithubFollowers
//
//  Created by Eren Berkay Dinç on 25.10.2023.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    let baseURL = "https://api.github.com"
    let cache   = NSCache<NSString, UIImage>()

    private init() {}

    func getFollowers(for username: String, page: Int, completed: @escaping (Result<[Follower], GFError>) -> Void) {
        let endpoint = baseURL + "/users/\(username)/followers?per_page=100&page=\(page)"

        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUsername))
            return
        }

        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }

            // Parsing
            do {
                let decoder = JSONDecoder()
                //convert from SnakeCase ( camelCase -> snake-case )
                // base_uri Converts to: baseUri
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                let followers = try decoder.decode([Follower].self, from: data)
                completed(.success(followers))
            } catch {
                completed(.failure(.invalidData))
            }
        }

        task.resume() // Starts network call
    }


// Old style
//    func getFollowers(for username: String, page: Int, completed: @escaping ([Follower]?, ErrorMessage?) -> Void) {
//        let endpoint = baseURL + "/users/\(username)/followers?per_page=100&page=\(page)"
//
//        guard let url = URL(string: endpoint) else {
//            completed(nil,.invalidUsername)
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
//            if let _ = error {
//                completed(nil, .unableToComplete)
//            }
//            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                completed(nil,.invalidResponse)
//                return
//            }
//
//            guard let data = data else {
//                completed(nil,.invalidData)
//                return
//            }
//            
//            // Parsing
//            do {
//                let decoder = JSONDecoder()
//                //convert from SnakeCase ( camelCase -> snake-case )
//                // base_uri Converts to: baseUri
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//
//                let followers = try decoder.decode([Follower].self, from: data)
//                completed(followers, nil)
//            } catch {
//                completed(nil,.invalidData)
//            }
//        }
//
//        task.resume() // Starts network call
//    }
}
