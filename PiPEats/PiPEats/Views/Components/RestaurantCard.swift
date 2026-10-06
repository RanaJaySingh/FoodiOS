import SwiftUI

struct RestaurantCard: View {
    let restaurant: Restaurant
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            restaurantImage
            restaurantInfo
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
    }
    
    private var restaurantImage: some View {
        ZStack(alignment: .topTrailing) {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.pipOrange.opacity(0.3), Color.pipOrange.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 140)
                .overlay {
                    Image(systemName: "fork.knife")
                        .font(.system(size: 40))
                        .foregroundColor(.pipOrange.opacity(0.5))
                }
            
            if restaurant.isPureVeg {
                HStack(spacing: 4) {
                    VegIndicator(isVeg: true, size: 12)
                    Text("Pure Veg")
                        .font(.caption2)
                        .fontWeight(.medium)
                }
                .foregroundColor(.pipGreen)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.white)
                .cornerRadius(4)
                .padding(8)
            }
            
            if restaurant.deliveryFee == 0 {
                HStack(spacing: 2) {
                    Image(systemName: "bicycle")
                        .font(.caption2)
                    Text("Free Delivery")
                        .font(.caption2)
                        .fontWeight(.medium)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.pipOrange)
                .cornerRadius(4)
                .padding(8)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }
        }
        .cornerRadius(16, corners: [.topLeft, .topRight])
    }
    
    private var restaurantInfo: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(restaurant.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Spacer()
                
                ratingBadge
            }
            
            Text(restaurant.cuisineText)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(1)
            
            HStack(spacing: 12) {
                Label(restaurant.deliveryTimeText, systemImage: "clock")
                
                if restaurant.deliveryFee > 0 {
                    Label("₹\(restaurant.deliveryFee)", systemImage: "bicycle")
                }
                
                Label("₹\(restaurant.minimumOrder) min", systemImage: "indianrupeesign")
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding(12)
    }
    
    private var ratingBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .font(.caption2)
            Text(restaurant.ratingText)
                .font(.caption)
                .fontWeight(.semibold)
        }
        .foregroundColor(.white)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(restaurant.rating >= 4.0 ? Color.pipGreen : Color.pipOrange)
        .cornerRadius(6)
    }
}

struct RestaurantListCard: View {
    let restaurant: Restaurant
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [Color.pipOrange.opacity(0.3), Color.pipOrange.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: "fork.knife")
                    .font(.title2)
                    .foregroundColor(.pipOrange.opacity(0.5))
            }
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(restaurant.name)
                        .font(.headline)
                        .lineLimit(1)
                    
                    if restaurant.isPureVeg {
                        VegIndicator(isVeg: true, size: 14)
                    }
                }
                
                Text(restaurant.cuisineText)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                HStack(spacing: 8) {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .font(.caption2)
                            .foregroundColor(.yellow)
                        Text(restaurant.ratingText)
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    
                    Text("•")
                        .foregroundColor(.secondary)
                    
                    Text(restaurant.deliveryTimeText)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if restaurant.deliveryFee == 0 {
                        Text("•")
                            .foregroundColor(.secondary)
                        Text("Free Delivery")
                            .font(.caption)
                            .foregroundColor(.pipGreen)
                            .fontWeight(.medium)
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 16) {
            RestaurantCard(restaurant: MockDataService.shared.restaurants[0])
            RestaurantListCard(restaurant: MockDataService.shared.restaurants[1])
        }
        .padding()
    }
    .background(Color.pipLightGray)
}
