//
//  SwiftUIChallengeTests.swift
//  SwiftUIChallengeTests
//
//  Created by Hiram Castro on 06/09/23.
//

import XCTest
@testable import SwiftUIChallenge

final class SwiftUIChallengeTests: XCTestCase {

    func test_deliversMealListWithEmptyFilter() throws {
        let networklayer = NetworkServiceMock()
        let sut = MealListUseCaseMock(network: networklayer)
        
        let exp = expectation(description: "wait for completion")
        
        sut.searchMeal(from: MockAPI.validURL, filterBy: "") { result in
            
            switch result {
            case let .success(mealList):
                XCTAssertNotNil(mealList)
            case let .failure(error):
                XCTAssertNil(error)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_deliversEmptyMealListWithEmptyFilter() throws {
        let networklayer = NetworkServiceMock()
        let sut = MealListUseCaseMock(network: networklayer)
        
        let exp = expectation(description: "wait for completion")
        
        sut.searchMeal(from: MockAPI.invalidURL, filterBy: "") { result in
            
            switch result {
            case let .success(mealList):
                let emptyMeal = MealModel(id: nil,
                                          mealName: nil,
                                          category: nil,
                                          location: nil,
                                          instructions: nil,
                                          mealThumbURL: nil,
                                          tags: nil,
                                          videoURL: nil)
                XCTAssertEqual(mealList.first, emptyMeal)
            case let .failure(error):
                XCTAssertNil(error)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
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
            MealListFactory.makeValidMealList(from: MockAPI.validURL, completion: completion)
        } else if endpoint.path == "http://a-invalid-url.com" {
            MealListFactory.makeInvalidMealList(from: MockAPI.invalidURL, completion: completion)
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
        self.network.fetchData(from: endpoint, filteringBy: filter) { result in
            
            switch result {
            case let .success(data, response):
                
                do {
                    let meals = try MealListMapper.mapper(data, response)
                    completion(.success(meals))
                } catch let error {
                    completion(.failure(error))
                }
                
            case let .failure(error):
                completion(.failure(error))
            }
            
        }
    }
}

class MealListFactory {
    
    static func makeValidMealList(from endpoint: SwiftUIChallenge.EndPoint,
                                  completion: @escaping (SwiftUIChallenge.HTTPClientResult) -> Void) {
        let namesJsonData: [[String:Any]] = [
            ["id": "52977",
             "strMeal":"Corba",
             "strCategory":"Side",
             "strArea":"Turkish",
             "strInstructions":"Pick through your lentils for any foreign debris",
             "strMealThumb":"https://www.themealdb.com/images/media/meals/58oia61564916529.jpg",
             "strTags":"Soup",
             "strYoutube":"https://www.youtube.com/watch?v=VVnZd8A84z4"],
            ["id": "53060",
             "strMeal":"Burek",
             "strCategory":"Side",
             "strArea":"Croatian",
             "strInstructions":"Fry the finely chopped onions and minced meat in oil.",
             "strMealThumb":"https://www.themealdb.com/images/media/meals/tkxquw1628771028.jpg",
             "strTags":"Streetfood, Onthego",
             "strYoutube":"https://www.youtube.com/watch?v=YsJXZwE5pdY"]
        ]
        let jsonObj: [String:Any] = [
            "meals":namesJsonData
        ]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj, options: .prettyPrinted) else {
              print("Something is wrong while converting dictionary to JSON data.")
            completion(.failure(NetworkError.invalidData))
            return
           }
        completion(.success(jsonData, HTTPURLResponse(url: URL(string: endpoint.path)!,
                                                      statusCode: 200,
                                                      httpVersion: nil,
                                                      headerFields: nil)!))
    }
    
    static func makeInvalidMealList(from endpoint: SwiftUIChallenge.EndPoint,
                                  completion: @escaping (SwiftUIChallenge.HTTPClientResult) -> Void) {
        
        let namesJsonData: [[String:Any]] = [["invalid":"no data"]]
        
        let jsonObj: [String:Any] = [
            "meals":namesJsonData
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj, options: .prettyPrinted)
        else {
              print("Something is wrong while converting dictionary to JSON data.")
            completion(.failure(NetworkError.invalidData))
            return
        }
        
        completion(.success(jsonData, HTTPURLResponse(url: URL(string: endpoint.path)!,
                                                      statusCode: 200,
                                                      httpVersion: nil,
                                                      headerFields: nil)!))
    }
    
}
