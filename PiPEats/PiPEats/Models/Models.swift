import Foundation

// MARK: - User Model

struct User: Codable, Identifiable, Equatable {
    let id: String
    var name: String
    var email: String
    var phone: String
    var addresses: [Address]
    var defaultAddressId: String?
    
    var defaultAddress: Address? {
        addresses.first { $0.id == defaultAddressId } ?? addresses.first
    }
    
    static let guest = User(
        id: "guest",
        name: "Guest User",
        email: "",
        phone: "",
        addresses: [],
        defaultAddressId: nil
    )
}

// MARK: - Address Model

struct Address: Codable, Identifiable, Equatable, Hashable {
    let id: String
    var label: String
    var fullAddress: String
    var landmark: String?
    var city: String
    var pincode: String
    var latitude: Double?
    var longitude: Double?
    
    var displayAddress: String {
        var parts = [fullAddress]
        if let landmark = landmark, !landmark.isEmpty {
            parts.append("Near \(landmark)")
        }
        parts.append("\(city) - \(pincode)")
        return parts.joined(separator: ", ")
    }
}

// MARK: - Restaurant Model

struct Restaurant: Codable, Identifiable, Equatable {
    let id: String
    let name: String
    let cuisines: [String]
    let rating: Double
    let reviewCount: Int
    let deliveryTimeMinutes: Int
    let deliveryFee: Decimal
    let minimumOrder: Decimal
    let imageURL: String?
    let isVeg: Bool
    let isPureVeg: Bool
    let address: String
    let categories: [MenuCategory]
    
    var cuisineText: String {
        cuisines.joined(separator: ", ")
    }
    
    var deliveryTimeText: String {
        "\(deliveryTimeMinutes) mins"
    }
    
    var ratingText: String {
        String(format: "%.1f", rating)
    }
}

// MARK: - Menu Models

struct MenuCategory: Codable, Identifiable, Equatable {
    let id: String
    let name: String
    let items: [MenuItem]
}

struct MenuItem: Codable, Identifiable, Equatable {
    let id: String
    let name: String
    let description: String
    let price: Decimal
    let imageURL: String?
    let isVeg: Bool
    let isSpicy: Bool
    let isBestseller: Bool
    let customizations: [MenuCustomization]?
    
    var formattedPrice: String {
        "₹\(price)"
    }
}

struct MenuCustomization: Codable, Identifiable, Equatable {
    let id: String
    let name: String
    let options: [CustomizationOption]
    let isRequired: Bool
    let maxSelections: Int
}

struct CustomizationOption: Codable, Identifiable, Equatable {
    let id: String
    let name: String
    let additionalPrice: Decimal
}

// MARK: - Cart Models

struct Cart: Codable, Equatable {
    var restaurantId: String?
    var restaurantName: String?
    var items: [CartLine]
    
    var isEmpty: Bool {
        items.isEmpty
    }
    
    var itemCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }
    
    var subtotal: Decimal {
        items.reduce(Decimal.zero) { $0 + $1.totalPrice }
    }
    
    static let empty = Cart(restaurantId: nil, restaurantName: nil, items: [])
    
    mutating func addItem(_ menuItem: MenuItem, quantity: Int = 1, customizations: [SelectedCustomization] = []) {
        if let existingIndex = items.firstIndex(where: { $0.menuItemId == menuItem.id && $0.customizations == customizations }) {
            items[existingIndex].quantity += quantity
        } else {
            let cartLine = CartLine(
                id: UUID().uuidString,
                menuItemId: menuItem.id,
                name: menuItem.name,
                price: menuItem.price,
                quantity: quantity,
                isVeg: menuItem.isVeg,
                customizations: customizations
            )
            items.append(cartLine)
        }
    }
    
    mutating func removeItem(at index: Int) {
        guard index < items.count else { return }
        items.remove(at: index)
        if items.isEmpty {
            restaurantId = nil
            restaurantName = nil
        }
    }
    
    mutating func updateQuantity(at index: Int, quantity: Int) {
        guard index < items.count else { return }
        if quantity <= 0 {
            removeItem(at: index)
        } else {
            items[index].quantity = quantity
        }
    }
    
    mutating func clear() {
        items.removeAll()
        restaurantId = nil
        restaurantName = nil
    }
}

struct CartLine: Codable, Identifiable, Equatable {
    let id: String
    let menuItemId: String
    let name: String
    let price: Decimal
    var quantity: Int
    let isVeg: Bool
    let customizations: [SelectedCustomization]
    
    var customizationsPrice: Decimal {
        customizations.reduce(Decimal.zero) { $0 + $1.additionalPrice }
    }
    
