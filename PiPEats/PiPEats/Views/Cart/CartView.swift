import SwiftUI

struct CartView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var showCheckout = false
    
    private var restaurant: Restaurant? {
        guard let id = appState.cart.restaurantId else { return nil }
        return MockDataService.shared.getRestaurant(by: id)
    }
    
    var body: some View {
        Group {
            if appState.cart.isEmpty {
                emptyCartView
            } else {
                cartContentView
            }
        }
        .navigationTitle("Cart")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.pipLightGray)
        .navigationDestination(isPresented: $showCheckout) {
            CheckoutView()
        }
    }
    
    private var emptyCartView: some View {
        EmptyStateView(
            icon: "cart",
            title: "Your cart is empty",
            message: "Add items from a restaurant to get started",
            buttonTitle: "Browse Restaurants"
        ) {
            dismiss()
        }
    }
    
    private var cartContentView: some View {
        ScrollView {
            VStack(spacing: 16) {
                restaurantInfo
                cartItems
                billDetails
                deliveryTip
            }
            .padding()
            .padding(.bottom, 100)
        }
        .overlay(alignment: .bottom) {
            checkoutButton
        }
    }
    
    private var restaurantInfo: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.pipOrange.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: "fork.knife")
                    .foregroundColor(.pipOrange)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(appState.cart.restaurantName ?? "Restaurant")
                    .font(.headline)
                
                if let restaurant = restaurant {
                    Text("\(restaurant.deliveryTimeMinutes) mins delivery")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            NavigationLink {
                if let restaurant = restaurant {
                    RestaurantDetailView(restaurant: restaurant)
                }
            } label: {
                Text("Add more")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.pipOrange)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
    
    private var cartItems: some View {
        VStack(spacing: 12) {
            ForEach(Array(appState.cart.items.enumerated()), id: \.element.id) { index, item in
                CartItemRow(
                    item: item,
                    onIncrement: {
                        appState.updateCartItemQuantity(at: index, quantity: item.quantity + 1)
                    },
                    onDecrement: {
                        appState.updateCartItemQuantity(at: index, quantity: item.quantity - 1)
                    },
                    onRemove: {
                        withAnimation {
                            appState.removeFromCart(at: index)
                        }
                    }
                )
            }
        }
    }
    
    private var billDetails: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Bill Details")
                .font(.headline)
            
            VStack(spacing: 8) {
                BillRow(label: "Item Total", value: appState.cart.subtotal.formattedCurrency)
                
                if let restaurant = restaurant {
                    BillRow(
                        label: "Delivery Fee",
                        value: restaurant.deliveryFee == 0 ? "FREE" : "₹\(restaurant.deliveryFee)",
                        valueColor: restaurant.deliveryFee == 0 ? .pipGreen : nil
                    )
                }
                
                let taxes = appState.cart.subtotal * Decimal(0.05)
                BillRow(label: "Taxes & Charges", value: taxes.formattedCurrency)
                
                Divider()
                
                let deliveryFee = restaurant?.deliveryFee ?? 30
                let total = appState.cart.subtotal + deliveryFee + taxes
                BillRow(label: "To Pay", value: total.formattedCurrency, isBold: true)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
    
    private var deliveryTip: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(.pink)
                Text("Tip your delivery partner")
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            
            Text("Your tip goes directly to them and shows appreciation for their service")
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack(spacing: 12) {
                ForEach([20, 30, 50], id: \.self) { amount in
                    Button {
                        // Tip handling
                    } label: {
                        Text("₹\(amount)")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.pipOrange)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.pipOrange, lineWidth: 1)
                            )
                    }
                }
                
                Button {
                    // Custom tip
                } label: {
                    Text("Other")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
    
    private var checkoutButton: some View {
        Button {
            showCheckout = true
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    let deliveryFee = restaurant?.deliveryFee ?? 30
                    let taxes = appState.cart.subtotal * Decimal(0.05)
                    let total = appState.cart.subtotal + deliveryFee + taxes
                    
                    Text(total.formattedCurrency)
                        .font(.headline)
                    Text("Total")
                        .font(.caption)
                        .opacity(0.8)
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Text("Proceed to Checkout")
                        .fontWeight(.semibold)
                    Image(systemName: "chevron.right")
                        .font(.caption)
                }
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.pipOrange)
            .cornerRadius(12)
        }
        .padding()
        .background(
            LinearGradient(
                colors: [.clear, .white, .white],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

struct BillRow: View {
    let label: String
    let value: String
    var valueColor: Color?
    var isBold: Bool = false
    
    var body: some View {
        HStack {
            Text(label)
                .font(isBold ? .subheadline : .caption)
                .fontWeight(isBold ? .semibold : .regular)
                .foregroundColor(isBold ? .primary : .secondary)
            
            Spacer()
            
            Text(value)
                .font(isBold ? .subheadline : .caption)
                .fontWeight(isBold ? .bold : .medium)
                .foregroundColor(valueColor ?? (isBold ? .primary : .secondary))
        }
    }
}

#Preview {
    NavigationStack {
        CartView()
    }
    .environment(AppState())
}
