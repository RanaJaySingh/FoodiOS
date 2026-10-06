import SwiftUI
import Observation

@Observable
final class AppState {
    // MARK: - Navigation State
    
    var hasCompletedOnboarding: Bool {
        didSet {
            PersistenceService.shared.hasCompletedOnboarding = hasCompletedOnboarding
        }
    }
    
    var isLoggedIn: Bool = false
    var showSplash: Bool = true
    
    // MARK: - User State
    
    var currentUser: User?
    var selectedLocation: Location?
    
    // MARK: - Cart State
    
    var cart: Cart {
        didSet {
            PersistenceService.shared.saveCart(cart)
        }
    }
    
    // MARK: - Orders State
    
    var orders: [Order] {
        didSet {
            PersistenceService.shared.saveOrders(orders)
        }
    }
    
    // MARK: - Active Order (for tracking)
    
    var activeOrder: Order? {
        orders.first { $0.status.isActive }
    }
    
    // MARK: - Initialization
    
    init() {
        self.hasCompletedOnboarding = PersistenceService.shared.hasCompletedOnboarding
        self.cart = PersistenceService.shared.getCart()
        self.orders = PersistenceService.shared.getOrders()
        self.selectedLocation = PersistenceService.shared.getSelectedLocation()
        self.currentUser = PersistenceService.shared.getUser()
        
        if currentUser != nil {
            isLoggedIn = true
        }
        
        if orders.isEmpty {
            orders = MockDataService.shared.createMockOrderHistory()
        }
    }
    
    // MARK: - Location Methods
    
    func setLocation(_ location: Location) {
        selectedLocation = location
        PersistenceService.shared.saveSelectedLocation(location)
    }
    
    // MARK: - User Methods
    
    func login(with user: User) {
        currentUser = user
        isLoggedIn = true
        PersistenceService.shared.saveUser(user)
    }
    
    func loginAsGuest() {
        let guestUser = MockDataService.shared.mockUser
        login(with: guestUser)
    }
    
    func updateUser(_ user: User) {
        currentUser = user
        PersistenceService.shared.saveUser(user)
    }
    
    func logout() {
        currentUser = nil
        isLoggedIn = false
        cart = .empty
        hasCompletedOnboarding = false
        PersistenceService.shared.clearUser()
        PersistenceService.shared.clearCart()
    }
    
    // MARK: - Cart Methods
    
    func addToCart(item: MenuItem, from restaurant: Restaurant, quantity: Int = 1, customizations: [SelectedCustomization] = []) {
        if cart.restaurantId != nil && cart.restaurantId != restaurant.id {
            cart = .empty
        }
        
        if cart.restaurantId == nil {
            cart.restaurantId = restaurant.id
            cart.restaurantName = restaurant.name
        }
        
        cart.addItem(item, quantity: quantity, customizations: customizations)
    }
    
    func removeFromCart(at index: Int) {
        cart.removeItem(at: index)
    }
    
    func updateCartItemQuantity(at index: Int, quantity: Int) {
        cart.updateQuantity(at: index, quantity: quantity)
    }
    
    func clearCart() {
        cart.clear()
    }
    
    // MARK: - Order Methods
    
    func placeOrder(deliveryAddress: Address, paymentMethod: String) -> Order {
        let restaurantId = cart.restaurantId ?? ""
        let restaurant = MockDataService.shared.getRestaurant(by: restaurantId)
        
        let subtotal = cart.subtotal
        let deliveryFee = restaurant?.deliveryFee ?? 30
        let taxes = subtotal * Decimal(0.05)
        let total = subtotal + deliveryFee + taxes
        
        let order = Order(
            id: UUID().uuidString,
            orderNumber: "PIP\(Date().formatted(.dateTime.year().month().day().hour().minute()))",
            restaurantId: restaurantId,
            restaurantName: cart.restaurantName ?? "Restaurant",
            items: cart.items,
            deliveryAddress: deliveryAddress,
            status: .placed,
            subtotal: subtotal,
            deliveryFee: deliveryFee,
            taxes: taxes,
            total: total,
            paymentMethod: paymentMethod,
            createdAt: Date(),
            updatedAt: Date(),
            estimatedDeliveryTime: Calendar.current.date(byAdding: .minute, value: 35, to: Date()),
            deliveryPersonName: nil,
            deliveryPersonPhone: nil
        )
        
        orders.insert(order, at: 0)
        cart.clear()
        
        simulateOrderProgress(orderId: order.id)
        
        return order
    }
    
    private func simulateOrderProgress(orderId: String) {
        let progressSteps: [(OrderStatus, TimeInterval)] = [
            (.confirmed, 5),
            (.preparing, 10),
            (.outForDelivery, 20),
            (.delivered, 30)
        ]
        
        for (status, delay) in progressSteps {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                guard let self = self,
                      let index = self.orders.firstIndex(where: { $0.id == orderId }),
                      self.orders[index].status != .cancelled else { return }
                
                self.orders[index].status = status
                self.orders[index].updatedAt = Date()
                
                if status == .outForDelivery {
                    self.orders[index].deliveryPersonName = "Amit Singh"
                    self.orders[index].deliveryPersonPhone = "+91 98765 67890"
                }
            }
        }
    }
    
    func cancelOrder(_ orderId: String) {
        if let index = orders.firstIndex(where: { $0.id == orderId }) {
            orders[index].status = .cancelled
            orders[index].updatedAt = Date()
        }
    }
    
    func getOrder(by id: String) -> Order? {
        orders.first { $0.id == id }
    }
}
