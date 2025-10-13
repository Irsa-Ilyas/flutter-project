import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/providers/plant_provider.dart';
import 'package:tracklet_pro/src/providers/auth_provider.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_button_widget.dart';

class PlantFormDialog extends StatefulWidget {
  final dynamic plant; // PlantModel or null for new plant

  const PlantFormDialog({super.key, this.plant});

  @override
  State<PlantFormDialog> createState() => _PlantFormDialogState();
}

class _PlantFormDialogState extends State<PlantFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _cityController;
  late TextEditingController _contactController;
  late TextEditingController _emailController;
  late TextEditingController _priceController;
  late TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.plant?.name ?? '');
    _locationController = TextEditingController(
      text: widget.plant?.location ?? '',
    );
    _cityController = TextEditingController(text: widget.plant?.city ?? '');
    _contactController = TextEditingController(
      text: widget.plant?.contactNumber ?? '',
    );
    _emailController = TextEditingController(text: widget.plant?.email ?? '');
    _priceController = TextEditingController(
      text: widget.plant?.perKgPrice.toString() ?? '250',
    );
    _imageUrlController = TextEditingController(
      text: widget.plant?.imageUrl ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _cityController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.plant != null;

    return AlertDialog(
      title: Text(isEdit ? 'Edit Plant' : 'Add Plant'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Plant Name *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter plant name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'City *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter city';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(
                  labelText: 'Contact Number *',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter contact number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email *',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Per KG Price *',
                  border: OutlineInputBorder(),
                  prefixText: 'Rs. ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter price';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'Image URL (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        Consumer<PlantProvider>(
          builder: (context, plantProvider, _) {
            return CustomButtonWidget(
              text: isEdit ? 'Update' : 'Add',
              type: ButtonType.full,
              isLoading: plantProvider.isLoading,
              onPressed: plantProvider.isLoading ? () {} : _savePlant,
            );
          },
        ),
      ],
    );
  }

  Future<void> _savePlant() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final plantProvider = context.read<PlantProvider>();
    final authProvider = context.read<AuthProvider>();
    final ownerId = authProvider.user?.id ?? 'default_owner';

    final isEdit = widget.plant != null;

    bool success;
    if (isEdit) {
      success = await plantProvider.updatePlant(
        plantId: widget.plant.id,
        name: _nameController.text.trim(),
        location: _locationController.text.trim(),
        city: _cityController.text.trim(),
        contactNumber: _contactController.text.trim(),
        email: _emailController.text.trim(),
        perKgPrice: int.parse(_priceController.text.trim()),
        imageUrl: _imageUrlController.text.trim().isEmpty
            ? null
            : _imageUrlController.text.trim(),
      );
    } else {
      success = await plantProvider.createPlant(
        name: _nameController.text.trim(),
        location: _locationController.text.trim(),
        city: _cityController.text.trim(),
        contactNumber: _contactController.text.trim(),
        email: _emailController.text.trim(),
        ownerId: ownerId,
        perKgPrice: int.parse(_priceController.text.trim()),
        imageUrl: _imageUrlController.text.trim().isEmpty
            ? null
            : _imageUrlController.text.trim(),
      );
    }

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEdit ? 'Plant updated successfully' : 'Plant added successfully',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(plantProvider.errorMessage ?? 'Failed to save plant'),
        ),
      );
    }
  }
}
