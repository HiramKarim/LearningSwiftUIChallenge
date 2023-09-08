//
//  MealListViewModel.swift
//  SwiftUIChallenge
//
//  Created by Hiram Castro on 08/09/23.
//

import Foundation

protocol MealListViewModelProtocol {
    var meals:[MealModel]? { get set }
    var usecase:MealListUseCaseProtocol { get set }
    func fetchMealList() async
    init(usecase:MealListUseCaseProtocol)
    func mapError(error:Error)
}

class MealListViewModel: ObservableObject, MealListViewModelProtocol {
    var usecase: MealListUseCaseProtocol
    
    @Published var meals:[MealModel]?
    
    required init(usecase: MealListUseCaseProtocol) {
        self.usecase = usecase
    }
    
    func fetchMealList() async {
        self.usecase.fetchMealList { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success(mealsArray):
                self?.meals = mealsArray
            case let .failure(error):
                self?.mapError(error: error)
            }
        }
    }
    
    internal func mapError(error:Error) {
        switch error {
        case NetworkError.connectivity: break
        case NetworkError.timeout: break
        case NetworkError.invalidData: break
        case MealListMapper.JSONError.invalidJSON: break
        default:
            break
        }
    }
}
