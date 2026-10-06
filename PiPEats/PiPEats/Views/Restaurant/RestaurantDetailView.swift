import SwiftUI

struct RestaurantDetailView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    
    let restaurant: Restaurant
    @State private var selectedCategory: String?
    @State private var showCartConflictAlert = false
    @State private var pendingItem: MenuItem?
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 0) {
                    restaurantHeader
                    
                    categoryTabs(proxy: proxy)
                    
                    menuSections
                }
                .padding(.bottom, appState.cart.isEmpty ? 20 : 100)
            }
        }
        .background(Color.pipLightGray)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if !appState.cart.isEmpty && appState.cart.restaurantId == restaurant.id {
                    NavigationLink {
                        CartView()
                    } label: {
                        cartBadge
                    }
                }
            }
        }
        .overlay(alignment: .bottom) {
            if !appState.cart.isEmpty && appState.cart.restaurantId == restaurant.id {
                viewCartButton
            }
        }
        .alert("Replace cart items?", isPresented: $showCartConflictAlert) {
            Button("Cancel", role: .cancel) {
                pendingItem = nil
            }
            Button("Replace", role: .destructive) {
                if let item = pendingItem {
                    appState.clearCart()
                    addItemToCart(item)
                    pendingItem = nil
                }
            }
        } message: {
            Text("Your cart contains items from \(appState.cart.restaurantName ?? "another restaurant"). Do you want to discard them and add items from \(restaurant.name)?")
        }
    }
    
    private var restaurantHeader: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [Color.pipOrange.opacity(0.4), Color.pipOrange.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 180)
                    .overlay {
                        Image(systemName: "fork.knife")
                            .font(.system(size: 60))
                            .foregroundColor(.pipOrange.opacity(0.3))
                    }
                
                VStack(alignment: .leading, spacing: 4) {
                    if restaurant.isPureVeg {
                        HStack(spacing: 4) {
                            VegIndicator(isVeg: true, size: 12)
                            Text("Pure Veg")
                                .font(.caption2)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.pipGreen)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white)
                        .cornerRadius(4)
                    }
                }
                .padding()
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text(restaurant.name)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(restaurant.cuisineText)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text(restaurant.ratingText)
                            .fontWeight(.semibold)
                        Text("(\(restaurant.reviewCount)+ ratings)")
                            .foregroundColor(.secondary)
                    }
                    .font(.subheadline)
                }
                
                HStack(spacing: 20) {
                    InfoPill(icon: "clock", text: "\(restaurant.deliveryTimeMinutes) mins")
                    InfoPill(icon: "bicycle", text: restaurant.deliveryFee == 0 ? "Free" : "₹\(restaurant.deliveryFee)")
                    InfoPill(icon: "indianrupeesign", text: "₹\(restaurant.minimumOrder) min")
                }
                
                Text(restaurant.address)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.white)
        }
    }
    
    private func categoryTabs(proxy: ScrollViewProxy) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(restaurant.categories) { category in
                    Button {
                        withAnimation {
                            selectedCategory = category.id
                            proxy.scrollTo(category.id, anchor: .top)
                        }
                    } label: {
                        Text(category.name)
                            .font(.subheadline)
                            .fontWeight(selectedCategory == category.id ? .semibold : .regular)
                            .foregroundColor(selectedCategory == category.id ? .white : .primary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(selectedCategory == category.id ? Color.pipOrange : Color.white)
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
        .background(Color.white)
    }
    
    private var menuSections: some View {
        LazyVStack(spacing: 16, pinnedViews: []) {
            ForEach(restaurant.categories) { category in
                Section {
                    ForEach(category.items) { item in
                        MenuItemRow(item: item) {
                            handleAddItem(item)
                        }
                    }
                } header: {
                    HStack {
                        Text(category.name)
                            .font(.headline)
                        
                        Text("(\(category.items.count))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color.pipLightGray)
                }
                .id(category.id)
            }
        }
        .padding(.top, 8)
    }
    
    private var cartBadge: some View {
        ZStack(alignment: .topTrailing) {
            Image(systemName: "cart.fill")
                .font(.title3)
                .foregroundColor(.pipOrange)
            
            Text("\(appState.cart.itemCount)")
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(4)
                .background(Color.pipOrange)
                .clipShape(Circle())
                .offset(x: 8, y: -8)
        }
    }
    
    private var viewCartButton: some View {
        NavigationLink {
            CartView()
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(appState.cart.itemCount) \(appState.cart.itemCount == 1 ? "item" : "items")")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text(appState.cart.subtotal.formattedCurrency)
                        .font(.caption)
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Text("View Cart")
                        .fontWeight(.semibold)
                    Image(systemName: "chevron.right")
                        .font(.caption)
                }
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.pipOrange)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
        }
        .padding()
    }
    
    private func handleAddItem(_ item: MenuItem) {
        if appState.cart.restaurantId != nil && appState.cart.restaurantId != restaurant.id {
            pendingItem = item
            showCartConflictAlert = true
        } else {
            addItemToCart(item)
        }
    }
    
    private func addItemToCart(_ item: MenuItem) {
        appState.addToCart(item: item, from: restaurant)
    }
}

struct InfoPill: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
            Text(text)
                .font(.caption)
        }
        .foregroundColor(.secondary)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.pipLightGray)
        .cornerRadius(16)
    }
}

#Preview {
    NavigationStack {
        RestaurantDetailView(restaurant: MockDataService.shared.restaurants[0])
    }
    .environment(AppState())
}
