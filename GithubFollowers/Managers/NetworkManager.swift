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

    // Get User Info
    func getUserInfo(for username: String, completed: @escaping ( Result<User,GFError> )->Void) {
        let endpoint = baseURL + "/users/\(username)"

        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUsername))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in

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
                decoder.keyDecodingStrategy  = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                let userInfo = try decoder.decode(User.self, from: data)
                completed(.success(userInfo))
            } catch {
                completed(.failure(.unableToComplete))
            }
        }

        task.resume()
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

    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void ) {

        let cacheKey = NSString(string: urlString)

        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }

        guard let url = URL(string: urlString) else { 
            completed(nil)
            return }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data)
            else {
                completed(nil)
                return
            }
            // we save image to cache
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }

        task.resume()
    }
}
