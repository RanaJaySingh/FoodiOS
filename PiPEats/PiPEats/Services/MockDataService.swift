import Foundation

final class MockDataService {
    static let shared = MockDataService()
    
    private init() {}
    
    // MARK: - Mock Cities
    
    let cities = [
        Location(latitude: 28.6139, longitude: 77.2090, city: "Delhi", area: "Connaught Place"),
        Location(latitude: 19.0760, longitude: 72.8777, city: "Mumbai", area: "Bandra West"),
        Location(latitude: 12.9716, longitude: 77.5946, city: "Bengaluru", area: "Koramangala"),
        Location(latitude: 17.3850, longitude: 78.4867, city: "Hyderabad", area: "Jubilee Hills"),
        Location(latitude: 13.0827, longitude: 80.2707, city: "Chennai", area: "T. Nagar"),
        Location(latitude: 22.5726, longitude: 88.3639, city: "Kolkata", area: "Park Street"),
        Location(latitude: 18.5204, longitude: 73.8567, city: "Pune", area: "Koregaon Park"),
        Location(latitude: 23.0225, longitude: 72.5714, city: "Ahmedabad", area: "Vastrapur"),
        Location(latitude: 26.9124, longitude: 75.7873, city: "Jaipur", area: "C-Scheme"),
        Location(latitude: 30.7333, longitude: 76.7794, city: "Chandigarh", area: "Sector 17")
    ]
    
    // MARK: - Mock User
    
    var mockUser: User {
        User(
            id: "user_001",
            name: "Rahul Sharma",
            email: "rahul.sharma@email.com",
            phone: "+91 98765 43210",
            addresses: mockAddresses,
            defaultAddressId: "addr_001"
        )
    }
    
    var mockAddresses: [Address] {
        [
            Address(
                id: "addr_001",
                label: "Home",
                fullAddress: "B-42, Sector 62, Near Metro Station",
                landmark: "Opposite City Mall",
                city: "Noida",
                pincode: "201301",
                latitude: 28.6270,
                longitude: 77.3740
            ),
            Address(
                id: "addr_002",
                label: "Work",
                fullAddress: "Tower C, 5th Floor, Cyber City",
                landmark: "DLF Phase 2",
                city: "Gurugram",
                pincode: "122002",
                latitude: 28.4950,
                longitude: 77.0895
            ),
            Address(
                id: "addr_003",
                label: "Other",
                fullAddress: "A-15, Green Park Extension",
                landmark: "Near Hauz Khas Metro",
                city: "New Delhi",
                pincode: "110016",
                latitude: 28.5494,
                longitude: 77.2001
            )
        ]
    }
    
    // MARK: - Mock Restaurants
    
    var restaurants: [Restaurant] {
        [
            biryaniBliss,
            dosaDelight,
            punjabDhaba,
            wokExpress,
            pizzaParadise,
            burgerBarn,
            sweetTreats,
            chaatCorner,
            thaliTreasures,
            chaiPoint
        ]
    }
    
