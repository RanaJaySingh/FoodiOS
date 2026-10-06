import Foundation
import Observation

@Observable
final class HomeViewModel {
    var restaurants: [Restaurant] = []
    var filteredRestaurants: [Restaurant] = []
    var selectedCategory: FoodCategory = .all
    var searchQuery: String = ""
    var isLoading: Bool = false
    
    private let mockDataService = MockDataService.shared
    
    init() {
        loadRestaurants()
    }
    
    func loadRestaurants() {
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.restaurants = self.mockDataService.restaurants
            self.filterRestaurants()
            self.isLoading = false
        }
    }
    
    func filterRestaurants() {
        filteredRestaurants = mockDataService.filterRestaurants(
            by: selectedCategory,
            searchQuery: searchQuery
        )
    }
    
    func selectCategory(_ category: FoodCategory) {
        selectedCategory = category
        filterRestaurants()
    }
    
    func search(_ query: String) {
        searchQuery = query
        filterRestaurants()
    }
    
    func clearSearch() {
        searchQuery = ""
        filterRestaurants()
    }
    
    func getRestaurant(by id: String) -> Restaurant? {
        restaurants.first { $0.id == id }
    }
}
