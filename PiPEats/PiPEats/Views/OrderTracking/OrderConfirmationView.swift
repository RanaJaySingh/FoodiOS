import SwiftUI

struct OrderConfirmationView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    
    let order: Order
    @State private var showConfetti = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                successAnimation
                orderDetails
                estimatedDelivery
                orderItems
                trackOrderButton
            }
            .padding()
        }
        .background(Color.pipLightGray)
        .navigationTitle("Order Confirmed")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    navigateToHome()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                showConfetti = true
            }
        }
    }
    
    private var successAnimation: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.pipGreen.opacity(0.1))
                    .frame(width: 120, height: 120)
                    .scaleEffect(showConfetti ? 1 : 0)
                
                Circle()
                    .fill(Color.pipGreen.opacity(0.2))
                    .frame(width: 90, height: 90)
                    .scaleEffect(showConfetti ? 1 : 0)
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.pipGreen)
                    .scaleEffect(showConfetti ? 1 : 0)
            }
            
            VStack(spacing: 8) {
                Text("Order Placed!")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Your order has been successfully placed")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.top, 20)
    }
    
    private var orderDetails: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Order Number")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(order.orderNumber)
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                OrderStatusBadge(status: order.status)
            }
            
            Divider()
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(order.restaurantName)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text("\(order.items.count) items • \(order.formattedTotal)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
    
    private var estimatedDelivery: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.pipOrange.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: "clock.fill")
                    .font(.title2)
                    .foregroundColor(.pipOrange)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Estimated Delivery")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if let eta = order.estimatedTimeText {
                    Text("by \(eta)")
                        .font(.title3)
                        .fontWeight(.bold)
                } else {
                    Text("35-45 minutes")
                        .font(.title3)
                        .fontWeight(.bold)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
    
    private var orderItems: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Order Items")
                .font(.headline)
            
            ForEach(order.items) { item in
                HStack {
                    VegIndicator(isVeg: item.isVeg, size: 14)
                    
                    Text("\(item.quantity)x \(item.name)")
                        .font(.subheadline)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text(item.formattedTotalPrice)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
            }
            
            Divider()
            
            HStack {
                Text("Total")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text(order.formattedTotal)
                    .font(.subheadline)
                    .fontWeight(.bold)
            }
            
            HStack {
                Image(systemName: paymentIcon(for: order.paymentMethod))
                    .foregroundColor(.pipOrange)
                Text("Paid via \(order.paymentMethod)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
    
    private var trackOrderButton: some View {
        NavigationLink {
            OrderTrackingView(orderId: order.id)
        } label: {
            HStack {
                Image(systemName: "location.fill")
                Text("Track Order")
                    .fontWeight(.semibold)
            }
            .primaryButtonStyle()
        }
    }
    
    private func navigateToHome() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = UIHostingController(
                rootView: ContentView()
                    .environment(appState)
            )
        }
    }
    
    private func paymentIcon(for method: String) -> String {
        switch method {
        case "UPI": return "indianrupeesign.circle"
        case "Credit/Debit Card": return "creditcard"
        case "Cash on Delivery": return "banknote"
        case "Wallet": return "wallet.pass"
        default: return "creditcard"
        }
    }
}

#Preview {
    NavigationStack {
        OrderConfirmationView(
            order: MockDataService.shared.createMockOrderHistory()[0]
        )
    }
    .environment(AppState())
}