    var biryaniBliss: Restaurant {
        Restaurant(
            id: "rest_001",
            name: "Biryani Bliss",
            cuisines: ["Biryani", "Mughlai", "North Indian"],
            rating: 4.5,
            reviewCount: 2340,
            deliveryTimeMinutes: 35,
            deliveryFee: 30,
            minimumOrder: 199,
            imageURL: nil,
            isVeg: false,
            isPureVeg: false,
            address: "Shop 12, Khan Market, New Delhi",
            categories: [
                MenuCategory(id: "cat_001", name: "Bestsellers", items: [
                    MenuItem(id: "item_001", name: "Hyderabadi Chicken Dum Biryani", description: "Aromatic basmati rice layered with tender chicken pieces, slow-cooked with authentic spices", price: 349, imageURL: nil, isVeg: false, isSpicy: true, isBestseller: true, customizations: [
                        MenuCustomization(id: "cust_001", name: "Portion Size", options: [
                            CustomizationOption(id: "opt_001", name: "Regular", additionalPrice: 0),
                            CustomizationOption(id: "opt_002", name: "Large", additionalPrice: 100)
                        ], isRequired: true, maxSelections: 1)
                    ]),
                    MenuItem(id: "item_002", name: "Mutton Biryani", description: "Premium mutton pieces with fragrant rice and whole spices", price: 449, imageURL: nil, isVeg: false, isSpicy: true, isBestseller: true, customizations: nil)
                ]),
                MenuCategory(id: "cat_002", name: "Veg Biryani", items: [
                    MenuItem(id: "item_003", name: "Vegetable Dum Biryani", description: "Garden fresh vegetables with saffron-infused basmati rice", price: 249, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: false, customizations: nil),
                    MenuItem(id: "item_004", name: "Paneer Biryani", description: "Soft paneer cubes with aromatic rice and mint", price: 299, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: false, customizations: nil)
                ]),
                MenuCategory(id: "cat_003", name: "Accompaniments", items: [
                    MenuItem(id: "item_005", name: "Raita", description: "Cool yogurt with cucumber and mint", price: 49, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: false, customizations: nil),
                    MenuItem(id: "item_006", name: "Mirchi Ka Salan", description: "Spicy curry with green chilies and peanuts", price: 99, imageURL: nil, isVeg: true, isSpicy: true, isBestseller: false, customizations: nil)
                ])
            ]
        )
    }
    
    var dosaDelight: Restaurant {
        Restaurant(
            id: "rest_002",
            name: "Dosa Delight",
            cuisines: ["South Indian", "Breakfast"],
            rating: 4.3,
            reviewCount: 1890,
            deliveryTimeMinutes: 25,
            deliveryFee: 20,
            minimumOrder: 149,
            imageURL: nil,
            isVeg: true,
            isPureVeg: true,
            address: "45, Indiranagar, Bengaluru",
            categories: [
                MenuCategory(id: "cat_004", name: "Dosas", items: [
                    MenuItem(id: "item_007", name: "Masala Dosa", description: "Crispy crepe with spiced potato filling, served with sambar and chutneys", price: 129, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: true, customizations: nil),
                    MenuItem(id: "item_008", name: "Mysore Masala Dosa", description: "Crispy dosa with spicy red chutney spread and potato masala", price: 149, imageURL: nil, isVeg: true, isSpicy: true, isBestseller: true, customizations: nil),
                    MenuItem(id: "item_009", name: "Rava Dosa", description: "Crispy semolina dosa with herbs", price: 119, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: false, customizations: nil),
                    MenuItem(id: "item_010", name: "Paper Dosa", description: "Extra thin and crispy plain dosa", price: 99, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: false, customizations: nil)
                ]),
                MenuCategory(id: "cat_005", name: "Idli & Vada", items: [
                    MenuItem(id: "item_011", name: "Idli (4 pcs)", description: "Steamed rice cakes served with sambar and chutneys", price: 79, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: false, customizations: nil),
                    MenuItem(id: "item_012", name: "Medu Vada (2 pcs)", description: "Crispy urad dal fritters", price: 89, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: false, customizations: nil)
                ]),
                MenuCategory(id: "cat_006", name: "Uttapam", items: [
                    MenuItem(id: "item_013", name: "Onion Uttapam", description: "Thick rice pancake topped with onions", price: 109, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: false, customizations: nil),
                    MenuItem(id: "item_014", name: "Mixed Vegetable Uttapam", description: "Topped with onions, tomatoes, and capsicum", price: 129, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: false, customizations: nil)
                ])
            ]
        )
    }
    
