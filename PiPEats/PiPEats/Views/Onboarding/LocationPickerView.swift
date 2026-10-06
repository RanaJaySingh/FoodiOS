import SwiftUI

struct LocationPickerView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var selectedLocation: Location?
    
    private let cities = MockDataService.shared.cities
    
    var filteredCities: [Location] {
        if searchText.isEmpty {
            return cities
        }
        return cities.filter {
            $0.city.lowercased().contains(searchText.lowercased()) ||
            $0.area.lowercased().contains(searchText.lowercased())
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                searchBar
                
                if filteredCities.isEmpty {
                    emptyState
                } else {
                    cityList
                }
            }
            .background(Color.pipLightGray)
            .navigationTitle("Select Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search city or area...", text: $searchText)
                .textFieldStyle(.plain)
            
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(10)
        .padding()
    }
    
    private var cityList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredCities, id: \.city) { location in
                    LocationRow(
                        location: location,
                        isSelected: selectedLocation?.city == location.city
                    ) {
                        selectLocation(location)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 100)
        }
        .overlay(alignment: .bottom) {
            if selectedLocation != nil {
                confirmButton
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "map")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("No locations found")
                .font(.headline)
            
            Text("Try searching for a different city")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var confirmButton: some View {
        Button {
            confirmSelection()
        } label: {
            Text("Confirm Location")
                .primaryButtonStyle()
        }
        .padding()
        .background(
            LinearGradient(
                colors: [.clear, .white, .white],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
    
    private func selectLocation(_ location: Location) {
        withAnimation {
            selectedLocation = location
        }
    }
    
    private func confirmSelection() {
        guard let location = selectedLocation else { return }
        appState.setLocation(location)
        appState.loginAsGuest()
        appState.hasCompletedOnboarding = true
        dismiss()
    }
}

struct LocationRow: View {
    let location: Location
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.pipOrange : Color.pipOrange.opacity(0.1))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: "mappin.circle.fill")
                        .font(.title2)
                        .foregroundColor(isSelected ? .white : .pipOrange)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(location.city)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(location.area)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.pipOrange)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.pipOrange : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    LocationPickerView()
        .environment(AppState())
}
