//
//  MealModel.swift
//  SwiftUIChallenge
//
//  Created by Hiram Castro on 08/09/23.
//

import Foundation

struct MealModel:Identifiable, Hashable {
    let id:String?
    let mealName:String?
    let category:String?
    let location:String?
    let instructions:String?
    let mealThumbURL:URL?
    let tags:String?
    let videoURL:URL?
}
