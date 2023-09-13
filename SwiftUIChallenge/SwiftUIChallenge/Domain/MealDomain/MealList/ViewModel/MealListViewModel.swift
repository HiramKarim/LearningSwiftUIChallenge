//
//  MealListViewModel.swift
//  SwiftUIChallenge
//
//  Created by Hiram Castro on 08/09/23.
//

import Foundation
import RealmSwift

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
    
    private var realm: Realm!
    
    required init(usecase: MealListUseCaseProtocol) {
        self.usecase = usecase
        
        do {
            realm = try Realm()
        } catch let error {
            mapError(error: error)
        }
    }
    
    func searchMeal(of name:String) async {
        self.usecase.searchMeal(from: API.mealByName,
                                filterBy: name) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case let .success(mealsArray):
                DispatchQueue.main.async {
                    strongSelf.meals = mealsArray
                    strongSelf.saveMealsToLocalStorage(meals: mealsArray)
                }
            case let .failure(error):
                strongSelf.mapError(error: error)
            }
        }
    }
    
    internal func mapError(error:Error) {
        switch error {
        case NetworkError.connectivity:
            DispatchQueue.main.async {
                self.readMealsFromLocalStorge()
            }
            break
        default:
            DispatchQueue.main.async {
                self.errorMessage = "There was and error, please try again."
            }
        }
    }
    
    func saveMealsToLocalStorage(meals: [MealModel]) {
        
        removeElementsFromLocalStorage()
        
        var realmModel = [RealmMealModel]()
        meals.forEach { meal in
            realmModel.append(RealmMealModel(id: ObjectId.generate(),
                                             mealName: meal.mealName ?? "",
                                             category: meal.category ?? "",
                                             location:meal.location ?? "",
                                             instructions: meal.instructions ?? "",
                                             mealThumbURL: meal.mealThumbURL?.absoluteString ?? "",
                                             tags: meal.tags ?? "",
                                             videoURL: meal.videoURL?.absoluteString ?? ""))
        }
        
        do {
            try realm.write {
                realm.add(realmModel)
            }
        } catch let error {
            mapError(error: error)
        }
    }
    
    func removeElementsFromLocalStorage() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch let error {
            mapError(error: error)
        }
    }
    
    func readMealsFromLocalStorge() {
        let data = realm.objects(RealmMealModel.self)
        var mealDataArray = [MealModel]()
        data.forEach { realmDataModel in
            mealDataArray.append(MealModel(id: realmDataModel.id.stringValue,
                                           mealName: realmDataModel.mealName,
                                           category: realmDataModel.category,
                                           location: realmDataModel.location,
                                           instructions: realmDataModel.instructions,
                                           mealThumbURL: URL(string: realmDataModel.mealThumbURL)!,
                                           tags: realmDataModel.tags,
                                           videoURL: URL(string: realmDataModel.videoURL)!
                                          ))
        }
        
        DispatchQueue.main.async {
            self.meals = mealDataArray
        }
    }
}

