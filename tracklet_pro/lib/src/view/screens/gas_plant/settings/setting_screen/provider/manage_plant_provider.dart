import 'package:flutter/material.dart';

class ManagePlantProvider extends ChangeNotifier {
  final TextEditingController plantNameController = TextEditingController();
  final TextEditingController contactController = TextEditingController(
    text: '0335 5123456',
  );
  final TextEditingController addressController = TextEditingController();

  bool isSaving = false;

  @override
  void dispose() {
    plantNameController.dispose();
    contactController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> pickImage(BuildContext context) async {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Image picker coming soon')));
  }

  String? validate() {
    if (plantNameController.text.trim().isEmpty) {
      return 'Please enter plant name';
    }
    if (contactController.text.trim().isEmpty) {
      return 'Please enter contact number';
    }
    if (addressController.text.trim().isEmpty) return 'Please enter address';
    return null;
  }

  Future<void> saveChanges(BuildContext context) async {
    final error = validate();
    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    isSaving = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));

    isSaving = false;
    notifyListeners();

    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Plant info saved')));
      Navigator.of(context).maybePop();
    }
  }
}
