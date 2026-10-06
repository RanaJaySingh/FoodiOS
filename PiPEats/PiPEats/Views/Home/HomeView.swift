import SwiftUI

struct HomeView: View {
    @Environment(AppState.self) private var appState
    @Bindable var viewModel: HomeViewModel
    @State private var showLocationPicker = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    locationHeader
                    
                    SearchBar(text: $viewModel.searchQuery) {
                        viewModel.filterRestaurants()
                    }
                    .padding(.horizontal)
                    
                    CategoryScrollView(
                        selectedCategory: $viewModel.selectedCategory
                    ) { category in
                        viewModel.selectCategory(category)
                    }
                    
                    if viewModel.isLoading {
                        loadingView
                    } else if viewModel.filteredRestaurants.isEmpty {
                        emptySearchView
                    } else {
                        restaurantsList
                    }
                }
                .padding(.bottom, appState.cart.isEmpty ? 20 : 100)
            }
            .background(Color.pipLightGray)
            .refreshable {
                viewModel.loadRestaurants()
            }
            .sheet(isPresented: $showLocationPicker) {
                LocationPickerView()
            }
        }
    }
    
    private var locationHeader: some View {
        HStack {
            Button {
                showLocationPicker = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "location.fill")
                        .foregroundColor(.pipOrange)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Deliver to")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 4) {
                            Text(appState.selectedLocation?.displayText ?? "Select Location")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            Image(systemName: "chevron.down")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            
            Spacer()
            
            NavigationLink {
                ProfileView()
            } label: {
                Image(systemName: "person.circle.fill")
                    .font(.title)
                    .foregroundColor(.pipOrange)
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ForEach(0..<3, id: \.self) { _ in
                ShimmerCard()
            }
        }
        .padding(.horizontal)
    }
    
    private var emptySearchView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("No restaurants found")
                .font(.headline)
            
            Text("Try a different search or category")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if !viewModel.searchQuery.isEmpty || viewModel.selectedCategory != .all {
                Button {
                    viewModel.clearSearch()
                    viewModel.selectCategory(.all)
                } label: {
                    Text("Clear Filters")
                        .secondaryButtonStyle()
                        .padding(.horizontal, 48)
                }
            }
        }
        .padding(.vertical, 60)
    }
    
    private var restaurantsList: some View {
        LazyVStack(spacing: 16) {
            ForEach(viewModel.filteredRestaurants) { restaurant in
                NavigationLink {
                    RestaurantDetailView(restaurant: restaurant)
                } label: {
                    RestaurantCard(restaurant: restaurant)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal)
    }
}

struct ShimmerCard: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 140)
            
            VStack(alignment: .leading, spacing: 8) {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 180, height: 18)
                
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 120, height: 14)
                
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 200, height: 12)
            }
            .padding(12)
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .opacity(isAnimating ? 0.5 : 1.0)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).repeatForever()) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel())
        .environment(AppState())
}
