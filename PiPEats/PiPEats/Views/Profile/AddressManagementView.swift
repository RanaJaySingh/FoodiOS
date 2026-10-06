import SwiftUI

struct AddressManagementView: View {
    @Environment(AppState.self) private var appState
    @State private var showAddAddress = false
    @State private var editingAddress: Address?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                if let addresses = appState.currentUser?.addresses, !addresses.isEmpty {
                    ForEach(addresses) { address in
                        AddressCard(
                            address: address,
                            isDefault: address.id == appState.currentUser?.defaultAddressId,
                            onEdit: {
                                editingAddress = address
                            },
                            onDelete: {
                                deleteAddress(address)
                            },
                            onSetDefault: {
                                setDefaultAddress(address)
                            }
                        )
                    }
                } else {
                    emptyState
                }
                
                addAddressButton
            }
            .padding()
        }
        .background(Color.pipLightGray)
        .navigationTitle("Manage Addresses")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAddAddress) {
            AddEditAddressView(address: nil)
        }
        .sheet(item: $editingAddress) { address in
            AddEditAddressView(address: address)
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "mappin.slash")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("No Addresses Saved")
                .font(.headline)
            
            Text("Add your first address to make ordering easier")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 40)
    }
    
    private var addAddressButton: some View {
        Button {
            showAddAddress = true
        } label: {
            HStack {
                Image(systemName: "plus.circle.fill")
                Text("Add New Address")
                    .fontWeight(.medium)
            }
            .foregroundColor(.pipOrange)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.pipOrange.opacity(0.1))
            .cornerRadius(12)
        }
    }
    
    private func deleteAddress(_ address: Address) {
        guard var user = appState.currentUser else { return }
        user.addresses.removeAll { $0.id == address.id }
        if user.defaultAddressId == address.id {
            user.defaultAddressId = user.addresses.first?.id
        }
        appState.updateUser(user)
    }
    
    private func setDefaultAddress(_ address: Address) {
        guard var user = appState.currentUser else { return }
        user.defaultAddressId = address.id
        appState.updateUser(user)
    }
}

struct AddressCard: View {
    let address: Address
    let isDefault: Bool
    var onEdit: () -> Void
    var onDelete: () -> Void
    var onSetDefault: () -> Void
    
    @State private var showDeleteAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon(for: address.label))
                    .font(.title3)
                    .foregroundColor(.pipOrange)
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(address.label)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        if isDefault {
                            Text("Default")
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundColor(.pipGreen)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.pipGreen.opacity(0.1))
                                .cornerRadius(4)
                        }
                    }
                }
                
                Spacer()
                
                Menu {
                    Button {
                        onEdit()
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    
                    if !isDefault {
                        Button {
                            onSetDefault()
                        } label: {
                            Label("Set as Default", systemImage: "checkmark.circle")
                        }
                    }
                    
                    Button(role: .destructive) {
                        showDeleteAlert = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.gray)
                        .padding(8)
                }
            }
            
            Text(address.displayAddress)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isDefault ? Color.pipOrange.opacity(0.5) : Color.clear, lineWidth: 1)
        )
        .alert("Delete Address?", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete this address?")
        }
    }
    
    private func icon(for label: String) -> String {
        switch label.lowercased() {
        case "home": return "house.fill"
        case "work": return "building.2.fill"
        default: return "mappin.circle.fill"
        }
    }
}

struct AddEditAddressView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    
    let address: Address?
    
    @State private var label: String = ""
    @State private var fullAddress: String = ""
    @State private var landmark: String = ""
    @State private var city: String = ""
    @State private var pincode: String = ""
    @State private var selectedLabelType = "Home"
    
    private let labelTypes = ["Home", "Work", "Other"]
    
    private var isEditing: Bool {
        address != nil
    }
    
    private var isValid: Bool {
        !fullAddress.isEmpty && !city.isEmpty && pincode.isValidPincode
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Address Type") {
                    Picker("Type", selection: $selectedLabelType) {
                        ForEach(labelTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    if selectedLabelType == "Other" {
                        TextField("Label (e.g., Parent's House)", text: $label)
                    }
                }
                
                Section("Address Details") {
                    TextField("Full Address *", text: $fullAddress, axis: .vertical)
                        .lineLimit(2...4)
                    
                    TextField("Landmark (Optional)", text: $landmark)
                    
                    TextField("City *", text: $city)
                    
                    TextField("Pincode *", text: $pincode)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle(isEditing ? "Edit Address" : "Add Address")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveAddress()
                    }
                    .fontWeight(.semibold)
                    .disabled(!isValid)
                }
            }
            .onAppear {
                if let address = address {
                    label = address.label
                    fullAddress = address.fullAddress
                    landmark = address.landmark ?? ""
                    city = address.city
                    pincode = address.pincode
                    
                    if labelTypes.contains(address.label) {
                        selectedLabelType = address.label
                    } else {
                        selectedLabelType = "Other"
                        label = address.label
                    }
                }
            }
        }
    }
    
    private func saveAddress() {
        guard var user = appState.currentUser else { return }
        
        let finalLabel = selectedLabelType == "Other" ? label : selectedLabelType
        
        let newAddress = Address(
            id: address?.id ?? UUID().uuidString,
            label: finalLabel,
            fullAddress: fullAddress,
            landmark: landmark.isEmpty ? nil : landmark,
            city: city,
            pincode: pincode,
            latitude: address?.latitude,
            longitude: address?.longitude
        )
        
        if let existingIndex = user.addresses.firstIndex(where: { $0.id == newAddress.id }) {
            user.addresses[existingIndex] = newAddress
        } else {
            user.addresses.append(newAddress)
            if user.defaultAddressId == nil {
                user.defaultAddressId = newAddress.id
            }
        }
        
        appState.updateUser(user)
        dismiss()
    }
}

#Preview {
    NavigationStack {
        AddressManagementView()
    }
    .environment(AppState())
}