    var punjabDhaba: Restaurant {
        Restaurant(
            id: "rest_003",
            name: "Punjab Da Dhaba",
            cuisines: ["North Indian", "Punjabi", "Mughlai"],
            rating: 4.4,
            reviewCount: 3200,
            deliveryTimeMinutes: 40,
            deliveryFee: 25,
            minimumOrder: 249,
            imageURL: nil,
            isVeg: false,
            isPureVeg: false,
            address: "Near Cyber Hub, Gurugram",
            categories: [
                MenuCategory(id: "cat_007", name: "Tandoori Starters", items: [
                    MenuItem(id: "item_015", name: "Tandoori Chicken (Half)", description: "Classic clay oven roasted chicken with spices", price: 299, imageURL: nil, isVeg: false, isSpicy: true, isBestseller: true, customizations: nil),
                    MenuItem(id: "item_016", name: "Paneer Tikka", description: "Marinated cottage cheese grilled to perfection", price: 249, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: true, customizations: nil),
                    MenuItem(id: "item_017", name: "Seekh Kebab", description: "Minced lamb kebabs with aromatic spices", price: 349, imageURL: nil, isVeg: false, isSpicy: true, isBestseller: false, customizations: nil)
                ]),
                MenuCategory(id: "cat_008", name: "Main Course", items: [
                    MenuItem(id: "item_018", name: "Butter Chicken", description: "Tender chicken in rich tomato-cream gravy", price: 349, imageURL: nil, isVeg: false, isSpicy: false, isBestseller: true, customizations: nil),
                    MenuItem(id: "item_019", name: "Dal Makhani", description: "Black lentils slow-cooked with butter and cream", price: 229, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: true, customizations: nil),
                    MenuItem(id: "item_020", name: "Palak Paneer", description: "Cottage cheese in creamy spinach gravy", price: 249, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: false, customizations: nil),
                    MenuItem(id: "item_021", name: "Kadhai Chicken", description: "Spicy chicken curry with bell peppers", price: 329, imageURL: nil, isVeg: false, isSpicy: true, isBestseller: false, customizations: nil)
                ]),
                MenuCategory(id: "cat_009", name: "Breads", items: [
                    MenuItem(id: "item_022", name: "Butter Naan", description: "Soft leavened bread with butter", price: 49, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: false, customizations: nil),
                    MenuItem(id: "item_023", name: "Garlic Naan", description: "Naan topped with garlic and coriander", price: 59, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: false, customizations: nil),
                    MenuItem(id: "item_024", name: "Laccha Paratha", description: "Layered flaky bread", price: 49, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: false, customizations: nil)
                ])
            ]
        )
    }
    
    var wokExpress: Restaurant {
        Restaurant(
            id: "rest_004",
            name: "Wok Express",
            cuisines: ["Chinese", "Thai", "Asian"],
            rating: 4.1,
            reviewCount: 1560,
            deliveryTimeMinutes: 30,
            deliveryFee: 35,
            minimumOrder: 199,
            imageURL: nil,
            isVeg: false,
            isPureVeg: false,
            address: "Phoenix Mall, Lower Parel, Mumbai",
            categories: [
                MenuCategory(id: "cat_010", name: "Starters", items: [
                    MenuItem(id: "item_025", name: "Chicken Momos (8 pcs)", description: "Steamed dumplings with spicy red chutney", price: 189, imageURL: nil, isVeg: false, isSpicy: false, isBestseller: true, customizations: [
                        MenuCustomization(id: "cust_002", name: "Style", options: [
                            CustomizationOption(id: "opt_003", name: "Steamed", additionalPrice: 0),
                            CustomizationOption(id: "opt_004", name: "Fried", additionalPrice: 20),
                            CustomizationOption(id: "opt_005", name: "Tandoori", additionalPrice: 40)
                        ], isRequired: true, maxSelections: 1)
                    ]),
                    MenuItem(id: "item_026", name: "Veg Spring Rolls", description: "Crispy rolls with vegetable filling", price: 149, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: false, customizations: nil),
                    MenuItem(id: "item_027", name: "Chilli Chicken", description: "Spicy Indo-Chinese chicken preparation", price: 269, imageURL: nil, isVeg: false, isSpicy: true, isBestseller: true, customizations: nil)
                ]),
                MenuCategory(id: "cat_011", name: "Noodles & Rice", items: [
                    MenuItem(id: "item_028", name: "Hakka Noodles", description: "Stir-fried noodles with vegetables", price: 189, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: false, customizations: [
                        MenuCustomization(id: "cust_003", name: "Add Protein", options: [
                            CustomizationOption(id: "opt_006", name: "No protein", additionalPrice: 0),
                            CustomizationOption(id: "opt_007", name: "Chicken", additionalPrice: 60),
                            CustomizationOption(id: "opt_008", name: "Egg", additionalPrice: 30)
                        ], isRequired: false, maxSelections: 1)
                    ]),
                    MenuItem(id: "item_029", name: "Schezwan Fried Rice", description: "Spicy fried rice with Schezwan sauce", price: 199, imageURL: nil, isVeg: true, isSpicy: true, isBestseller: true, customizations: nil),
                    MenuItem(id: "item_030", name: "Thai Basil Rice", description: "Fragrant rice with basil and Thai spices", price: 229, imageURL: nil, isVeg: true, isSpicy: true, isBestseller: false, customizations: nil)
                ]),
                MenuCategory(id: "cat_012", name: "Main Course", items: [
                    MenuItem(id: "item_031", name: "Kung Pao Chicken", description: "Spicy chicken with peanuts and dried chilies", price: 329, imageURL: nil, isVeg: false, isSpicy: true, isBestseller: false, customizations: nil),
                    MenuItem(id: "item_032", name: "Thai Green Curry", description: "Vegetables in aromatic green curry", price: 279, imageURL: nil, isVeg: true, isSpicy: true, isBestseller: false, customizations: nil)
                ])
            ]
        )
    }
    
