# 🚀 TrackLet Pro - Quick Reference Guide

## 📂 NEW FOLDER STRUCTURE

### View Models Organization:
```
lib/src/view_model/
├── gas_plant/          ← Gas Plant features
│   ├── home/
│   ├── orders/
│   └── stock/
├── distributor/        ← Distributor features
│   ├── home/
│   └── orders/
└── shared/             ← Common features
    └── notification_provider.dart
```

### Import Pattern:
```dart
// Import entire module
import 'package:tracklet_pro/src/view_model/gas_plant/index.dart';

// Import specific provider
import 'package:tracklet_pro/src/view_model/gas_plant/home/gas_home_provider.dart';
```

---

## 🎨 ICONS - Quick Reference

### Using SVG Icons:

```dart
// Import
import 'package:tracklet_pro/src/utils/index.dart';

// Method 1: IconHelper (Easiest)
IconHelper.dashboard()
IconHelper.orders(size: 24, color: AppColors.darkBlue)
IconHelper.profile(size: 32)

// Method 2: Direct SVG
SvgIcon(
  svgPath: AppSvgIcons.dashboard,
  fallbackIcon: Icons.dashboard,
  size: 24,
  color: AppColors.darkBlue,
)

// Method 3: Auto Mapper
IconMapper.buildIcon(
  icon: Icons.dashboard,
  size: 24,
  color: AppColors.darkBlue,
)
```

### Available Icons (26):
```
dashboard, orders, profile, settings, notification
add, search, clear, download, person_add
arrow_back, arrow_down, chevron_right
email, phone, lock, location, calendar, time, attach_money
check, info, inventory, receipt, logout, chat
```

---

## 🖼️ IMAGES - Quick Reference

### Using Network Images:

```dart
// Import
import 'package:tracklet_pro/src/utils/network_image_urls.dart';

// Basic usage
Image.network(
  NetworkImageUrls.defaultMaleProfile,
  width: 50,
  height: 50,
  errorBuilder: (context, error, stackTrace) => 
    Icon(Icons.person, size: 50),
)

// Generate avatar from name
Image.network(
  NetworkImageUrls.generateAvatarUrl('John Doe'),
)

// Random profile
Image.network(
  NetworkImageUrls.getRandomMaleProfile(0), // 0-4
)

// In CircleAvatar
CircleAvatar(
  radius: 30,
  backgroundImage: NetworkImage(
    NetworkImageUrls.defaultMaleProfile,
  ),
)
```

---

## 🎨 THEME - Quick Reference

### Text Styles:

```dart
// Import happens automatically via MaterialApp theme

// Headlines
Theme.of(context).textTheme.headlineLarge   // 32px, bold
Theme.of(context).textTheme.headlineMedium  // 24px, bold
Theme.of(context).textTheme.headlineSmall   // 20px, bold

// Titles
Theme.of(context).textTheme.titleLarge      // 18px, bold
Theme.of(context).textTheme.titleMedium     // 16px, semi-bold
Theme.of(context).textTheme.titleSmall      // 14px, semi-bold

// Body
Theme.of(context).textTheme.bodyLarge       // 16px
Theme.of(context).textTheme.bodyMedium      // 14px
Theme.of(context).textTheme.bodySmall       // 12px
```

### Colors:

```dart
// Import
import 'package:tracklet_pro/src/utils/app_colors.dart';

// Usage
Container(color: AppColors.darkBlue)
Text('Hello', style: TextStyle(color: AppColors.lightBlue))

// Available colors:
AppColors.darkBlue          // #002455 (Primary)
AppColors.lightBlue         // #1A3D7C (Secondary)
AppColors.onBackground      // Text on white
AppColors.disabledTextColor // Gray text
AppColors.error             // Red
AppColors.success           // Green
AppColors.warning           // Orange
```

### Alpha Values (Replacing withOpacity):

```dart
// ❌ Old way
AppColors.darkBlue.withOpacity(0.5)

// ✅ New way
AppColors.darkBlue.withValues(alpha: 0.5)
```

---

## 🔄 PROVIDER PATTERN - Quick Reference

### Basic Setup in Screen:

