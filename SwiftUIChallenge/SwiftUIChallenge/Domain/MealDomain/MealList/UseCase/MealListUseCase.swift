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
    func searchMeal(from endpoint: EndPoint, filterBy filter: String, completion: @escaping result)
}

class MealListUseCase: MealListUseCaseProtocol {
    
    private let network: NetworkServiceProtocol
    
    init(network: NetworkServiceProtocol) {
        self.network = network
    }
    
    func searchMeal(from endpoint: EndPoint,
                    filterBy filter: String,
                    completion: @escaping result) {
        self.network.fetchData(from: endpoint,
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
