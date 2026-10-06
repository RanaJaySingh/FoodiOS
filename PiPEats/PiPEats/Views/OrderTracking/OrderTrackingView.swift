import SwiftUI

struct OrderTrackingView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    
    let orderId: String
    @State private var showCancelAlert = false
    
    private var order: Order? {
        appState.getOrder(by: orderId)
    }
    
    var body: some View {
        Group {
            if let order = order {
                orderTrackingContent(order: order)
            } else {
                orderNotFound
            }
        }
        .navigationTitle("Track Order")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Cancel Order?", isPresented: $showCancelAlert) {
            Button("Keep Order", role: .cancel) {}
            Button("Cancel Order", role: .destructive) {
                appState.cancelOrder(orderId)
            }
        } message: {
            Text("Are you sure you want to cancel this order? This action cannot be undone.")
        }
    }
    
    private func orderTrackingContent(order: Order) -> some View {
        ScrollView {
            VStack(spacing: 20) {
                statusHeader(order: order)
                
                if order.status == .cancelled {
                    cancelledMessage
                } else {
                    orderProgress(order: order)
                    
                    if order.status == .outForDelivery {
                        deliveryPersonInfo(order: order)
                    }
                    
                    deliveryAddress(order: order)
                    orderSummary(order: order)
                    
                    if order.status.isActive && order.status != .outForDelivery {
                        cancelButton
                    }
                }
            }
            .padding()
        }
        .background(Color.pipLightGray)
    }
    
    private var orderNotFound: some View {
        EmptyStateView(
            icon: "exclamationmark.triangle",
            title: "Order Not Found",
            message: "We couldn't find the order you're looking for",
            buttonTitle: "Go Back"
        ) {
            dismiss()
        }
    }
    
    private func statusHeader(order: Order) -> some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(statusColor(for: order.status).opacity(0.1))
                    .frame(width: 80, height: 80)
                
                Image(systemName: order.status.icon)
                    .font(.system(size: 35))
                    .foregroundColor(statusColor(for: order.status))
            }
            
            Text(order.status.displayName)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(order.status.statusDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            if order.status.isActive, let eta = order.estimatedTimeText {
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                    Text("Estimated arrival: \(eta)")
                }
                .font(.subheadline)
                .foregroundColor(.pipOrange)
                .padding(.top, 4)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
    }
    
    private var cancelledMessage: some View {
        VStack(spacing: 12) {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 40))
                .foregroundColor(.pipRed)
            
            Text("Order Cancelled")
                .font(.headline)
            
            Text("Your order has been cancelled. If you were charged, a refund will be processed within 5-7 business days.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
    
    private func orderProgress(order: Order) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Order Status")
                .font(.headline)
            
            OrderProgressView(status: order.status)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
    
    private func deliveryPersonInfo(order: Order) -> some View {
        VStack(spacing: 12) {
            HStack {
                Text("Your Delivery Partner")
                    .font(.headline)
                Spacer()
            }
            
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.pipOrange.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "person.fill")
                        .font(.title2)
                        .foregroundColor(.pipOrange)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(order.deliveryPersonName ?? "Delivery Partner")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Text("On the way to you")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if let phone = order.deliveryPersonPhone {
                    Button {
                        callDeliveryPerson(phone: phone)
                    } label: {
                        Image(systemName: "phone.fill")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.pipGreen)
                            .clipShape(Circle())
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
    
    private func deliveryAddress(order: Order) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Delivery Address")
                .font(.headline)
            
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "mappin.circle.fill")
                    .font(.title2)
                    .foregroundColor(.pipOrange)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(order.deliveryAddress.label)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Text(order.deliveryAddress.displayAddress)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(12)
    }
    
    private func orderSummary(order: Order) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Order Summary")
                    .font(.headline)
                
                Spacer()
                
                Text(order.orderNumber)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(order.restaurantName)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text(order.itemsDescription)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Text(order.formattedTotal)
                    .font(.subheadline)
                    .fontWeight(.bold)
            }
            
            HStack {
                Image(systemName: "clock")
                    .font(.caption)
                Text("Ordered on \(order.createdAt.formattedOrderDate())")
                    .font(.caption)
            }
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
    
    private var cancelButton: some View {
        Button {
            showCancelAlert = true
        } label: {
            HStack {
                Image(systemName: "xmark.circle")
                Text("Cancel Order")
            }
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundColor(.pipRed)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.pipRed.opacity(0.1))
            .cornerRadius(12)
        }
    }
    
    private func statusColor(for status: OrderStatus) -> Color {
        switch status {
        case .delivered:
            return .pipGreen
        case .cancelled:
            return .pipRed
        default:
            return .pipOrange
        }
    }
    
    private func callDeliveryPerson(phone: String) {
        let cleanedPhone = phone.replacingOccurrences(of: " ", with: "")
        if let url = URL(string: "tel://\(cleanedPhone)") {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    NavigationStack {
        OrderTrackingView(orderId: "order_001")
    }
    .environment(AppState())
}