```dart
import 'package:tracklet_pro/src/view_model/gas_plant/index.dart';

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
        provider.setError('Failed to load');
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
      appBar: AppBar(title: Text('My Screen')),
      body: Consumer<MyProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          
          if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          }
          
          return ListView(
            children: provider.data.map((item) => 
              ListTile(title: Text(item.name))
            ).toList(),
          );
        },
      ),
    );
  }
}
```

---

## 📦 COMMON WIDGETS - Quick Reference

### Card with Icon and Text:

```dart
Card(
  color: AppColors.lightBlue.withValues(alpha: 0.1),
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Row(
      children: [
        IconHelper.inventory(
          color: AppColors.darkBlue,
          size: 24,
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Stock',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                '12.5 Tons',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ],
    ),
  ),
)
```

### List Item with Avatar:

```dart
ListTile(
  leading: CircleAvatar(
    backgroundImage: NetworkImage(
      NetworkImageUrls.getRandomMaleProfile(index),
    ),
    radius: 25,
  ),
  title: Text(
    'John Doe',
    style: Theme.of(context).textTheme.titleMedium,
  ),
  subtitle: Text(
    'Delivery Driver',
    style: Theme.of(context).textTheme.bodyMedium,
  ),
  trailing: IconHelper.chevronRight(
    color: AppColors.disabledTextColor,
  ),
  onTap: () {},
)
```

### Button with Icon:

```dart
ElevatedButton.icon(
  onPressed: () {},
  icon: IconHelper.add(size: 20, color: Colors.white),
  label: Text('Add New'),
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.darkBlue,
    foregroundColor: Colors.white,
  ),
)
```

### Bottom Nav with SVG Icons:

```dart
BottomNavigationBar(
  currentIndex: _selectedIndex,
  onTap: (index) => setState(() => _selectedIndex = index),
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

---

## ⚡ QUICK CONVERSIONS

### Icon Conversion:
```dart
// Before
Icon(Icons.dashboard)

// After
IconHelper.dashboard()
```

### Image Conversion:
```dart
// Before
Image.asset('assets/images/profile.png')

// After
Image.network(NetworkImageUrls.defaultMaleProfile)
```

### Color Conversion:
```dart
// Before
Container(color: Color(0xFF002455))

// After
Container(color: AppColors.darkBlue)
```

### Text Style Conversion:
```dart
// Before
Text('Hello', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))

// After
Text('Hello', style: Theme.of(context).textTheme.titleLarge)
```

---

## 🐛 COMMON ERRORS & FIXES

### Error: "Provider not found"
```dart
// Fix: Register in app_providers.dart
ChangeNotifierProvider(create: (_) => MyProvider()),
```

### Error: "SVG not loading"
```dart
// Fix: Check if SVG file exists in lib/src/assets/svg/
// And ensure flutter_svg is in pubspec.yaml
```

### Error: "Network image not showing"
```dart
// Fix: Add error builder
Image.network(
  url,
  errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
)
```

### Error: "setState called after dispose"
```dart
// Fix: Add mounted check
if (mounted) {
  setState(() {});
}
```

---

## 📚 FULL DOCUMENTATION

For detailed information, see:
- [REFACTORING_SUMMARY.md](./REFACTORING_SUMMARY.md) - Complete overview
- [MIGRATION_GUIDE.md](./MIGRATION_GUIDE.md) - Step-by-step guide
- [✅_REFACTORING_COMPLETE.md](./✅_REFACTORING_COMPLETE.md) - Final summary

---

## 🎯 CHEAT SHEET

```dart
// IMPORTS
import 'package:tracklet_pro/src/view_model/gas_plant/index.dart';
import 'package:tracklet_pro/src/utils/index.dart';

// ICONS
IconHelper.dashboard()
IconHelper.orders(size: 24, color: AppColors.darkBlue)

// IMAGES
Image.network(NetworkImageUrls.defaultMaleProfile)
NetworkImageUrls.generateAvatarUrl('Name')

// COLORS
AppColors.darkBlue
AppColors.lightBlue

// TEXT STYLES
Theme.of(context).textTheme.titleLarge
Theme.of(context).textTheme.bodyMedium

// PROVIDER
context.read<MyProvider>()
Consumer<MyProvider>(builder: (context, provider, child) => ...)

// ALPHA VALUES
color.withValues(alpha: 0.5)
```

---

**Quick Reference - Always at your fingertips!** 📱✨

*Last Updated: October 13, 2025*

