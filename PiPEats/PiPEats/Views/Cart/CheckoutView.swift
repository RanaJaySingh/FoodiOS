import SwiftUI

struct CheckoutView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = CartViewModel()
    @State private var selectedAddress: Address?
    @State private var showAddressSelection = false
    @State private var showOrderConfirmation = false
    
    private var restaurant: Restaurant? {
        guard let id = appState.cart.restaurantId else { return nil }
        return MockDataService.shared.getRestaurant(by: id)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                deliveryAddressSection
                paymentMethodSection
                deliveryInstructionsSection
                orderSummary
            }
            .padding()
            .padding(.bottom, 100)
        }
        .background(Color.pipLightGray)
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            selectedAddress = appState.currentUser?.defaultAddress
        }
        .sheet(isPresented: $showAddressSelection) {
            AddressSelectionView(selectedAddress: $selectedAddress)
        }
        .overlay(alignment: .bottom) {
            placeOrderButton
        }
        .overlay {
            if viewModel.isProcessingOrder {
                processingOverlay
            }
        }
        .navigationDestination(isPresented: $showOrderConfirmation) {
            if let order = viewModel.placedOrder {
                OrderConfirmationView(order: order)
            }
        }
        .onChange(of: viewModel.showOrderSuccess) { _, newValue in
            if newValue {
                showOrderConfirmation = true
            }
        }
    }
    
    private var deliveryAddressSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Delivery Address")
                    .font(.headline)
                
                Spacer()
                
                Button {
                    showAddressSelection = true
                } label: {
                    Text("Change")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.pipOrange)
                }
            }
            
            if let address = selectedAddress {
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: addressIcon(for: address.label))
                        .font(.title2)
                        .foregroundColor(.pipOrange)
                        .frame(width: 40)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(address.label)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Text(address.displayAddress)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
            } else {
                Button {
                    showAddressSelection = true
                } label: {
                    HStack {
                        Image(systemName: "plus.circle")
                        Text("Add Delivery Address")
                    }
                    .font(.subheadline)
                    .foregroundColor(.pipOrange)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
    
    private var paymentMethodSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Payment Method")
                .font(.headline)
            
            ForEach(viewModel.paymentMethods, id: \.self) { method in
                PaymentMethodRow(
                    method: method,
                    isSelected: viewModel.selectedPaymentMethod == method
                ) {
                    viewModel.selectedPaymentMethod = method
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
    
    private var deliveryInstructionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Delivery Instructions (Optional)")
                .font(.headline)
            
            TextField("E.g., Ring the doorbell twice", text: $viewModel.deliveryInstructions, axis: .vertical)
                .textFieldStyle(.plain)
                .padding()
                .background(Color.pipLightGray)
                .cornerRadius(8)
                .lineLimit(2...4)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
    
    private var orderSummary: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Order Summary")
                .font(.headline)
            
            ForEach(appState.cart.items) { item in
                HStack {
                    VegIndicator(isVeg: item.isVeg, size: 12)
                    Text("\(item.quantity)x \(item.name)")
                        .font(.caption)
                        .lineLimit(1)
                    Spacer()
                    Text(item.formattedTotalPrice)
                        .font(.caption)
                        .fontWeight(.medium)
                }
            }
            
            Divider()
            
            let totals = viewModel.calculateTotal(cart: appState.cart, restaurant: restaurant)
            
            BillRow(label: "Item Total", value: totals.subtotal.formattedCurrency)
            BillRow(
                label: "Delivery Fee",
                value: totals.deliveryFee == 0 ? "FREE" : totals.deliveryFee.formattedCurrency,
                valueColor: totals.deliveryFee == 0 ? .pipGreen : nil
            )
            BillRow(label: "Taxes & Charges", value: totals.taxes.formattedCurrency)
            
            Divider()
            
            BillRow(label: "Grand Total", value: totals.total.formattedCurrency, isBold: true)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
    
    private var placeOrderButton: some View {
        Button {
            guard let address = selectedAddress else { return }
            viewModel.processOrder(appState: appState, deliveryAddress: address)
        } label: {
            HStack {
                let totals = viewModel.calculateTotal(cart: appState.cart, restaurant: restaurant)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(totals.total.formattedCurrency)
                        .font(.headline)
                    Text("Total")
                        .font(.caption)
                        .opacity(0.8)
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Text("Place Order")
                        .fontWeight(.semibold)
                    Image(systemName: "chevron.right")
                        .font(.caption)
                }
            }
            .foregroundColor(.white)
            .padding()
            .background(selectedAddress == nil ? Color.gray : Color.pipOrange)
            .cornerRadius(12)
        }
        .disabled(selectedAddress == nil)
        .padding()
        .background(
            LinearGradient(
                colors: [.clear, .white, .white],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
    
    private var processingOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.white)
                
                Text("Processing your order...")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding(40)
            .background(Color.pipDarkGray)
            .cornerRadius(16)
        }
    }
    
    private func addressIcon(for label: String) -> String {
        switch label.lowercased() {
        case "home": return "house.fill"
        case "work": return "building.2.fill"
        default: return "mappin.circle.fill"
        }
    }
}

struct PaymentMethodRow: View {
    let method: String
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 12) {
                Image(systemName: icon(for: method))
                    .font(.title3)
                    .foregroundColor(.pipOrange)
                    .frame(width: 30)
                
                Text(method)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .pipOrange : .gray)
            }
            .padding()
            .background(isSelected ? Color.pipOrange.opacity(0.1) : Color.pipLightGray)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? Color.pipOrange : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
    
    private func icon(for method: String) -> String {
        switch method {
        case "UPI": return "indianrupeesign.circle"
        case "Credit/Debit Card": return "creditcard"
        case "Cash on Delivery": return "banknote"
        case "Wallet": return "wallet.pass"
        default: return "creditcard"
        }
    }
}

struct AddressSelectionView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedAddress: Address?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(appState.currentUser?.addresses ?? []) { address in
                    Button {
                        selectedAddress = address
                        dismiss()
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(address.label)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                
                                Text(address.displayAddress)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            if selectedAddress?.id == address.id {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.pipOrange)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Select Address")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CheckoutView()
    }
    .environment(AppState())
}
