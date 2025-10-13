# 🔄 TrackLet Pro - Step-by-Step Migration Guide

## 🎯 Purpose
This guide helps you migrate from the old flat structure to the new organized view_model structure.

---

## 📋 Table of Contents
1. [Understanding the New Structure](#understanding-the-new-structure)
2. [Migrating Providers](#migrating-providers)
3. [Converting Icons to SVG](#converting-icons-to-svg)
4. [Replacing Images with NetworkImage](#replacing-images-with-networkimage)
5. [Applying Consistent Theming](#applying-consistent-theming)
6. [Common Migration Patterns](#common-migration-patterns)

---

## 1. Understanding the New Structure

### Provider vs ViewModel

**Provider** (State Management Only):
- Holds UI state (lists, flags, selections)
- Extends `ChangeNotifier`
- Calls `notifyListeners()` when state changes
- No network calls or business logic

**ViewModel** (Business Logic & Data):
- Handles network operations
- Processes business logic
- Calls services
- Returns data to providers

### Example:
```dart
// ❌ Old way: Everything in one file
class OrdersProvider extends ChangeNotifier {
  List<Order> _orders = [];
  bool _isLoading = false;
  
  Future<void> fetchOrders() async {
    _isLoading = true;
    notifyListeners();
    
    // Network call mixed with state management ❌
    final response = await dio.get('/api/orders');
    _orders = parseOrders(response.data);
    
    _isLoading = false;
    notifyListeners();
  }
}

// ✅ New way: Separated concerns
// File: order_provider.dart
class OrderProvider extends ChangeNotifier {
  List<Order> _orders = [];
  bool _isLoading = false;
  
  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  
  void updateOrders(List<Order> orders) {
    _orders = orders;
    notifyListeners();
  }
  
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}

// File: order_view_model.dart
class OrderViewModel extends ChangeNotifier {
  final OrderService _orderService = OrderService();
  
  Future<List<Order>> fetchOrders(String plantId) async {
    try {
      return await _orderService.getPlantOrders(plantId);
    } catch (e) {
      debugPrint('Error: $e');
      return [];
    }
  }
}
```

---

## 2. Migrating Providers

### Step 1: Identify Module Type
Determine if the provider belongs to:
- `gas_plant/` - Gas Plant specific features
- `distributor/` - Distributor specific features
- `shared/` - Common features used by both

### Step 2: Create Provider File
Place in appropriate folder:
```
lib/src/view_model/
├── gas_plant/
│   ├── home/
│   │   └── gas_home_provider.dart
│   ├── orders/
│   │   └── order_provider.dart
│   └── stock/
│       └── stock_provider.dart
├── distributor/
│   ├── home/
│   │   └── distributor_home_provider.dart
│   └── orders/
│       └── distributor_order_provider.dart
└── shared/
    └── notification_provider.dart
```

### Step 3: Extract Business Logic
Move network calls and business logic to corresponding view_model:
```dart
// gas_plant/home/gas_home_view_model.dart
class GasHomeViewModel extends ChangeNotifier {
  final TankService _tankService = TankService();
  
  Future<List<DashboardSummary>> loadDashboardData() async {
    // Business logic here
    return [];
  }
}
```

### Step 4: Update Widget Usage
```dart
// In your screen widget
class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  Future<void> _loadData() async {
    final provider = context.read<GasHomeProvider>();
    final viewModel = context.read<GasHomeViewModel>();
    
    provider.setLoading(true);
    final data = await viewModel.loadDashboardData();
    provider.updateSummaryData(data);
    provider.setLoading(false);
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<GasHomeProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return CircularProgressIndicator();
        }
        
        return ListView(
          children: provider.summaryData.map((item) => 
            SummaryCard(data: item)
          ).toList(),
        );
      },
    );
  }
}
```

### Step 5: Register in AppProviders
```dart
// lib/src/providers/app_providers.dart
class AppProviders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // New organized providers
        ChangeNotifierProvider(create: (_) => GasHomeProvider()),
        ChangeNotifierProvider(create: (_) => GasHomeViewModel()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => OrderViewModel()),
        
        // Keep old providers for backward compatibility (temporarily)
        ChangeNotifierProvider(create: (_) => GasPlantDashboardViewModel()),
        // ... other providers
      ],
      child: child,
    );
  }
}
```

---

## 3. Converting Icons to SVG

### Method 1: Direct Conversion
```dart
// ❌ Before: Material Icon
Icon(Icons.dashboard, size: 24, color: Colors.blue)

// ✅ After: SVG Icon
SvgIcon(
  svgPath: AppSvgIcons.dashboard,
  fallbackIcon: Icons.dashboard,
  size: 24,
  color: AppColors.darkBlue,
)
```

### Method 2: Using Icon Helper
```dart
// ❌ Before
Icon(Icons.dashboard, size: 24, color: Colors.blue)

// ✅ After
IconHelper.dashboard(size: 24, color: AppColors.darkBlue)
```

### Method 3: Automatic Icon Mapper
```dart
// ❌ Before
Icon(Icons.dashboard)

// ✅ After
IconMapper.buildIcon(icon: Icons.dashboard)
```

### Available SVG Icons List:
- ✅ dashboard, orders, profile, settings, notification
- ✅ add, search, clear, download, person_add
- ✅ arrow_back, arrow_down, chevron_right
- ✅ email, phone, lock, location, calendar, time
- ✅ check, info, inventory, receipt, logout

### Migration Script Pattern:
```dart
// Find in your codebase:
Icon(Icons.dashboard)

// Replace with:
IconHelper.dashboard()

// Or for icons with custom size/color:
Icon(Icons.dashboard, size: 32, color: Colors.blue)
// Replace with:
IconHelper.dashboard(size: 32, color: AppColors.darkBlue)
```

---

## 4. Replacing Images with NetworkImage

### Step 1: Import Network Image URLs
```dart
import 'package:tracklet_pro/src/utils/network_image_urls.dart';
```

### Step 2: Replace Asset Images
```dart
// ❌ Before: Local Asset
Image.asset(
  'assets/images/profile.png',
  width: 50,
  height: 50,
)

// ✅ After: Network Image
Image.network(
  NetworkImageUrls.defaultMaleProfile,
  width: 50,
  height: 50,
  errorBuilder: (context, error, stackTrace) => Icon(
    Icons.person,
    size: 50,
  ),
  loadingBuilder: (context, child, loadingProgress) {
    if (loadingProgress == null) return child;
    return CircularProgressIndicator();
  },
)
```

### Step 3: Use URL Helpers
```dart
// Generate avatar from name
Image.network(
  NetworkImageUrls.generateAvatarUrl('John Doe'),
  width: 100,
  height: 100,
)

// Get random profile
Image.network(
  NetworkImageUrls.getRandomMaleProfile(0),  // 0-4
  width: 80,
  height: 80,
)
```

### Step 4: Handle Errors Gracefully
```dart
// Complete example with error handling
CircleAvatar(
  radius: 30,
  backgroundImage: NetworkImageUrls.isValidUrl(user.imageUrl)
      ? NetworkImage(user.imageUrl!)
      : NetworkImage(NetworkImageUrls.defaultMaleProfile),
  onBackgroundImageError: (exception, stackTrace) {
    debugPrint('Error loading image: $exception');
  },
  child: user.imageUrl == null
      ? Icon(Icons.person, size: 30)
      : null,
)
```

---

## 5. Applying Consistent Theming

### Step 1: Use Theme.of(context)
```dart
// ❌ Before: Hardcoded colors and styles
Text(
  'Hello World',
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Color(0xFF002455),
  ),
)

// ✅ After: Use theme
Text(
  'Hello World',
  style: Theme.of(context).textTheme.titleLarge,
)
```

### Step 2: Use AppColors
```dart
// ❌ Before: Hardcoded colors
Container(
  color: Color(0xFF002455),
  child: Text('Hello', style: TextStyle(color: Colors.white)),
)

// ✅ After: Use AppColors
Container(
  color: AppColors.darkBlue,
  child: Text(
    'Hello',
    style: TextStyle(color: AppColors.onBackground),
  ),
)
```

### Step 3: Avoid .copyWith()
```dart
// ❌ Before: Using .copyWith()
Text(
  'Hello',
  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
    color: Colors.red,
    fontWeight: FontWeight.bold,
  ),
)

// ✅ After: Direct TextStyle with AppColors
Text(
  'Hello',
  style: TextStyle(
    color: AppColors.error,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  ),
)

// Or better: Use predefined theme text styles
Text(
  'Hello',
  style: Theme.of(context).textTheme.titleMedium,
)
```

### Available AppColors:
```dart
AppColors.darkBlue          // Primary brand color
AppColors.lightBlue         // Secondary color
AppColors.onBackground      // Text on white background
AppColors.disabledTextColor // Gray text
AppColors.error            // Error red
AppColors.success          // Success green
AppColors.warning          // Warning orange
```

### Available Text Styles (Theme):
```dart
Theme.of(context).textTheme.headlineLarge   // 32px, bold
Theme.of(context).textTheme.headlineMedium  // 24px, bold
Theme.of(context).textTheme.headlineSmall   // 20px, bold
Theme.of(context).textTheme.titleLarge      // 18px, bold
Theme.of(context).textTheme.titleMedium     // 16px, semi-bold
Theme.of(context).textTheme.titleSmall      // 14px, semi-bold
Theme.of(context).textTheme.bodyLarge       // 16px, normal
Theme.of(context).textTheme.bodyMedium      // 14px, normal
Theme.of(context).textTheme.bodySmall       // 12px, normal
```

---

## 6. Common Migration Patterns

### Pattern 1: Screen with Data Loading
```dart
class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }
  
  Future<void> _loadData() async {
    if (!mounted) return;
    
    final provider = context.read<MyProvider>();
    final viewModel = context.read<MyViewModel>();
    
    provider.setLoading(true);
    
    try {
      final data = await viewModel.fetchData();
      if (mounted) {
        provider.updateData(data);
      }
    } catch (e) {
      if (mounted) {
        provider.setError('Failed to load data');
      }
    } finally {
      if (mounted) {
        provider.setLoading(false);
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Screen'),
        leading: IconHelper.arrowBack(),
      ),
      body: Consumer<MyProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          
          if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          }
          
          return ListView.builder(
            itemCount: provider.data.length,
            itemBuilder: (context, index) {
              final item = provider.data[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    NetworkImageUrls.getRandomMaleProfile(index),
                  ),
                ),
                title: Text(
                  item.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                trailing: IconHelper.chevronRight(),
              );
            },
          );
        },
      ),
    );
  }
}
```

### Pattern 2: Bottom Navigation with SVG Icons
```dart
BottomNavigationBar(
  items: [
    BottomNavigationBarItem(
      icon: IconHelper.dashboard(color: Colors.grey),
      activeIcon: IconHelper.dashboard(color: AppColors.darkBlue),
      label: 'Dashboard',
    ),
    BottomNavigationBarItem(
      icon: IconHelper.orders(color: Colors.grey),
      activeIcon: IconHelper.orders(color: AppColors.darkBlue),
      label: 'Orders',
    ),
    BottomNavigationBarItem(
      icon: IconHelper.profile(color: Colors.grey),
      activeIcon: IconHelper.profile(color: AppColors.darkBlue),
      label: 'Profile',
    ),
  ],
)
```

### Pattern 3: Card with Theme Colors
```dart
Card(
  color: AppColors.lightBlue.withValues(alpha: 0.1),
  elevation: 2,
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconHelper.inventory(
              color: AppColors.darkBlue,
              size: 24,
            ),
            SizedBox(width: 8),
            Text(
              'Total Stock',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          '12.5 Tons',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.darkBlue,
          ),
        ),
      ],
    ),
  ),
)
```

---

## ✅ Migration Checklist

Use this checklist when migrating a screen or feature:

### Provider Migration:
- [ ] Identified module type (gas_plant/distributor/shared)
- [ ] Created new provider file in correct folder
- [ ] Separated state management from business logic
- [ ] Created corresponding view_model file
- [ ] Registered both in app_providers.dart
- [ ] Updated widget to use new providers
- [ ] Tested functionality

### Icon Migration:
- [ ] Imported icon helpers
- [ ] Replaced Material Icons with SVG equivalents
- [ ] Used IconHelper for common icons
- [ ] Added fallback icons where needed
- [ ] Verified icons display correctly

### Image Migration:
- [ ] Imported NetworkImageUrls
- [ ] Replaced Image.asset with Image.network
- [ ] Added error builders
- [ ] Added loading builders
- [ ] Tested on slow network
- [ ] Verified fallbacks work

### Theme Migration:
- [ ] Replaced hardcoded colors with AppColors
- [ ] Replaced hardcoded text styles with Theme
- [ ] Removed unnecessary .copyWith() usage
- [ ] Used consistent spacing
- [ ] Verified design consistency

---

## 🐛 Troubleshooting

### Issue: Provider not found
**Solution**: Make sure provider is registered in `app_providers.dart`

### Issue: SVG icon not displaying
**Solution**: Check if SVG file exists in `lib/src/assets/svg/` and pubspec.yaml includes flutter_svg package

### Issue: Network image not loading
**Solution**: Verify URL is valid using `NetworkImageUrls.isValidUrl()` and check internet connection

### Issue: Theme colors not applying
**Solution**: Ensure MaterialApp uses `AppTheme.lightTheme` as theme

---

## 📚 Additional Resources

- [Provider Documentation](https://pub.dev/packages/provider)
- [Flutter SVG Package](https://pub.dev/packages/flutter_svg)
- [Material Design 3](https://m3.material.io/)
- [Refactoring Summary](./REFACTORING_SUMMARY.md)

---

**Happy Migrating! 🚀**

*Last Updated: October 13, 2025*