    var pizzaParadise: Restaurant {
        Restaurant(
            id: "rest_005",
            name: "Pizza Paradise",
            cuisines: ["Pizza", "Italian", "Fast Food"],
            rating: 4.2,
            reviewCount: 2890,
            deliveryTimeMinutes: 35,
            deliveryFee: 0,
            minimumOrder: 299,
            imageURL: nil,
            isVeg: false,
            isPureVeg: false,
            address: "Linking Road, Bandra, Mumbai",
            categories: [
                MenuCategory(id: "cat_013", name: "Pizzas", items: [
                    MenuItem(id: "item_033", name: "Margherita", description: "Classic tomato sauce with mozzarella and basil", price: 249, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: true, customizations: [
                        MenuCustomization(id: "cust_004", name: "Size", options: [
                            CustomizationOption(id: "opt_009", name: "Medium (8\")", additionalPrice: 0),
                            CustomizationOption(id: "opt_010", name: "Large (12\")", additionalPrice: 150)
                        ], isRequired: true, maxSelections: 1),
                        MenuCustomization(id: "cust_005", name: "Crust", options: [
                            CustomizationOption(id: "opt_011", name: "Classic", additionalPrice: 0),
                            CustomizationOption(id: "opt_012", name: "Thin Crust", additionalPrice: 0),
                            CustomizationOption(id: "opt_013", name: "Cheese Burst", additionalPrice: 100)
                        ], isRequired: true, maxSelections: 1)
                    ]),
                    MenuItem(id: "item_034", name: "Pepperoni Supreme", description: "Loaded with pepperoni and extra cheese", price: 399, imageURL: nil, isVeg: false, isSpicy: false, isBestseller: true, customizations: nil),
                    MenuItem(id: "item_035", name: "Paneer Tikka Pizza", description: "Indian fusion with tandoori paneer", price: 349, imageURL: nil, isVeg: true, isSpicy: true, isBestseller: false, customizations: nil),
                    MenuItem(id: "item_036", name: "BBQ Chicken", description: "Grilled chicken with BBQ sauce", price: 429, imageURL: nil, isVeg: false, isSpicy: false, isBestseller: false, customizations: nil)
                ]),
                MenuCategory(id: "cat_014", name: "Sides", items: [
                    MenuItem(id: "item_037", name: "Garlic Bread", description: "Toasted bread with garlic butter", price: 129, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: false, customizations: nil),
                    MenuItem(id: "item_038", name: "Cheesy Dip Sticks", description: "Breadsticks with cheese dip", price: 149, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: false, customizations: nil)
                ])
            ]
        )
    }
    
