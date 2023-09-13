//
//  MealListMapper.swift
//  SwiftUIChallenge
//
//  Created by Hiram Castro on 13/09/23.
//

import Foundation

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
