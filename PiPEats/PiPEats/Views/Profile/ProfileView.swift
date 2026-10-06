import SwiftUI

struct ProfileView: View {
    @Environment(AppState.self) private var appState
    @State private var showLogoutAlert = false
    @State private var showEditProfile = false
    @State private var showAddresses = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    profileHeader
                    accountSection
                    preferencesSection
                    supportSection
                    logoutButton
                    appVersion
                }
                .padding()
            }
            .background(Color.pipLightGray)
            .navigationTitle("Profile")
            .sheet(isPresented: $showEditProfile) {
                EditProfileView()
            }
            .navigationDestination(isPresented: $showAddresses) {
                AddressManagementView()
            }
            .alert("Logout", isPresented: $showLogoutAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Logout", role: .destructive) {
                    appState.logout()
                }
            } message: {
                Text("Are you sure you want to logout?")
            }
        }
    }
    
    private var profileHeader: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.pipOrange.opacity(0.1))
                    .frame(width: 70, height: 70)
                
                Text(initials)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.pipOrange)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(appState.currentUser?.name ?? "Guest User")
                    .font(.headline)
                
                if let email = appState.currentUser?.email, !email.isEmpty {
                    Text(email)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if let phone = appState.currentUser?.phone, !phone.isEmpty {
                    Text(phone)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Button {
                showEditProfile = true
            } label: {
                Image(systemName: "pencil.circle.fill")
                    .font(.title2)
                    .foregroundColor(.pipOrange)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
    
    private var accountSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Account")
                .font(.headline)
                .padding(.horizontal)
                .padding(.bottom, 8)
            
            VStack(spacing: 0) {
                ProfileMenuItem(
                    icon: "mappin.circle.fill",
                    title: "Manage Addresses",
                    subtitle: "\(appState.currentUser?.addresses.count ?? 0) saved addresses"
                ) {
                    showAddresses = true
                }
                
                Divider().padding(.leading, 52)
                
                ProfileMenuItem(
                    icon: "creditcard.fill",
                    title: "Payment Methods",
                    subtitle: "Add/manage payment options"
                ) {
                    // Payment methods
                }
                
                Divider().padding(.leading, 52)
                
                ProfileMenuItem(
                    icon: "heart.fill",
                    title: "Favorites",
                    subtitle: "Your favorite restaurants"
                ) {
                    // Favorites
                }
            }
            .background(Color.white)
            .cornerRadius(12)
        }
    }
    
    private var preferencesSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Preferences")
                .font(.headline)
                .padding(.horizontal)
                .padding(.bottom, 8)
            
            VStack(spacing: 0) {
                ProfileMenuItem(
                    icon: "bell.fill",
                    title: "Notifications",
                    subtitle: "Manage notification preferences"
                ) {
                    // Notifications
                }
                
                Divider().padding(.leading, 52)
                
                ProfileMenuItem(
                    icon: "globe",
                    title: "Language",
                    subtitle: "English"
                ) {
                    // Language
                }
            }
            .background(Color.white)
            .cornerRadius(12)
        }
    }
    
    private var supportSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Support")
                .font(.headline)
                .padding(.horizontal)
                .padding(.bottom, 8)
            
            VStack(spacing: 0) {
                ProfileMenuItem(
                    icon: "questionmark.circle.fill",
                    title: "Help & Support",
                    subtitle: "FAQs, contact support"
                ) {
                    // Help
                }
                
                Divider().padding(.leading, 52)
                
                ProfileMenuItem(
                    icon: "doc.text.fill",
                    title: "Terms & Conditions",
                    subtitle: nil
                ) {
                    // Terms
                }
                
                Divider().padding(.leading, 52)
                
                ProfileMenuItem(
                    icon: "hand.raised.fill",
                    title: "Privacy Policy",
                    subtitle: nil
                ) {
                    // Privacy
                }
            }
            .background(Color.white)
            .cornerRadius(12)
        }
    }
    
    private var logoutButton: some View {
        Button {
            showLogoutAlert = true
        } label: {
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                Text("Logout")
                    .fontWeight(.medium)
            }
            .foregroundColor(.pipRed)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .cornerRadius(12)
        }
    }
    
    private var appVersion: some View {
        VStack(spacing: 4) {
            Text("PiP Eats")
                .font(.caption)
                .fontWeight(.medium)
            Text("Version 1.0.0")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.top, 8)
    }
    
    private var initials: String {
        guard let name = appState.currentUser?.name else { return "?" }
        let components = name.split(separator: " ")
        let initials = components.prefix(2).compactMap { $0.first }.map { String($0) }
        return initials.joined().uppercased()
    }
}

struct ProfileMenuItem: View {
    let icon: String
    let title: String
    let subtitle: String?
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.pipOrange)
                    .frame(width: 32)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()
        }
    }
}

struct EditProfileView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Personal Information") {
                    TextField("Full Name", text: $name)
                        .textContentType(.name)
                    
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    TextField("Phone", text: $phone)
                        .textContentType(.telephoneNumber)
                        .keyboardType(.phonePad)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveProfile()
                    }
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                if let user = appState.currentUser {
                    name = user.name
                    email = user.email
                    phone = user.phone
                }
            }
        }
    }
    
    private func saveProfile() {
        guard var user = appState.currentUser else { return }
        user.name = name
        user.email = email
        user.phone = phone
        appState.updateUser(user)
        dismiss()
    }
}

#Preview {
    ProfileView()
        .environment(AppState())
}