    var burgerBarn: Restaurant {
        Restaurant(
            id: "rest_006",
            name: "Burger Barn",
            cuisines: ["Burgers", "American", "Fast Food"],
            rating: 4.0,
            reviewCount: 1230,
            deliveryTimeMinutes: 25,
            deliveryFee: 25,
            minimumOrder: 149,
            imageURL: nil,
            isVeg: false,
            isPureVeg: false,
            address: "Connaught Place, New Delhi",
            categories: [
                MenuCategory(id: "cat_015", name: "Burgers", items: [
                    MenuItem(id: "item_039", name: "Classic Chicken Burger", description: "Crispy chicken patty with lettuce and mayo", price: 179, imageURL: nil, isVeg: false, isSpicy: false, isBestseller: true, customizations: nil),
                    MenuItem(id: "item_040", name: "Aloo Tikki Burger", description: "Spiced potato patty with chutneys", price: 129, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: true, customizations: nil),
                    MenuItem(id: "item_041", name: "Double Decker", description: "Two patties with cheese and special sauce", price: 249, imageURL: nil, isVeg: false, isSpicy: false, isBestseller: false, customizations: nil),
                    MenuItem(id: "item_042", name: "Paneer Royale", description: "Grilled paneer with tandoori mayo", price: 169, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: false, customizations: nil)
                ]),
                MenuCategory(id: "cat_016", name: "Sides & Beverages", items: [
                    MenuItem(id: "item_043", name: "French Fries", description: "Crispy golden fries", price: 99, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: false, customizations: nil),
                    MenuItem(id: "item_044", name: "Onion Rings", description: "Crispy battered onion rings", price: 119, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: false, customizations: nil),
                    MenuItem(id: "item_045", name: "Cold Coffee", description: "Chilled coffee with ice cream", price: 129, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: false, customizations: nil)
                ])
            ]
        )
    }
    
    var sweetTreats: Restaurant {
        Restaurant(
            id: "rest_007",
            name: "Sweet Treats",
            cuisines: ["Desserts", "Ice Cream", "Bakery"],
            rating: 4.6,
            reviewCount: 980,
            deliveryTimeMinutes: 30,
            deliveryFee: 40,
            minimumOrder: 199,
            imageURL: nil,
            isVeg: true,
            isPureVeg: true,
            address: "Jubilee Hills, Hyderabad",
            categories: [
                MenuCategory(id: "cat_017", name: "Indian Sweets", items: [
                    MenuItem(id: "item_046", name: "Gulab Jamun (4 pcs)", description: "Soft milk solids dumplings in sugar syrup", price: 129, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: true, customizations: nil),
                    MenuItem(id: "item_047", name: "Rasmalai (2 pcs)", description: "Soft cheese patties in saffron milk", price: 149, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: true, customizations: nil),
                    MenuItem(id: "item_048", name: "Gajar Ka Halwa", description: "Traditional carrot dessert with nuts", price: 169, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: false, customizations: nil)
                ]),
                MenuCategory(id: "cat_018", name: "Ice Cream & Sundaes", items: [
                    MenuItem(id: "item_049", name: "Kulfi (2 sticks)", description: "Traditional Indian ice cream", price: 99, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: false, customizations: nil),
                    MenuItem(id: "item_050", name: "Brownie Sundae", description: "Warm brownie with vanilla ice cream", price: 199, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: false, customizations: nil)
                ]),
                MenuCategory(id: "cat_019", name: "Cakes", items: [
                    MenuItem(id: "item_051", name: "Chocolate Truffle Slice", description: "Rich chocolate cake with ganache", price: 149, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: false, customizations: nil),
                    MenuItem(id: "item_052", name: "Red Velvet Slice", description: "Classic red velvet with cream cheese", price: 169, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: false, customizations: nil)
                ])
            ]
        )
    }
    
