//
//  NetworkService.swift
//  SwiftUIChallenge
//
//  Created by Hiram Castro on 07/09/23.
//

import Foundation

final class NetworkService: NetworkServiceProtocol {
    func fetchData(from endpoint: EndPoint,
                   filteringBy filter:String = "",
                   completion: @escaping (HTTPClientResult) -> Void) {
        
        let config = URLSessionConfiguration.default
        
        if #available(iOS 11, *) {
            config.waitsForConnectivity = true
            config.timeoutIntervalForResource = 5 // waits 5 secs to reconnect
        }
        
        let session = URLSession(configuration: config)
        
        let apiPath = endpoint.path.appending(filter)
        let request = URLRequest(url: URL(string: apiPath)!)
        
        var retryAttempts:Int = 0
        let retryCount:Int = 3
        
        func performRequest() {
            session.dataTask(with: request) { data, response, error in
                
                if error != nil {
                    
                    if retryAttempts < retryCount {
                        retryAttempts += 1
                        // perform retry
                        DispatchQueue.global().asyncAfter(deadline: .now()) {
                            performRequest()
                        }
                    } else {
                        completion(.failure(NetworkError.connectivity))
                    }
                    
                    return
                }
                
                guard let data = data
                else {
                    completion(.failure(NetworkError.invalidData))
                    return
                }
                
                guard let response = response as? HTTPURLResponse
                else {
                    completion(.failure(NetworkError.internalServerError))
                    return
                }
                
                completion(.success(data, response))
                
            }.resume()
        }
        
        performRequest()
        
    }
}
