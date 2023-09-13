//
//  SwiftUIChallengeTests.swift
//  SwiftUIChallengeTests
//
//  Created by Hiram Castro on 06/09/23.
//

import XCTest
@testable import SwiftUIChallenge

final class SwiftUIChallengeTests: XCTestCase {

    func test_deliversMealListForEmptyFilter() throws {
        
    }

}

enum MockAPI {
    case validURL
    case invalidURL
}

extension MockAPI: SwiftUIChallenge.EndPoint {
    var path: String {
        switch self {
        case .validURL:
            return "http://a-valid-url.com"
        case .invalidURL:
            return "http://a-invalid-url.com"
        }
    }
    
    var request: URLRequest? {
        guard let url = URL(string: path) else { return nil }
        return URLRequest(url: url)
    }
}

class NetworkServiceMock: NetworkServiceProtocol {
    func fetchData(from endpoint: SwiftUIChallenge.EndPoint,
                   filteringBy filter: String,
                   completion: @escaping (SwiftUIChallenge.HTTPClientResult) -> Void) {
        
        if endpoint.path == "http://a-valid-url.com" {
            
        } else if endpoint.path == "http://a-invalid-url.com" {
            
        }
        
    }
}

class MealListUseCaseMock: MealListUseCaseProtocol {
    
    private let network: NetworkServiceProtocol
    
    init(network: NetworkServiceProtocol) {
        self.network = network
    }
    
    func searchMeal(from endpoint: SwiftUIChallenge.EndPoint,
                    filterBy filter: String,
                    completion: @escaping result) {
        
    }
    
    
}
