/// Centralized Network Image URLs
/// All image URLs used in the app should be defined here
class NetworkImageUrls {
  // User Profile Images (randomuser.me provides consistent, working images)
  static const String defaultMaleProfile =
      'https://randomuser.me/api/portraits/men/1.jpg';
  static const String defaultFemaleProfile =
      'https://randomuser.me/api/portraits/women/1.jpg';

  // Sample Male Profiles
  static const String maleProfile1 =
      'https://randomuser.me/api/portraits/men/1.jpg';
  static const String maleProfile2 =
      'https://randomuser.me/api/portraits/men/2.jpg';
  static const String maleProfile3 =
      'https://randomuser.me/api/portraits/men/3.jpg';
  static const String maleProfile4 =
      'https://randomuser.me/api/portraits/men/4.jpg';
  static const String maleProfile5 =
      'https://randomuser.me/api/portraits/men/5.jpg';

  // Sample Female Profiles
  static const String femaleProfile1 =
      'https://randomuser.me/api/portraits/women/1.jpg';
  static const String femaleProfile2 =
      'https://randomuser.me/api/portraits/women/2.jpg';
  static const String femaleProfile3 =
      'https://randomuser.me/api/portraits/women/3.jpg';
  static const String femaleProfile4 =
      'https://randomuser.me/api/portraits/women/4.jpg';
  static const String femaleProfile5 =
      'https://randomuser.me/api/portraits/women/5.jpg';

  // Business/Company Images
  static const String defaultCompanyLogo =
      'https://ui-avatars.com/api/?name=Gas+Plant&size=200&background=002455&color=fff';
  static const String gasPlantLogo1 =
      'https://ui-avatars.com/api/?name=City+Gas&size=200&background=1A3D7C&color=fff';
  static const String gasPlantLogo2 =
      'https://ui-avatars.com/api/?name=Premium+Gas&size=200&background=002455&color=fff';
  static const String distributorLogo1 =
      'https://ui-avatars.com/api/?name=Arham+Traders&size=200&background=4CAF50&color=fff';
  static const String distributorLogo2 =
      'https://ui-avatars.com/api/?name=Hashim+Traders&size=200&background=FF9800&color=fff';

  // Product/Cylinder Images (using placeholder images)
  static const String cylinderImage =
      'https://images.unsplash.com/photo-1617791160505-6f00504e3519?w=400&h=400&fit=crop';
  static const String gasDeliveryImage =
      'https://images.unsplash.com/photo-1581093458791-9d42e1f6d5e9?w=400&h=400&fit=crop';

  // Empty State/Placeholder Images
  static const String emptyBoxImage =
      'https://images.unsplash.com/photo-1580870069867-74c57ee1bb07?w=300&h=300&fit=crop';
  static const String errorImage =
      'https://images.unsplash.com/photo-1584824486509-112e4181ff6b?w=300&h=300&fit=crop';

  // Helper method to generate avatar from name
  static String generateAvatarUrl(String name, {String bgColor = '002455'}) {
    final encodedName = Uri.encodeComponent(name);
    return 'https://ui-avatars.com/api/?name=$encodedName&size=200&background=$bgColor&color=fff';
  }

  // Helper method to get random user profile
  static String getRandomMaleProfile(int index) {
    final profiles = [
      maleProfile1,
      maleProfile2,
      maleProfile3,
      maleProfile4,
      maleProfile5,
    ];
    return profiles[index % profiles.length];
  }

  static String getRandomFemaleProfile(int index) {
    final profiles = [
      femaleProfile1,
      femaleProfile2,
      femaleProfile3,
      femaleProfile4,
      femaleProfile5,
    ];
    return profiles[index % profiles.length];
  }

  // Validation helper
  static bool isValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    return Uri.tryParse(url)?.hasScheme ?? false;
  }
}
