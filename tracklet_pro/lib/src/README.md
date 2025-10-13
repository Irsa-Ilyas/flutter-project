# MVVM Architecture Structure

This Flutter project follows the MVVM (Model-View-ViewModel) architecture pattern with Provider for state management.

## Folder Structure

```
lib/
├── main.dart
└── src/
    ├── model/
    │   ├── index.dart
    │   └── user_model.dart
    ├── view/
    │   └── screens/
    │       ├── splash/
    │       │   └── splash_screen.dart
    │       ├── auth/
    │       │   └── login_screen.dart
    │       ├── gas_plant/
    │       │   └── gas_plant_main_screen.dart
    │       └── distributor/
    │           └── distributor_main_screen.dart
    ├── view_model/
    │   ├── index.dart
    │   ├── base_view_model.dart
    │   ├── auth_view_model.dart
    │   ├── login_view_model.dart
    │   ├── navigation_view_model.dart
    │   └── widget_view_model.dart
    ├── repository/
    │   └── auth_repository.dart
    ├── service/
    │   ├── base_service.dart
    │   ├── api_service.dart
    │   └── auth_service.dart
    ├── providers/
    │   ├── index.dart
    │   ├── app_providers.dart
    │   └── auth_provider.dart
    ├── shared_widgets/
    │   ├── index.dart
    │   ├── custom_button_widget.dart
    │   ├── custom_text_field_widget.dart
    │   ├── custom_app_bar_widget.dart
    │   ├── custom_snack_bar_widget.dart
    │   ├── custom_dialog_widget.dart
    │   └── custom_loader_widget.dart
    ├── auth_widgets/
    │   ├── index.dart
    │   ├── auth_header_widget.dart
    │   ├── auth_footer_widget.dart
    │   └── otp_input_field_widget.dart
    ├── ui_components/
    │   ├── index.dart
    │   ├── custom_card_widget.dart
    │   ├── custom_chip_widget.dart
    │   ├── custom_dropdown_widget.dart
    │   ├── custom_image_picker_widget.dart
    │   └── section_header_widget.dart
    ├── navigation/
    │   ├── index.dart
    │   ├── custom_bottom_nav_bar.dart
    │   ├── custom_drawer_widget.dart
    │   └── route_manager.dart
    ├── utils_widgets/
    │   ├── index.dart
    │   ├── responsive_padding_widget.dart
    │   ├── empty_state_widget.dart
    │   ├── error_state_widget.dart
    │   └── network_image_widget.dart
    ├── widget/
    │   ├── index.dart
    │   ├── custom_button.dart
    │   ├── custom_text.dart
    │   ├── custom_input_field.dart
    │   ├── custom_card.dart
    │   ├── custom_dialog.dart
    │   └── custom_flushbar.dart
    ├── utils/
    │   ├── index.dart
    │   ├── app_colors.dart
    │   ├── app_strings.dart
    │   ├── app_icons.dart
    │   ├── app_theme.dart
    │   ├── app_constants.dart
    │   ├── app_exceptions.dart
    │   └── app_routes.dart
    └── assets/
        └── icons/
```

## Architecture Layers

### 1. Model
- Contains data models and business logic
- Handles data parsing and serialization
- Independent of UI components

### 2. View
- Contains UI components (StatelessWidget only)
- Observes ViewModel for data changes
- Sends user interactions to ViewModel
- Organized by feature/screens

### 3. ViewModel
- Acts as a bridge between View and Model
- Handles UI logic and state management
- Exposes data and methods to the View
- Extends BaseViewModel for consistent notifyListeners usage

### 4. Repository
- Manages data operations
- Coordinates between different data sources
- Provides a clean API to the ViewModel

### 5. Service
- Handles API communications
- Uses Dio package for HTTP requests
- Implements error handling

### 6. Providers
- Contains Provider classes for state management
- Registers providers with MultiProvider using ChangeNotifierProvider
- Follows Provider best practices

### 7. Widgets
- Contains reusable custom UI components
- Independent of business logic
- Can be shared across different views
- Uses custom themes and text styles

### 8. Utils
- Contains utility classes and constants
- Helper functions and extensions
- Configuration and routing
- Custom themes, colors, strings, and icons

## Professional Development Features

### Index Files
- Index files created for easy imports across modules
- Reduces import complexity and improves code organization
- Files: model/index.dart, view_model/index.dart, providers/index.dart, widget/index.dart, utils/index.dart

### Custom Colors
- Defined in app_colors.dart
- Consistent color palette throughout the application
- Includes primary, secondary, background, text, and status colors

### Custom Strings
- Defined in app_strings.dart
- Centralized string management for easy localization
- Includes all UI text, labels, and messages

### Custom Icons
- Defined in app_icons.dart
- Centralized icon management
- Uses Material Icons with easy replacement capability for SVG icons

### Custom Theme
- Defined in app_theme.dart
- Consistent styling across the application
- Custom text styles, button themes, and input themes

### Custom Widgets
1. **CustomButton** - Styled buttons with loading states
2. **CustomText** - Text components using app theme text styles
3. **CustomInputField** - Form input fields with labels and validation
4. **CustomCard** - Styled cards with tap handlers
5. **CustomDialog** - Custom alert dialogs
6. **CustomFlushbar** - Notification system

### Comprehensive Widget Library
The app now includes a complete set of reusable widgets organized in categories:
- **Shared Widgets**: Common UI components
- **Auth Widgets**: Authentication-specific components
- **UI Components**: Specialized UI elements
- **Navigation**: Navigation-related components
- **Utils Widgets**: Utility components

## Data Flow

1. View (UI) triggers an action
2. ViewModel processes the action
3. Repository handles data operations
4. Service communicates with APIs
5. Model represents the data structure
6. Changes propagate back through the chain
7. View updates automatically through Provider

## State Management

- Uses Provider package exclusively with ChangeNotifierProvider
- Minimizes StatefulWidget usage (only for text controllers where necessary)
- All business logic managed in Provider/ViewModel classes
- View components are primarily StatelessWidget

## Custom Widgets

The app includes several custom widgets for consistent UI:
- CustomButton: Styled buttons with loading states
- CustomText: Text components using app theme text styles
- CustomInputField: Form input fields with labels and validation
- CustomCard: Styled cards with tap handlers
- CustomDialog: Custom alert dialogs
- CustomFlushbar: Notification system

## Custom Themes

The app uses a custom theme defined in AppTheme:
- Consistent color scheme based on custom color palette
- Custom text styles for headings, subheadings, and body text
- Styled input fields and buttons
- Material Design 3 components

## Role-Based Navigation

The app supports two user roles:
1. Gas Plant Users
2. Distributor Users

Each role has its own:
- Main screen with bottom navigation
- Separate navigation flow
- Role-specific features and UI

Authentication flow:
1. Splash Screen (initial route)
2. Login Screen (if not authenticated)
3. Role-specific main screen (based on user role)

## Implementation Details

To adhere to the constraints:
- All main UI components are StatelessWidget
- Only Provider state management is used with ChangeNotifierProvider in MultiProvider
- Custom widgets are created for consistent UI
- Custom themes, colors, strings, and icons are implemented and used throughout the app
- Minimal StatefulWidget usage (only where technically necessary for text controller disposal)
- All business logic is handled through Providers and ViewModels
- Index files created for organized imports
- Professional folder structure with clear separation of concerns