//
//  NetworkServiceProtocol.swift
//  SwiftUIChallenge
//
//  Created by Hiram Castro on 07/09/23.
//

import Foundation

public protocol EndPoint {
    var path: String { get }
    var request: URLRequest? { get }
}

enum API {
    case meals
}

extension API: EndPoint {
    var path: String {
        switch self {
        case .meals:
            return "www.themealdb.com/api/json/v1/1/search.php?f=a"
        }
    }
    
    var request: URLRequest? {
        guard let url = URL(string: path) else { return nil }
        return URLRequest(url: url)
    }
}

enum NetworkError: Error {
    case connectivity
    case invalidData
    case internalServerError
    case serviceNotFound
    case genericNetworkError
    case timeout
}

extension NetworkError {
    var localizedDescription: String {
        switch self {
        case .connectivity: return "Connectivity error"
        case .invalidData: return "Invalid data error"
        case .internalServerError: return "Internal service error"
        case .serviceNotFound: return "Service not found"
        case .genericNetworkError: return "Generic Network Error"
        case .timeout: return "Timeout"
        }
    }
}

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

protocol NetworkServiceProtocol {
    func fetchData(from endpoint: EndPoint, completion: @escaping(HTTPClientResult) -> Void)
}
