import SwiftUI

// MARK: - Color Extensions

extension Color {
    static let pipOrange = Color(red: 0.922, green: 0.298, blue: 0.208)
    static let pipGreen = Color(red: 0.133, green: 0.545, blue: 0.133)
    static let pipRed = Color(red: 0.8, green: 0.2, blue: 0.2)
    static let pipGray = Color(red: 0.6, green: 0.6, blue: 0.6)
    static let pipLightGray = Color(red: 0.95, green: 0.95, blue: 0.95)
    static let pipDarkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
}

// MARK: - View Extensions

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    func cardStyle() -> some View {
        self
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
    }
    
    func primaryButtonStyle() -> some View {
        self
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.pipOrange)
            .cornerRadius(12)
    }
    
    func secondaryButtonStyle() -> some View {
        self
            .font(.headline)
            .foregroundColor(.pipOrange)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.pipOrange.opacity(0.1))
            .cornerRadius(12)
    }
}

// MARK: - RoundedCorner Shape

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Date Extensions

extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: self, relativeTo: Date())
    }
    
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
    
    func formattedOrderDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy, h:mm a"
        return formatter.string(from: self)
    }
}

// MARK: - Decimal Extensions

extension Decimal {
    var formattedCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return "₹" + (formatter.string(from: self as NSDecimalNumber) ?? "0")
    }
}

// MARK: - String Extensions

extension String {
    var isValidPhone: Bool {
        let phoneRegex = "^[6-9]\\d{9}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: self.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "+91", with: ""))
    }
    
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    var isValidPincode: Bool {
        let pincodeRegex = "^[1-9][0-9]{5}$"
        let pincodePredicate = NSPredicate(format: "SELF MATCHES %@", pincodeRegex)
        return pincodePredicate.evaluate(with: self)
    }
}

// MARK: - Veg/Non-Veg Indicator

struct VegIndicator: View {
    let isVeg: Bool
    var size: CGFloat = 16
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .stroke(isVeg ? Color.pipGreen : Color.pipRed, lineWidth: 1.5)
                .frame(width: size, height: size)
            
            Circle()
                .fill(isVeg ? Color.pipGreen : Color.pipRed)
                .frame(width: size * 0.5, height: size * 0.5)
        }
    }
}

// MARK: - Rating Stars View

struct RatingView: View {
    let rating: Double
    let reviewCount: Int?
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .font(.caption)
                .foregroundColor(.yellow)
            
            Text(String(format: "%.1f", rating))
                .font(.caption)
                .fontWeight(.semibold)
            
            if let count = reviewCount {
                Text("(\(count))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

// MARK: - Loading View

struct LoadingView: View {
    var message: String = "Loading..."
    
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.pipLightGray)
    }
}

// MARK: - Empty State View

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    var buttonTitle: String?
    var action: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(.pipGray)
            
            Text(title)
                .font(.headline)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            if let buttonTitle = buttonTitle, let action = action {
                Button(action: action) {
                    Text(buttonTitle)
                        .primaryButtonStyle()
                        .padding(.horizontal, 48)
                }
                .padding(.top, 8)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
