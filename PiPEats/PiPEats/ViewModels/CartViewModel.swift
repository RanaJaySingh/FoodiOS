import Foundation
import Observation

@Observable
final class CartViewModel {
    var selectedPaymentMethod: String = "UPI"
    var deliveryInstructions: String = ""
    var isProcessingOrder: Bool = false
    var showOrderSuccess: Bool = false
    var placedOrder: Order?
    
    let paymentMethods = ["UPI", "Credit/Debit Card", "Cash on Delivery", "Wallet"]
    
    func calculateTotal(cart: Cart, restaurant: Restaurant?) -> (subtotal: Decimal, deliveryFee: Decimal, taxes: Decimal, total: Decimal) {
        let subtotal = cart.subtotal
        let deliveryFee = restaurant?.deliveryFee ?? 30
        let taxes = subtotal * Decimal(0.05)
        let total = subtotal + deliveryFee + taxes
        
        return (subtotal, deliveryFee, taxes, total)
    }
    
    func processOrder(appState: AppState, deliveryAddress: Address) {
        isProcessingOrder = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            
            let order = appState.placeOrder(
                deliveryAddress: deliveryAddress,
                paymentMethod: self.selectedPaymentMethod
            )
            
            self.placedOrder = order
            self.isProcessingOrder = false
            self.showOrderSuccess = true
        }
    }
    
    func reset() {
        selectedPaymentMethod = "UPI"
        deliveryInstructions = ""
        isProcessingOrder = false
        showOrderSuccess = false
        placedOrder = nil
    }
}
