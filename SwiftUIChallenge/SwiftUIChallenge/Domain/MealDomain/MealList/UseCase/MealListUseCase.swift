//
//  MealUseCase.swift
//  SwiftUIChallenge
//
//  Created by Hiram Castro on 08/09/23.
//

import Foundation

enum MealListResult {
    case success([MealModel])
    case failure(Error)
}

protocol MealListUseCaseProtocol {
    typealias result = (MealListResult) -> Void
    func searchMeal(filterBy filter: String, completion: @escaping result)
}

class MealListUseCase: MealListUseCaseProtocol {
    
    private let network: NetworkServiceProtocol
    
    init(network: NetworkServiceProtocol) {
        self.network = network
    }
    
    func searchMeal(filterBy filter: String, completion: @escaping result) {
        self.network.fetchData(from: API.mealByName,
                               filteringBy: filter) { result in
            switch result {
            case let .success(data, response):
                
                do {
                    let mealListData = try MealListMapper.mapper(data, response)
                    completion(.success(mealListData))
                } catch let error {
                    completion(.failure(error))
                }
                
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

final class MealListMapper {
    
    private struct Root: Decodable {
        let meals: [MealItemDTO]
        
        var mealElements: [MealModel] {
            return meals.map { $0.meal }
        }
    }
    
    private struct MealItemDTO:Decodable {
        let id:String?
        let mealName:String?
        let category:String?
        let location:String?
        let instructions:String?
        let mealThumbURL:URL?
        let tags:String?
        let videoURL:URL?
        
        enum CodingKeys: String, CodingKey {
            case id = "idMeal"
            case mealName = "strMeal"
            case category = "strCategory"
            case location = "strArea"
            case instructions = "strInstructions"
            case mealThumbURL = "strMealThumb"
            case tags = "strTags"
            case videoURL = "strYoutube"
        }
        
        var meal: MealModel {
            return MealModel(id: id,
                             mealName: mealName,
                             category: category,
                             location: location,
                             instructions: instructions,
                             mealThumbURL: mealThumbURL,
                             tags: tags,
                             videoURL: videoURL)
        }
    }
    
    enum JSONError: Error {
        case parsingError
        case invalidJSON
    }
    
    static func mapper(_ data: Data, _ response: HTTPURLResponse) throws -> [MealModel] {
        
        guard response.statusCode == 200,
              let meals = try? JSONDecoder().decode(Root.self, from: data)
        else {
            throw JSONError.parsingError
        }
        
        return meals.mealElements
        
    }
    
}
