import SwiftUI

struct OrderStatusBadge: View {
    let status: OrderStatus
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: status.icon)
                .font(.caption2)
            Text(status.displayName)
                .font(.caption)
                .fontWeight(.medium)
        }
        .foregroundColor(foregroundColor)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(backgroundColor)
        .cornerRadius(16)
    }
    
    private var foregroundColor: Color {
        switch status {
        case .delivered:
            return .pipGreen
        case .cancelled:
            return .pipRed
        default:
            return .pipOrange
        }
    }
    
    private var backgroundColor: Color {
        foregroundColor.opacity(0.1)
    }
}

struct OrderProgressView: View {
    let status: OrderStatus
    
    private let steps: [OrderStatus] = [.placed, .confirmed, .preparing, .outForDelivery, .delivered]
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(steps.enumerated()), id: \.element) { index, step in
                HStack(alignment: .top, spacing: 16) {
                    VStack(spacing: 0) {
                        stepIndicator(for: step)
                        
                        if index < steps.count - 1 {
                            Rectangle()
                                .fill(isCompleted(step) ? Color.pipGreen : Color.gray.opacity(0.3))
                                .frame(width: 2, height: 40)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(step.displayName)
                            .font(.subheadline)
                            .fontWeight(isCurrent(step) ? .semibold : .regular)
                            .foregroundColor(isCompleted(step) || isCurrent(step) ? .primary : .secondary)
                        
                        if isCurrent(step) {
                            Text(step.statusDescription)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.top, -2)
                    
                    Spacer()
                }
            }
        }
    }
    
    private func stepIndicator(for step: OrderStatus) -> some View {
        ZStack {
            Circle()
                .fill(isCompleted(step) ? Color.pipGreen : (isCurrent(step) ? Color.pipOrange : Color.gray.opacity(0.3)))
                .frame(width: 24, height: 24)
            
            if isCompleted(step) {
                Image(systemName: "checkmark")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            } else if isCurrent(step) {
                Circle()
                    .fill(Color.white)
                    .frame(width: 8, height: 8)
            }
        }
    }
    
    private func isCompleted(_ step: OrderStatus) -> Bool {
        guard let currentIndex = steps.firstIndex(of: status),
              let stepIndex = steps.firstIndex(of: step) else { return false }
        return stepIndex < currentIndex
    }
    
    private func isCurrent(_ step: OrderStatus) -> Bool {
        return step == status
    }
}

#Preview {
    VStack(spacing: 20) {
        OrderStatusBadge(status: .preparing)
        OrderStatusBadge(status: .delivered)
        OrderStatusBadge(status: .cancelled)
        
        Divider()
        
        OrderProgressView(status: .preparing)
            .padding()
    }
    .padding()
}
