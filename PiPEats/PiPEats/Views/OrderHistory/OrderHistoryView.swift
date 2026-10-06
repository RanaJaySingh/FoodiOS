import SwiftUI

struct OrderHistoryView: View {
    @Environment(AppState.self) private var appState
    @Bindable var viewModel: OrderViewModel
    @State private var selectedTab = 0
    @State private var selectedOrderForTracking: String?
    
    private var activeOrders: [Order] {
        viewModel.getActiveOrders(from: appState.orders)
    }
    
    private var pastOrders: [Order] {
        viewModel.getPastOrders(from: appState.orders)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                segmentedControl
                
                if viewModel.isLoading {
                    LoadingView(message: "Loading orders...")
                } else {
                    ordersList
                }
            }
            .background(Color.pipLightGray)
            .navigationTitle("My Orders")
            .refreshable {
                viewModel.refreshOrders(appState: appState)
            }
            .navigationDestination(item: $selectedOrderForTracking) { orderId in
                OrderTrackingView(orderId: orderId)
            }
        }
    }
    
    private var segmentedControl: some View {
        HStack(spacing: 0) {
            ForEach(["Active", "Past"], id: \.self) { tab in
                let index = tab == "Active" ? 0 : 1
                let count = index == 0 ? activeOrders.count : pastOrders.count
                
                Button {
                    withAnimation {
                        selectedTab = index
                    }
                } label: {
                    VStack(spacing: 8) {
                        HStack(spacing: 6) {
                            Text(tab)
                                .font(.subheadline)
                                .fontWeight(selectedTab == index ? .semibold : .regular)
                            
                            if count > 0 {
                                Text("\(count)")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(selectedTab == index ? Color.pipOrange : Color.gray)
                                    .cornerRadius(10)
                            }
                        }
                        .foregroundColor(selectedTab == index ? .pipOrange : .gray)
                        
                        Rectangle()
                            .fill(selectedTab == index ? Color.pipOrange : Color.clear)
                            .frame(height: 2)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal)
        .background(Color.white)
    }
    
    private var ordersList: some View {
        Group {
            let orders = selectedTab == 0 ? activeOrders : pastOrders
            
            if orders.isEmpty {
                emptyStateView
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(orders) { order in
                            OrderCard(
                                order: order,
                                onReorder: {
                                    viewModel.reorderItems(from: order, appState: appState)
                                },
                                onTrack: {
                                    selectedOrderForTracking = order.id
                                }
                            )
                            .onTapGesture {
                                selectedOrderForTracking = order.id
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        EmptyStateView(
            icon: selectedTab == 0 ? "bag" : "clock.arrow.circlepath",
            title: selectedTab == 0 ? "No Active Orders" : "No Past Orders",
            message: selectedTab == 0 
                ? "You don't have any active orders right now. Start ordering to see them here!"
                : "Your order history will appear here once you complete an order.",
            buttonTitle: "Browse Restaurants",
            action: nil
        )
    }
}

#Preview {
    OrderHistoryView(viewModel: OrderViewModel())
        .environment(AppState())
}
