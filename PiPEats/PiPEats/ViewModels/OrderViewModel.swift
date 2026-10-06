import Foundation
import Observation

@Observable
final class OrderViewModel {
    var isLoading: Bool = false
    var selectedOrder: Order?
    
    func refreshOrders(appState: AppState) {
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.isLoading = false
        }
    }
    
    func getActiveOrders(from orders: [Order]) -> [Order] {
        orders.filter { $0.status.isActive }
    }
    
    func getPastOrders(from orders: [Order]) -> [Order] {
        orders.filter { !$0.status.isActive }
    }
    
    func cancelOrder(orderId: String, appState: AppState) {
        appState.cancelOrder(orderId)
    }
    
    func reorderItems(from order: Order, appState: AppState) {
        guard let restaurant = MockDataService.shared.getRestaurant(by: order.restaurantId) else { return }
        
        appState.clearCart()
        
        for item in order.items {
            if let menuItem = restaurant.categories.flatMap({ $0.items }).first(where: { $0.id == item.menuItemId }) {
                appState.addToCart(item: menuItem, from: restaurant, quantity: item.quantity, customizations: item.customizations)
            }
        }
    }
}
