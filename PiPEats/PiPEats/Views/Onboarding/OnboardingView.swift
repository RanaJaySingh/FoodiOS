import SwiftUI
import CoreLocation

struct OnboardingView: View {
    @Environment(AppState.self) private var appState
    @State private var currentPage = 0
    @State private var showLocationPicker = false
    @State private var locationManager = LocationManager()
    
    private let onboardingPages = [
        OnboardingPage(
            icon: "fork.knife.circle.fill",
            title: "Welcome to PiP Eats",
            description: "Discover the best restaurants and cuisines in your city. From biryani to dosa, we've got it all!"
        ),
        OnboardingPage(
            icon: "clock.badge.checkmark.fill",
            title: "Fast Delivery",
            description: "Get your food delivered hot and fresh. Track your order in real-time from kitchen to doorstep."
        ),
        OnboardingPage(
            icon: "hand.thumbsup.circle.fill",
            title: "Best Prices",
            description: "Enjoy great deals and exclusive offers. Save more with every order you place."
        )
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<onboardingPages.count, id: \.self) { index in
                        OnboardingPageView(page: onboardingPages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                VStack(spacing: 24) {
                    HStack(spacing: 8) {
                        ForEach(0..<onboardingPages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? Color.pipOrange : Color.gray.opacity(0.3))
                                .frame(width: 8, height: 8)
                                .animation(.easeInOut(duration: 0.2), value: currentPage)
                        }
                    }
                    
                    VStack(spacing: 16) {
                        Button {
                            requestLocationPermission()
                        } label: {
                            HStack {
                                Image(systemName: "location.fill")
                                Text("Use Current Location")
                            }
                            .primaryButtonStyle()
                        }
                        
                        Button {
                            showLocationPicker = true
                        } label: {
                            HStack {
                                Image(systemName: "map")
                                Text("Pick Location Manually")
                            }
                            .secondaryButtonStyle()
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 40)
            }
            .background(Color.pipLightGray)
            .sheet(isPresented: $showLocationPicker) {
                LocationPickerView()
            }
        }
    }
    
    private func requestLocationPermission() {
        locationManager.requestPermission { granted in
            if granted {
                if let location = locationManager.currentLocation {
                    appState.setLocation(location)
                    completeOnboarding()
                } else {
                    showLocationPicker = true
                }
            } else {
                showLocationPicker = true
            }
        }
    }
    
    private func completeOnboarding() {
        appState.loginAsGuest()
        appState.hasCompletedOnboarding = true
    }
}

struct OnboardingPage {
    let icon: String
    let title: String
    let description: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.pipOrange.opacity(0.1))
                    .frame(width: 180, height: 180)
                
                Image(systemName: page.icon)
                    .font(.system(size: 80))
                    .foregroundColor(.pipOrange)
            }
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
            Spacer()
        }
    }
}

// MARK: - Location Manager

@Observable
final class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    var currentLocation: Location?
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    private var permissionCallback: ((Bool) -> Void)?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestPermission(completion: @escaping (Bool) -> Void) {
        permissionCallback = completion
        manager.requestWhenInUseAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
            permissionCallback?(true)
        case .denied, .restricted:
            permissionCallback?(false)
        case .notDetermined:
            break
        @unknown default:
            permissionCallback?(false)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        currentLocation = Location(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            city: "Your City",
            area: "Current Location"
        )
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
}

#Preview {
    OnboardingView()
        .environment(AppState())
}