    var chaatCorner: Restaurant {
        Restaurant(
            id: "rest_008",
            name: "Chaat Corner",
            cuisines: ["Street Food", "Chaat", "Snacks"],
            rating: 4.3,
            reviewCount: 1450,
            deliveryTimeMinutes: 20,
            deliveryFee: 15,
            minimumOrder: 99,
            imageURL: nil,
            isVeg: true,
            isPureVeg: true,
            address: "Chandni Chowk, Old Delhi",
            categories: [
                MenuCategory(id: "cat_020", name: "Chaat", items: [
                    MenuItem(id: "item_053", name: "Pani Puri (6 pcs)", description: "Crispy puris with spicy water and fillings", price: 69, imageURL: nil, isVeg: true, isSpicy: true, isBestseller: true, customizations: nil),
                    MenuItem(id: "item_054", name: "Bhel Puri", description: "Puffed rice with chutneys and vegetables", price: 79, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: true, customizations: nil),
                    MenuItem(id: "item_055", name: "Papdi Chaat", description: "Crispy wafers with yogurt and chutneys", price: 99, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: false, customizations: nil),
                    MenuItem(id: "item_056", name: "Aloo Tikki Chaat", description: "Potato patties with toppings and chutneys", price: 109, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: false, customizations: nil),
                    MenuItem(id: "item_057", name: "Dahi Bhalla", description: "Lentil dumplings in yogurt", price: 99, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: false, customizations: nil)
                ]),
                MenuCategory(id: "cat_021", name: "Samosas & Kachori", items: [
                    MenuItem(id: "item_058", name: "Samosa (2 pcs)", description: "Crispy pastry with spiced potato filling", price: 49, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: true, customizations: nil),
                    MenuItem(id: "item_059", name: "Kachori (2 pcs)", description: "Flaky pastry with dal filling", price: 59, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: false, customizations: nil)
                ])
            ]
        )
    }
    
    var thaliTreasures: Restaurant {
        Restaurant(
            id: "rest_009",
            name: "Thali Treasures",
            cuisines: ["Thali", "Gujarati", "Rajasthani"],
            rating: 4.4,
            reviewCount: 1120,
            deliveryTimeMinutes: 45,
            deliveryFee: 30,
            minimumOrder: 299,
            imageURL: nil,
            isVeg: true,
            isPureVeg: true,
            address: "C.G. Road, Ahmedabad",
            categories: [
                MenuCategory(id: "cat_022", name: "Thalis", items: [
                    MenuItem(id: "item_060", name: "Gujarati Thali", description: "Complete meal with dal, sabzi, roti, rice, sweet, and accompaniments", price: 349, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: true, customizations: nil),
                    MenuItem(id: "item_061", name: "Rajasthani Thali", description: "Dal baati churma with traditional accompaniments", price: 379, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: true, customizations: nil),
                    MenuItem(id: "item_062", name: "Mini Thali", description: "Smaller portion perfect for one", price: 249, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: false, customizations: nil)
                ]),
                MenuCategory(id: "cat_023", name: "À La Carte", items: [
                    MenuItem(id: "item_063", name: "Undhiyu", description: "Mixed vegetable curry, Gujarati specialty", price: 199, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: false, customizations: nil),
                    MenuItem(id: "item_064", name: "Dal Baati", description: "Baked wheat balls with lentil curry", price: 179, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: false, customizations: nil),
                    MenuItem(id: "item_065", name: "Kadhi", description: "Yogurt-based curry with pakodas", price: 149, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: false, customizations: nil)
                ])
            ]
        )
    }
    
    var chaiPoint: Restaurant {
        Restaurant(
            id: "rest_010",
            name: "Chai Point",
            cuisines: ["Beverages", "Tea", "Snacks"],
            rating: 4.2,
            reviewCount: 2100,
            deliveryTimeMinutes: 20,
            deliveryFee: 20,
            minimumOrder: 99,
            imageURL: nil,
            isVeg: true,
            isPureVeg: true,
            address: "MG Road, Bengaluru",
            categories: [
                MenuCategory(id: "cat_024", name: "Chai", items: [
                    MenuItem(id: "item_066", name: "Masala Chai", description: "Traditional spiced Indian tea", price: 49, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: true, customizations: [
                        MenuCustomization(id: "cust_006", name: "Size", options: [
                            CustomizationOption(id: "opt_014", name: "Regular", additionalPrice: 0),
                            CustomizationOption(id: "opt_015", name: "Large", additionalPrice: 20)
                        ], isRequired: true, maxSelections: 1)
                    ]),
                    MenuItem(id: "item_067", name: "Ginger Tea", description: "Fresh ginger-infused tea", price: 49, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: false, customizations: nil),
                    MenuItem(id: "item_068", name: "Cutting Chai", description: "Mumbai-style small tea", price: 29, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: true, customizations: nil),
                    MenuItem(id: "item_069", name: "Kulhad Chai", description: "Tea served in earthen cup", price: 59, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: false, customizations: nil)
                ]),
                MenuCategory(id: "cat_025", name: "Snacks", items: [
                    MenuItem(id: "item_070", name: "Bun Maska", description: "Buttered bun, perfect with chai", price: 49, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: true, customizations: nil),
                    MenuItem(id: "item_071", name: "Vada Pav", description: "Mumbai's iconic potato fritter burger", price: 59, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: true, customizations: nil),
                    MenuItem(id: "item_072", name: "Bread Pakoda", description: "Spiced bread fritters", price: 69, imageURL: nil, isVeg: true, isSpicy: false, isBestseller: false, customizations: nil)
                ])
            ]
        )
    }
    
