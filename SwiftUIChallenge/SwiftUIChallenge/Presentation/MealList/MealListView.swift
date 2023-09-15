//
//  ContentView.swift
//  SwiftUIChallenge
//
//  Created by Hiram Castro on 06/09/23.
//

import SwiftUI
import Kingfisher
import RealmSwift

struct MealListView: View {
    
    @ObservedObject var viewmodel = FactoryMealViewModel.makeMealListViewModel()
    @State private var selectedMeal: MealModel? = nil
    @State private var mealSearch = ""
    @State private var previousMealSearch = ""
    
    var body: some View {
        
        NavigationView {
            
            if let meals = viewmodel.meals,
                meals.isEmpty {
                Text("Meals not found")
                .foregroundColor(.secondary)
            } else {
                
                List(viewmodel.meals ?? []) { item in
                    NavigationLink(destination: MealDetailView(viewmodel: MealDetailViewModel(meal: item)), tag: item, selection: $selectedMeal) {

                        VStack(alignment: .leading) {
                            HStack {
                                KFImage(item.mealThumbURL!)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .mask(Circle())
                                Text(item.mealName ?? "")
                            }
                            .padding(.bottom, 30)

                            HStack {
                                Image(systemName: "fork.knife")
                                Text(item.category ?? "")
                                Spacer()
                                Image(systemName: "location.circle")
                                Text(item.location ?? "")
                            }
                            .padding(15)
                        }
                        .padding(10)
                    }
                }
                .navigationTitle(Text("Meals"))
                
            }
            
            
        }
        .onAppear {
            Task {
                await viewmodel.searchMeal(of: mealSearch)
            }
        }
        .alert(isPresented: $viewmodel.isAlertPresented) {
            Alert(title: Text("Error"), message: Text(viewmodel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
        }
        .searchable(text: $mealSearch)
        .onSubmit(of: .search) {
            
            if mealSearch.containsEmoji() {
                mealSearch = ""
                return
            } else if mealSearch.contains(" ") {
                mealSearch = ""
            }
            
            Task {
                await viewmodel.searchMeal(of: mealSearch)
            }
        }
        .onChange(of: previousMealSearch) { newValue in
            if newValue.isEmpty {
                Task {
                    await viewmodel.searchMeal(of: "")
                }
            } else {
                
            }
            previousMealSearch = mealSearch
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MealListView()
    }
}

class FactoryMealViewModel {
    static func makeMealListViewModel() -> MealListViewModel {
        let networkLayer = NetworkService()
        let useCase = MealListUseCase(network: networkLayer)
        let viewmodel = MealListViewModel(usecase: useCase)
        return viewmodel
    }
}

extension String {
    func containsEmoji() -> Bool {
        let emojiPattern = "[\\p{Emoji}]"
        if let regex = try? NSRegularExpression(pattern: emojiPattern, options: []) {
            let range = NSRange(location: 0, length: self.utf16.count)
            if regex.firstMatch(in: self, options: [], range: range) != nil {
                return true
            }
        }
        return false
    }
}
