//
//  MealDetailViewModel.swift
//  SwiftUIChallenge
//
//  Created by Hiram Castro on 11/09/23.
//

import Foundation

class MealDetailViewModel: ObservableObject {
    
    @Published var meal: MealModel!
    
    required init(meal: MealModel) {
        self.meal = meal
    }
}