    // MARK: - Helper Methods
    
    func getRestaurant(by id: String) -> Restaurant? {
        restaurants.first { $0.id == id }
    }
    
    func filterRestaurants(by category: FoodCategory, searchQuery: String = "") -> [Restaurant] {
        var filtered = restaurants
        
        if category != .all {
            filtered = filtered.filter { restaurant in
                restaurant.cuisines.contains { cuisine in
                    cuisine.lowercased().contains(category.rawValue.lowercased())
                }
            }
        }
        
        if !searchQuery.isEmpty {
            let query = searchQuery.lowercased()
            filtered = filtered.filter { restaurant in
                restaurant.name.lowercased().contains(query) ||
                restaurant.cuisines.joined().lowercased().contains(query) ||
                restaurant.categories.flatMap { $0.items }.contains { $0.name.lowercased().contains(query) }
            }
        }
        
        return filtered
    }
    
    // MARK: - Mock Order History
    
    func createMockOrderHistory() -> [Order] {
        let now = Date()
        let calendar = Calendar.current
        
        return [
            Order(
                id: "order_001",
                orderNumber: "PIP2024100501",
                restaurantId: "rest_001",
                restaurantName: "Biryani Bliss",
                items: [
                    CartLine(id: "cl_001", menuItemId: "item_001", name: "Hyderabadi Chicken Dum Biryani", price: 349, quantity: 2, isVeg: false, customizations: []),
                    CartLine(id: "cl_002", menuItemId: "item_005", name: "Raita", price: 49, quantity: 2, isVeg: true, customizations: [])
                ],
                deliveryAddress: mockAddresses[0],
                status: .delivered,
                subtotal: 796,
                deliveryFee: 30,
                taxes: 48,
                total: 874,
                paymentMethod: "UPI",
                createdAt: calendar.date(byAdding: .day, value: -2, to: now)!,
                updatedAt: calendar.date(byAdding: .day, value: -2, to: now)!,
                estimatedDeliveryTime: nil,
                deliveryPersonName: "Ravi Kumar",
                deliveryPersonPhone: "+91 98765 12345"
            ),
            Order(
                id: "order_002",
                orderNumber: "PIP2024100302",
                restaurantId: "rest_002",
                restaurantName: "Dosa Delight",
                items: [
                    CartLine(id: "cl_003", menuItemId: "item_007", name: "Masala Dosa", price: 129, quantity: 2, isVeg: true, customizations: []),
                    CartLine(id: "cl_004", menuItemId: "item_011", name: "Idli (4 pcs)", price: 79, quantity: 1, isVeg: true, customizations: [])
                ],
                deliveryAddress: mockAddresses[1],
                status: .delivered,
                subtotal: 337,
                deliveryFee: 20,
                taxes: 20,
                total: 377,
                paymentMethod: "Card",
                createdAt: calendar.date(byAdding: .day, value: -5, to: now)!,
                updatedAt: calendar.date(byAdding: .day, value: -5, to: now)!,
                estimatedDeliveryTime: nil,
                deliveryPersonName: nil,
                deliveryPersonPhone: nil
            )
        ]
    }
}
