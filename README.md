# PiP Eats - iOS Food Delivery MVP

A SwiftUI-based food delivery app for the Indian market, built as a consumer-facing MVP with mock data and local persistence.

## Overview

PiP Eats is a complete iOS food delivery application featuring:
- **7 fully functional screens** covering the complete user journey
- **India-first design** with ₹ currency and Indian restaurant/menu fixtures
- **MVVM architecture** using Swift's `@Observable` pattern
- **Local persistence** using UserDefaults for cart, orders, and user data
- **Mock data service** with realistic Indian restaurant data

## Screenshots & User Flow

1. **Splash Screen** → Animated brand introduction
2. **Onboarding** → Location permission / manual city selection
3. **Home** → Browse restaurants with search and category filters
4. **Restaurant Detail** → View menu, add items to cart
5. **Cart & Checkout** → Review order, select payment method
6. **Order Confirmation** → Success animation with order details
7. **Order Tracking** → Real-time status updates (mocked)
8. **Order History** → View past and active orders
9. **Profile** → Manage profile, addresses, logout

## Requirements

- **Xcode 15.0+**
- **iOS 17.0+**
- **Swift 5.9+**

## Getting Started

### Opening the Project

1. Clone this repository
2. Open `PiPEats/PiPEats.xcodeproj` in Xcode
3. Select a simulator (iPhone 15 Pro recommended)
4. Press `Cmd + R` to build and run

### Project Structure

```
PiPEats/
├── PiPEats.xcodeproj
└── PiPEats/
    ├── App/
    │   ├── PiPEatsApp.swift        # App entry point
    │   ├── ContentView.swift        # Root navigation
    │   ├── AppState.swift           # Global app state (@Observable)
    │   └── MainTabView.swift        # Tab bar controller
    ├── Models/
    │   └── Models.swift             # All domain models
    ├── ViewModels/
    │   ├── HomeViewModel.swift
    │   ├── CartViewModel.swift
    │   └── OrderViewModel.swift
    ├── Views/
    │   ├── Splash/
    │   ├── Onboarding/
    │   ├── Home/
    │   ├── Restaurant/
    │   ├── Cart/
    │   ├── OrderTracking/
    │   ├── OrderHistory/
    │   ├── Profile/
    │   └── Components/              # Reusable UI components
    ├── Services/
    │   ├── MockDataService.swift    # Mock data fixtures
    │   └── PersistenceService.swift # UserDefaults wrapper
    ├── Extensions/
    │   └── Extensions.swift         # UI helpers & utilities
    └── Resources/
        ├── Assets.xcassets
        └── Info.plist
```

## Domain Models

| Model | Description |
|-------|-------------|
| `User` | User profile with name, email, phone, addresses |
| `Address` | Delivery address with label, full address, city, pincode |
| `Restaurant` | Restaurant with categories, rating, delivery info |
| `MenuCategory` | Menu category containing menu items |
| `MenuItem` | Food item with price, description, customizations |
| `Cart` | Shopping cart with items from one restaurant |
| `CartLine` | Single cart item with quantity and customizations |
| `Order` | Placed order with status, items, delivery info |
| `OrderStatus` | Enum: placed, confirmed, preparing, outForDelivery, delivered, cancelled |

## What's Mocked

### Data
- **Restaurants**: 10 Indian restaurants (Biryani Bliss, Dosa Delight, Punjab Da Dhaba, etc.)
- **Menu Items**: 70+ items with Indian names, ₹ prices, veg/non-veg indicators
- **Cities**: 10 major Indian cities (Delhi, Mumbai, Bengaluru, etc.)
- **Addresses**: 3 pre-populated addresses for the mock user
- **Order History**: 2 sample past orders

### Features
- **Payment**: Payment methods selectable but not processed (UPI, Card, COD, Wallet)
- **Order Tracking**: Status auto-progresses through mocked stages (5-30 second delays)
- **Location**: Manual city selection; no actual GPS-based location fetch
- **Delivery Person**: Mock name/phone shown when order is "out for delivery"

### Not Implemented (Out of Scope)
- Real payment gateway integration
- Live maps/GPS tracking
- Rider chat
- Internationalization (i18n)
- Dark mode theming
- Real backend API calls

## Key Features

### Navigation Flow
```
Splash → Onboarding (location) → Home ←→ Restaurant Detail
                                   ↓
                                 Cart → Checkout → Order Confirmation
                                   ↓
                           Order Tracking ← Order History
                                   ↓
                                Profile (logout → back to Onboarding)
```

### State Management
- **AppState**: Central `@Observable` class managing user, cart, orders, and navigation state
- **Persistence**: Cart and orders persist across app launches via UserDefaults
- **View Models**: Dedicated view models for complex screens (Home, Cart, Orders)

### UI Highlights
- Custom brand color (PiP Orange: #EB4C35)
- Veg/Non-veg indicator badges
- Animated splash screen
- Pull-to-refresh on lists
- Shimmer loading states
- Order progress stepper
- Cart floating button overlay

## Testing the Happy Path

1. **Launch** → Watch splash animation
2. **Onboarding** → Pick a city (e.g., Delhi)
3. **Home** → Browse restaurants, try search/filters
4. **Restaurant** → Tap a restaurant, add items to cart
5. **Cart** → Review items, adjust quantities
6. **Checkout** → Select address and payment method
7. **Place Order** → Watch confirmation animation
8. **Track Order** → See status auto-update (mock progression)
9. **Orders Tab** → View active and past orders
10. **Profile** → Edit profile, manage addresses, logout

## Linear Tickets Covered

| Ticket | Description | Status |
|--------|-------------|--------|
| PIP-8 | T1 Splash + onboarding (location permission / pick location) | ✅ Implemented |
| PIP-9 | T2 Home — restaurants list, search, categories | ✅ Implemented |
| PIP-10 | T3 Restaurant detail + menu | ✅ Implemented |
| PIP-11 | T4 Cart + checkout (payment mocked) | ✅ Implemented |
| PIP-12 | T5 Order confirmation + tracking (mocked statuses) | ✅ Implemented |
| PIP-13 | T6 Order history | ✅ Implemented |
| PIP-14 | T7 Profile — name, addresses, logout | ✅ Implemented |

## Notes

- The app uses iOS 17's `@Observable` macro for state management
- No third-party dependencies - pure SwiftUI implementation
- Designed for iPhone in portrait orientation
- Location permission dialog appears but actual location is not used (manual selection only)

## Build & Run

```bash
# Clone the repository
git clone https://github.com/RanaJaySingh/FoodiOS.git
cd FoodiOS

# Open in Xcode
open PiPEats/PiPEats.xcodeproj

# Or from command line (requires Xcode CLI tools)
xcodebuild -project PiPEats/PiPEats.xcodeproj -scheme PiPEats -destination 'platform=iOS Simulator,name=iPhone 15 Pro' build
```
