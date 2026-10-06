import SwiftUI

struct CategoryChip: View {
    let category: FoodCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: category.icon)
                    .font(.caption)
                
                Text(category.rawValue)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
            .foregroundColor(isSelected ? .white : .primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(isSelected ? Color.pipOrange : Color.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(.plain)
    }
}

struct CategoryScrollView: View {
    @Binding var selectedCategory: FoodCategory
    var onSelect: (FoodCategory) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(FoodCategory.allCases) { category in
                    CategoryChip(
                        category: category,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
                        onSelect(category)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    VStack {
        CategoryChip(category: .biryani, isSelected: true) {}
        CategoryChip(category: .pizza, isSelected: false) {}
        
        CategoryScrollView(selectedCategory: .constant(.all)) { _ in }
    }
    .padding()
    .background(Color.pipLightGray)
}