    var unitPrice: Decimal {
        price + customizationsPrice
    }
    
    var totalPrice: Decimal {
        unitPrice * Decimal(quantity)
    }
    
    var formattedUnitPrice: String {
        "₹\(unitPrice)"
    }
    
    var formattedTotalPrice: String {
        "₹\(totalPrice)"
    }
    
    var customizationsText: String? {
        guard !customizations.isEmpty else { return nil }
        return customizations.map { $0.optionName }.joined(separator: ", ")
    }
}

struct SelectedCustomization: Codable, Equatable {
    let customizationId: String
    let optionId: String
    let optionName: String
    let additionalPrice: Decimal
}

// MARK: - Order Models

enum OrderStatus: String, Codable, CaseIterable {
    case placed = "placed"
    case confirmed = "confirmed"
    case preparing = "preparing"
    case outForDelivery = "out_for_delivery"
    case delivered = "delivered"
    case cancelled = "cancelled"
    
    var displayName: String {
        switch self {
        case .placed: return "Order Placed"
        case .confirmed: return "Confirmed"
        case .preparing: return "Preparing"
        case .outForDelivery: return "Out for Delivery"
        case .delivered: return "Delivered"
        case .cancelled: return "Cancelled"
        }
    }
    
    var statusDescription: String {
        switch self {
        case .placed: return "We've received your order"
        case .confirmed: return "Restaurant has confirmed your order"
        case .preparing: return "Your food is being prepared"
        case .outForDelivery: return "Your order is on the way"
        case .delivered: return "Order delivered successfully"
        case .cancelled: return "Order has been cancelled"
        }
    }
    
    var icon: String {
        switch self {
        case .placed: return "checkmark.circle"
        case .confirmed: return "hand.thumbsup"
        case .preparing: return "flame"
        case .outForDelivery: return "bicycle"
        case .delivered: return "checkmark.seal.fill"
        case .cancelled: return "xmark.circle"
        }
    }
    
    var isActive: Bool {
        switch self {
        case .delivered, .cancelled: return false
        default: return true
        }
    }
    
    var progress: Double {
        switch self {
        case .placed: return 0.2
        case .confirmed: return 0.4
        case .preparing: return 0.6
        case .outForDelivery: return 0.8
        case .delivered: return 1.0
        case .cancelled: return 0.0
        }
    }
}

struct Order: Codable, Identifiable, Equatable {
    let id: String
    let orderNumber: String
    let restaurantId: String
    let restaurantName: String
    let items: [CartLine]
    let deliveryAddress: Address
    var status: OrderStatus
    let subtotal: Decimal
    let deliveryFee: Decimal
    let taxes: Decimal
    let total: Decimal
    let paymentMethod: String
    let createdAt: Date
    var updatedAt: Date
    var estimatedDeliveryTime: Date?
    var deliveryPersonName: String?
    var deliveryPersonPhone: String?
    
    var formattedSubtotal: String { "₹\(subtotal)" }
    var formattedDeliveryFee: String { deliveryFee == 0 ? "FREE" : "₹\(deliveryFee)" }
    var formattedTaxes: String { "₹\(taxes)" }
    var formattedTotal: String { "₹\(total)" }
    
    var itemsDescription: String {
        items.map { "\($0.quantity)x \($0.name)" }.joined(separator: ", ")
    }
    
    var estimatedTimeText: String? {
        guard let eta = estimatedDeliveryTime else { return nil }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: eta)
    }
}

// MARK: - Food Category

enum FoodCategory: String, CaseIterable, Identifiable {
    case all = "All"
    case biryani = "Biryani"
    case northIndian = "North Indian"
    case southIndian = "South Indian"
    case chinese = "Chinese"
    case pizza = "Pizza"
    case burgers = "Burgers"
    case desserts = "Desserts"
    case streetFood = "Street Food"
    case thali = "Thali"
    case beverages = "Beverages"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .all: return "square.grid.2x2"
        case .biryani: return "flame"
        case .northIndian: return "fork.knife"
        case .southIndian: return "leaf"
        case .chinese: return "takeoutbag.and.cup.and.straw"
        case .pizza: return "circle.grid.cross"
        case .burgers: return "circle.fill"
        case .desserts: return "birthday.cake"
        case .streetFood: return "cart"
        case .thali: return "circle.grid.3x3"
        case .beverages: return "cup.and.saucer"
        }
    }
}

// MARK: - Location

struct Location: Codable, Equatable {
    let latitude: Double
    let longitude: Double
    let city: String
    let area: String
    
    var displayText: String {
        "\(area), \(city)"
    }
}
