# Shared Widgets

This directory contains reusable UI components that can be used throughout the application.

## CustomChipWidget

The CustomChipWidget provides a standardized way to display chip components across the application.

### Usage

To use the CustomChipWidget, import it in your file:

```dart
import 'package:tracklet_pro/src/shared_widgets/custom_chip_widget.dart';
```

Or use the shared_widgets index file:

```dart
import 'package:tracklet_pro/src/shared_widgets/index.dart';
```

### Parameters

- `label` (required) - The text to display in the chip
- `backgroundColor` (optional) - Background color of the chip (defaults to AppColors.onBackground)
- `labelColor` (optional) - Text color of the chip (defaults to AppColors.lightBlueBackground)
- `padding` (optional) - Padding around the text (defaults to EdgeInsets.only(top: 0, left: 4, right: 4, bottom: 0))
- `fontSize` (optional) - Font size of the text (defaults to 10)

### Example Usage

```dart
// Basic usage
CustomChipWidget(
  label: '45.4 KG (3)',
),

// With custom colors
CustomChipWidget(
  label: '45.4 KG (3)',
  backgroundColor: Colors.blue,
  labelColor: Colors.white,
),

// With custom padding and font size
CustomChipWidget(
  label: '45.4 KG (3)',
  padding: EdgeInsets.all(8),
  fontSize: 12,
),
```

This ensures consistent chip display and handling throughout the application.