//
//  MealListViewModel.swift
//  SwiftUIChallenge
//
//  Created by Hiram Castro on 08/09/23.
//

import Foundation

protocol MealListViewModelProtocol {
    var meals: [MealModel]? { get set }
    var errorMessage: String? { get set }
    var usecase: MealListUseCaseProtocol { get set }
    func searchMeal(of name:String) async
    init(usecase: MealListUseCaseProtocol)
    func mapError(error: Error)
}

class MealListViewModel: ObservableObject, MealListViewModelProtocol {
    var usecase: MealListUseCaseProtocol
    
    @Published var meals: [MealModel]?
    @Published var errorMessage: String?
    
    required init(usecase: MealListUseCaseProtocol) {
        self.usecase = usecase
    }
    
    func searchMeal(of name:String) async {
        self.usecase.searchMeal(filterBy: name) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case let .success(mealsArray):
                DispatchQueue.main.async {
                    strongSelf.meals = mealsArray
                }
            case let .failure(error):
                strongSelf.mapError(error: error)
            }
        }
    }
    
    internal func mapError(error:Error) {
        switch error {
        case NetworkError.connectivity:
            self.errorMessage = "Connectivity error"
        case NetworkError.invalidData:
            self.errorMessage = "Invalid data"
        case MealListMapper.JSONError.invalidJSON:
            self.errorMessage = "Invalid data to parse"
        default:
            self.errorMessage = "There was and error, please try again."
        }
    }
}
