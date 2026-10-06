import SwiftUI

struct CartItemRow: View {
    let item: CartLine
    let onIncrement: () -> Void
    let onDecrement: () -> Void
    let onRemove: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VegIndicator(isVeg: item.isVeg, size: 16)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(2)
                
                if let customizations = item.customizationsText {
                    Text(customizations)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text(item.formattedUnitPrice)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 8) {
                quantityControl
                
                Text(item.formattedTotalPrice)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
    
    private var quantityControl: some View {
        HStack(spacing: 16) {
            Button(action: {
                if item.quantity > 1 {
                    onDecrement()
                } else {
                    onRemove()
                }
            }) {
                Image(systemName: item.quantity > 1 ? "minus" : "trash")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(item.quantity > 1 ? .pipOrange : .red)
            }
            
            Text("\(item.quantity)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .frame(minWidth: 24)
            
            Button(action: onIncrement) {
                Image(systemName: "plus")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.pipOrange)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.pipOrange.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    CartItemRow(
        item: CartLine(
            id: "1",
            menuItemId: "item_001",
            name: "Hyderabadi Chicken Dum Biryani",
            price: 349,
            quantity: 2,
            isVeg: false,
            customizations: []
        ),
        onIncrement: {},
        onDecrement: {},
        onRemove: {}
    )
    .padding()
    .background(Color.pipLightGray)
}
