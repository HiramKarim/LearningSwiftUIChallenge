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
            config.timeoutIntervalForResource = 600 // 10 minutes (in seconds)
        }
        
        let session = URLSession(configuration: config)
        
        let apiPath = endpoint.path.appending(filter)
        let request = URLRequest(url: URL(string: apiPath)!)
        
        session.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
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
}
