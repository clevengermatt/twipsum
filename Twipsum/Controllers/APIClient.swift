//
//  APIClient.swift
//  Twipsum
//
//  Created by Matthew Clevenger on 09/06/2020.
//  Copyright © 2020 Matt Clevenger. All rights reserved.
//

import Foundation

/**
APIClient makes available functions for fetching and decoding data from the API.
 */
struct APIClient {
    
    public static let shared = APIClient()
    
    private let baseURL = URL(string: "https://jsonplaceholder.typicode.com")!
    
    private let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 3
        configuration.waitsForConnectivity = true
        let session = URLSession(configuration: configuration)
        return session
    }()
    
    /**
    Available API endpoints.
     */
    private enum APIEndpoint: String {
        case comments
        case posts
    }
    
    /**
    Error types for API request failures.
     
     The raw value of the type is a String. This String should be considered an acceptable error message to be seen by the user.
     */
    enum APIError: String, Error {
        case badRequest
        case decoding
        case internalServerError
        case noData
        case notFound
        case timedOut
        case unknown
    }
    
    /**
    Fetches comments data from the API for a post with a given identifier.

     - Parameters:
        - postId: The identifier of the post for which comments should be fetched.
        - completion: A completion handler which passes an instance of Result.
     
     The instance of Result passed from completion handler will, on success, contain the comments data parsed from the request. On failure, it will contain an instance of APIError.
     */
    func fetchComments(forPostWithId postId: Int, completion: @escaping (Result<[Comment], APIError>) -> Void) {
        
        let url = baseURL
            .appendingPathComponent(APIEndpoint.posts.rawValue)
            .appendingPathComponent(String(postId))
            .appendingPathComponent(APIEndpoint.comments.rawValue)
        
        fetchFrom(url: url, withNumberOfRetries: 1) { (result) in
            completion(result)
        }
    }
    
    /**
    Fetches posts data from the API.

     - Parameters:
        - completion: A completion handler which passes an instance of Result.
     
     The instance of Result passed from completion handler will, on success, contain the posts data parsed from the request. On failure, it will contain an instance of APIError.
     */
    func fetchPosts(completion: @escaping (Result<[Post], APIError>) -> Void) {
        
        let url = baseURL
            .appendingPathComponent(APIEndpoint.posts.rawValue)
        
        fetchFrom(url: url, withNumberOfRetries: 3) { (result) in
            completion(result)
        }
    }
    
    /**
    Fetches data from a given url.

     - Parameters:
        - url: An instance of URL, from which data will be fetched.
        - numberOfRetries: The number of times to retry to request, should a failure be the result of a timeOut or of unknown origin. The default value is 0.
        - completion: A completion handler which passes an instance of Result.
     
     The instance of Result passed from completion handler will, on success, contain the data parsed from the request. On failure, it will contain an instance of APIError.
     */
    private func fetchFrom<T: Decodable>(url: URL, withNumberOfRetries numberOfRetries: Int = 0, completion: @escaping (Result<T, APIError>) -> Void) {
        
        session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                
                if let response = response as? HTTPURLResponse {
                    
                    guard (200...299).contains(response.statusCode) else {

                        switch response.statusCode {
                        case 400:
                            completion(.failure(.badRequest))
                        case 404:
                            completion(.failure(.notFound))
                        case 500:
                            completion(.failure(.internalServerError))
                        default:
                            
                            if numberOfRetries > 0 {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    self.fetchFrom(url: url, withNumberOfRetries: numberOfRetries - 1 , completion: completion)
                                }
                                
                                return
                            }
                            
                            completion(.failure(.unknown))
                        }
                            
                        return
                    }
                }
                
                if let error = error {
                    
                    if numberOfRetries > 0 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.fetchFrom(url: url, withNumberOfRetries: numberOfRetries - 1 , completion: completion)
                        }
                        
                        return
                    }
                    
                    if error._code == NSURLErrorTimedOut {
                        completion(.failure(.timedOut))
                        return
                    }
                    
                    completion(.failure(.unknown))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.noData))
                    return
                }
                
                do {
                    let parsedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(parsedData))
                    return
                } catch {
                    completion(.failure(.decoding))
                    return
                }
            }
        }.resume()
    }
}
