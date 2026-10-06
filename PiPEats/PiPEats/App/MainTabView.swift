import SwiftUI

struct MainTabView: View {
    @Environment(AppState.self) private var appState
    @State private var selectedTab = 0
    @State private var homeViewModel = HomeViewModel()
    @State private var orderViewModel = OrderViewModel()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(viewModel: homeViewModel)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            OrderHistoryView(viewModel: orderViewModel)
                .tabItem {
                    Label("Orders", systemImage: "bag.fill")
                }
                .tag(1)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(2)
        }
        .tint(.pipOrange)
        .overlay(alignment: .bottom) {
            if !appState.cart.isEmpty && selectedTab == 0 {
                cartFloatingButton
            }
        }
    }
    
    private var cartFloatingButton: some View {
        NavigationLink {
            CartView()
        } label: {
            HStack {
                HStack(spacing: 4) {
                    Text("\(appState.cart.itemCount)")
                        .fontWeight(.bold)
                    Text(appState.cart.itemCount == 1 ? "item" : "items")
                }
                
                Text("|")
                    .opacity(0.5)
                
                Text(appState.cart.subtotal.formattedCurrency)
                    .fontWeight(.bold)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Text("View Cart")
                        .fontWeight(.semibold)
                    Image(systemName: "chevron.right")
                        .font(.caption)
                }
            }
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.pipOrange)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 80)
    }
}

#Preview {
    MainTabView()
        .environment(AppState())
}
