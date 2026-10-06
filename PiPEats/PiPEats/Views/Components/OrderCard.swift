import SwiftUI

struct OrderCard: View {
    let order: Order
    var onReorder: (() -> Void)?
    var onTrack: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            headerRow
            
            Divider()
            
            itemsSection
            
            footerRow
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    private var headerRow: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(order.restaurantName)
                    .font(.headline)
                
                Text(order.createdAt.formattedOrderDate())
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            OrderStatusBadge(status: order.status)
        }
    }
    
    private var itemsSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach(order.items.prefix(3)) { item in
                HStack(spacing: 8) {
                    VegIndicator(isVeg: item.isVeg, size: 12)
                    
                    Text("\(item.quantity)x \(item.name)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            
            if order.items.count > 3 {
                Text("+\(order.items.count - 3) more items")
                    .font(.caption)
                    .foregroundColor(.pipOrange)
            }
        }
    }
    
    private var footerRow: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Total")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(order.formattedTotal)
                    .font(.subheadline)
                    .fontWeight(.bold)
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                if order.status == .delivered, let onReorder = onReorder {
                    Button(action: onReorder) {
                        Text("Reorder")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.pipOrange)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.pipOrange, lineWidth: 1)
                            )
                    }
                }
                
                if order.status.isActive, let onTrack = onTrack {
                    Button(action: onTrack) {
                        Text("Track")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.pipOrange)
                            .cornerRadius(8)
                    }
                }
            }
        }
    }
}

struct OrderCardCompact: View {
    let order: Order
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.pipOrange.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: "bag.fill")
                    .font(.title3)
                    .foregroundColor(.pipOrange)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(order.restaurantName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
                
                Text("\(order.items.count) items • \(order.formattedTotal)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                OrderStatusBadge(status: order.status)
                
                Text(order.createdAt.timeAgoDisplay())
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

#Preview {
    VStack(spacing: 16) {
        OrderCard(
            order: MockDataService.shared.createMockOrderHistory()[0],
            onReorder: {},
            onTrack: {}
        )
        
        OrderCardCompact(
            order: MockDataService.shared.createMockOrderHistory()[0]
        )
    }
    .padding()
    .background(Color.pipLightGray)
}
