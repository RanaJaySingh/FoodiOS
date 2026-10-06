import SwiftUI

struct MenuItemRow: View {
    let item: MenuItem
    let onAdd: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            itemInfo
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 8) {
                itemImage
                addButton
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
    }
    
    private var itemInfo: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                VegIndicator(isVeg: item.isVeg, size: 16)
                
                if item.isBestseller {
                    Text("Bestseller")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.pipOrange)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.pipOrange.opacity(0.1))
                        .cornerRadius(4)
                }
                
                if item.isSpicy {
                    Image(systemName: "flame.fill")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            
            Text(item.name)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(2)
            
            Text(item.formattedPrice)
                .font(.subheadline)
                .fontWeight(.medium)
            
            if !item.description.isEmpty {
                Text(item.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            if item.customizations != nil && !item.customizations!.isEmpty {
                Text("Customisable")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var itemImage: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    LinearGradient(
                        colors: [Color.orange.opacity(0.2), Color.orange.opacity(0.05)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 100, height: 80)
            
            Image(systemName: item.isVeg ? "leaf.fill" : "fork.knife")
                .font(.title2)
                .foregroundColor(item.isVeg ? .green.opacity(0.5) : .orange.opacity(0.5))
        }
    }
    
    private var addButton: some View {
        Button(action: onAdd) {
            Text("ADD")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.pipOrange)
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.pipOrange, lineWidth: 1)
                )
                .cornerRadius(8)
        }
    }
}

struct MenuItemCompactRow: View {
    let item: MenuItem
    let quantity: Int
    let onIncrement: () -> Void
    let onDecrement: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            VegIndicator(isVeg: item.isVeg, size: 14)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.subheadline)
                    .lineLimit(1)
                
                Text(item.formattedPrice)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if quantity > 0 {
                quantityControl
            } else {
                addButton
            }
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(8)
    }
    
    private var addButton: some View {
        Button(action: onIncrement) {
            Text("ADD")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.pipOrange)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.pipOrange, lineWidth: 1)
                )
        }
    }
    
    private var quantityControl: some View {
        HStack(spacing: 12) {
            Button(action: onDecrement) {
                Image(systemName: "minus")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.pipOrange)
            }
            
            Text("\(quantity)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .frame(minWidth: 20)
            
            Button(action: onIncrement) {
                Image(systemName: "plus")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.pipOrange)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.pipOrange.opacity(0.1))
        .cornerRadius(6)
    }
}

#Preview {
    VStack(spacing: 12) {
        MenuItemRow(
            item: MockDataService.shared.restaurants[0].categories[0].items[0]
        ) {}
        
        MenuItemCompactRow(
            item: MockDataService.shared.restaurants[0].categories[0].items[0],
            quantity: 2,
            onIncrement: {},
            onDecrement: {}
        )
    }
    .padding()
    .background(Color.pipLightGray)
}
