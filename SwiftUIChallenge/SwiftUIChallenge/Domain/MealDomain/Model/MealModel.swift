//
//  MealModel.swift
//  SwiftUIChallenge
//
//  Created by Hiram Castro on 08/09/23.
//

import SwiftUI
import RealmSwift

struct MealModel:Identifiable, Hashable, Equatable {
    let id:String?
    let mealName:String?
    let category:String?
    let location:String?
    let instructions:String?
    let mealThumbURL:URL?
    let tags:String?
    let videoURL:URL?
}

class RealmMealModel: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var mealName = ""
    @Persisted var category = ""
    @Persisted var location = ""
    @Persisted var instructions = ""
    @Persisted var mealThumbURL = ""
    @Persisted var tags = ""
    @Persisted var videoURL = ""
    
    required override init() {
        super.init()
    }
    
    init(id: ObjectId,
         mealName: String = "",
         category: String = "",
         location: String = "",
         instructions: String = "",
         mealThumbURL: String = "",
         tags: String = "",
         videoURL: String = "") {
        
        super.init()
        
        self.id = id
        self.mealName = mealName
        self.category = category
        self.location = location
        self.instructions = instructions
        self.mealThumbURL = mealThumbURL
        self.tags = tags
        self.videoURL = videoURL
    }
}
