import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_super_admin/src/providers/users_provider.dart';
import 'package:tracklet_super_admin/src/providers/dashboard_provider.dart';
import 'package:tracklet_super_admin/src/utils/app_colors.dart';

class CreateUserDialog extends StatefulWidget {
  const CreateUserDialog({super.key});

  @override
  State<CreateUserDialog> createState() => _CreateUserDialogState();
}

class _CreateUserDialogState extends State<CreateUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  String _selectedRole = 'distributor';
  bool _useCustomPassword = false;
  String _generatedEmail = '';

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _generateEmailPreview(String name) {
    if (name.isEmpty) return '';
    final cleanedName = name
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'\s+'), '.')
        .replaceAll(RegExp(r'[^a-z0-9.]'), '');
    return '$cleanedName@tracklet.com';
  }

  Future<void> _createUser() async {
    if (!_formKey.currentState!.validate()) return;

    if (_useCustomPassword && _passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 6 characters'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final usersProvider = context.read<UsersProvider>();
    final dashboardProvider = context.read<DashboardProvider>();

    final result = await usersProvider.createUser(
      name: _nameController.text.trim(),
      role: _selectedRole,
      password: _useCustomPassword ? _passwordController.text : null,
    );

    if (result != null && mounted) {
      Navigator.pop(context);

      // Refresh dashboard stats
      dashboardProvider.loadStats();

      // Show success dialog with credentials
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 32,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(child: Text('User Created Successfully!')),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Please share these credentials with the user:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(height: 16),
                _CredentialRow(
                  label: 'Name',
                  value: result.name,
                  icon: Icons.person,
                ),
                _CredentialRow(
                  label: 'Email',
                  value: result.email,
                  icon: Icons.email,
                  canCopy: true,
                ),
                _CredentialRow(
                  label: 'Password',
                  value: result.password,
                  icon: Icons.lock,
                  canCopy: true,
                  isPassword: true,
                ),
                _CredentialRow(
                  label: 'Role',
                  value: _selectedRole == 'gas_plant'
                      ? 'Gas Plant'
                      : 'Distributor',
                  icon: Icons.badge,
                ),
                if (result.plantId != null) ...[
                  _CredentialRow(
                    label: 'Plant ID',
                    value: result.plantId!,
                    icon: Icons.factory,
                    canCopy: true,
                    valueColor: AppColors.info,
                  ),
                  if (result.plantName != null)
                    _CredentialRow(
                      label: 'Plant Name',
                      value: result.plantName!,
                      icon: Icons.business,
                    ),
                ],
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.warning),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info, color: AppColors.warning, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'This password will only be shown once. Please save it securely.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.warning,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Done'),
            ),
          ],
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(usersProvider.errorMessage ?? 'Failed to create user'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_add,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Create New User',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Name Field
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'e.g., John Doe',
                    prefixIcon: Icon(Icons.person),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _generatedEmail = _generateEmailPreview(value);
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Email Preview
                if (_generatedEmail.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.success),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.email,
                          color: AppColors.success,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Email will be:',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                _generatedEmail,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(color: AppColors.success),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),

                // Role Selection
                Text(
                  'Select Role',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _RoleCard(
                        title: 'Distributor',
                        icon: Icons.business,
                        color: AppColors.distributorColor,
                        isSelected: _selectedRole == 'distributor',
                        onTap: () {
                          setState(() {
                            _selectedRole = 'distributor';
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _RoleCard(
                        title: 'Gas Plant',
                        icon: Icons.factory,
                        color: AppColors.gasPlantColor,
                        isSelected: _selectedRole == 'gas_plant',
                        onTap: () {
                          setState(() {
                            _selectedRole = 'gas_plant';
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Plant ID Info (if Gas Plant selected)
                if (_selectedRole == 'gas_plant')
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info, color: AppColors.info, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'A unique Plant ID will be auto-generated (e.g., PLANT-45231)',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),

                // Custom Password Option
                CheckboxListTile(
                  value: _useCustomPassword,
                  onChanged: (value) {
                    setState(() {
                      _useCustomPassword = value ?? false;
                    });
                  },
                  title: const Text('Set custom password'),
                  subtitle: const Text(
                    'Otherwise, a password will be auto-generated',
                  ),
                  contentPadding: EdgeInsets.zero,
                ),

                if (_useCustomPassword) ...[
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      hintText: 'Minimum 6 characters',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (_useCustomPassword &&
                          (value == null || value.length < 6)) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                ],

                const SizedBox(height: 24),

                // Buttons
                Consumer<UsersProvider>(
                  builder: (context, usersProvider, _) {
                    if (usersProvider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: _createUser,
                          icon: const Icon(Icons.add),
                          label: const Text('Create User'),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.transparent,
          border: Border.all(
            color: isSelected ? color : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? color : AppColors.textSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: isSelected ? color : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CredentialRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool canCopy;
  final bool isPassword;
  final Color? valueColor;

  const _CredentialRow({
    required this.label,
    required this.value,
    required this.icon,
    this.canCopy = false,
    this.isPassword = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        value,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: valueColor ?? AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (canCopy)
                      IconButton(
                        icon: const Icon(Icons.copy, size: 16),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: value));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('$label copied to clipboard'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
