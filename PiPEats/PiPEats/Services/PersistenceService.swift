import Foundation

final class PersistenceService {
    static let shared = PersistenceService()
    
    private let defaults = UserDefaults.standard
    
    private enum Keys {
        static let user = "pip_eats_user"
        static let cart = "pip_eats_cart"
        static let orders = "pip_eats_orders"
        static let hasCompletedOnboarding = "pip_eats_onboarding_complete"
        static let selectedLocation = "pip_eats_selected_location"
    }
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private init() {}
    
    // MARK: - Onboarding State
    
    var hasCompletedOnboarding: Bool {
        get { defaults.bool(forKey: Keys.hasCompletedOnboarding) }
        set { defaults.set(newValue, forKey: Keys.hasCompletedOnboarding) }
    }
    
    // MARK: - Location
    
    func saveSelectedLocation(_ location: Location) {
        if let encoded = try? encoder.encode(location) {
            defaults.set(encoded, forKey: Keys.selectedLocation)
        }
    }
    
    func getSelectedLocation() -> Location? {
        guard let data = defaults.data(forKey: Keys.selectedLocation),
              let location = try? decoder.decode(Location.self, from: data) else {
            return nil
        }
        return location
    }
    
    // MARK: - User
    
    func saveUser(_ user: User) {
        if let encoded = try? encoder.encode(user) {
            defaults.set(encoded, forKey: Keys.user)
        }
    }
    
    func getUser() -> User? {
        guard let data = defaults.data(forKey: Keys.user),
              let user = try? decoder.decode(User.self, from: data) else {
            return nil
        }
        return user
    }
    
    func clearUser() {
        defaults.removeObject(forKey: Keys.user)
    }
    
    // MARK: - Cart
    
    func saveCart(_ cart: Cart) {
        if let encoded = try? encoder.encode(cart) {
            defaults.set(encoded, forKey: Keys.cart)
        }
    }
    
    func getCart() -> Cart {
        guard let data = defaults.data(forKey: Keys.cart),
              let cart = try? decoder.decode(Cart.self, from: data) else {
            return .empty
        }
        return cart
    }
    
    func clearCart() {
        defaults.removeObject(forKey: Keys.cart)
    }
    
    // MARK: - Orders
    
    func saveOrders(_ orders: [Order]) {
        if let encoded = try? encoder.encode(orders) {
            defaults.set(encoded, forKey: Keys.orders)
        }
    }
    
    func getOrders() -> [Order] {
        guard let data = defaults.data(forKey: Keys.orders),
              let orders = try? decoder.decode([Order].self, from: data) else {
            return []
        }
        return orders
    }
    
    func addOrder(_ order: Order) {
        var orders = getOrders()
        orders.insert(order, at: 0)
        saveOrders(orders)
    }
    
    func updateOrder(_ order: Order) {
        var orders = getOrders()
        if let index = orders.firstIndex(where: { $0.id == order.id }) {
            orders[index] = order
            saveOrders(orders)
        }
    }
    
    // MARK: - Reset All Data
    
    func resetAllData() {
        defaults.removeObject(forKey: Keys.user)
        defaults.removeObject(forKey: Keys.cart)
        defaults.removeObject(forKey: Keys.orders)
        defaults.removeObject(forKey: Keys.hasCompletedOnboarding)
        defaults.removeObject(forKey: Keys.selectedLocation)
    }
}
