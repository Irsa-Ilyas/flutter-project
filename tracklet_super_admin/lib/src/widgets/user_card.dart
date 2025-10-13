import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_super_admin/src/models/user_model.dart';
import 'package:tracklet_super_admin/src/providers/users_provider.dart';
import 'package:tracklet_super_admin/src/utils/app_colors.dart';
import 'package:tracklet_super_admin/src/widgets/user_details_dialog.dart';

class UserCard extends StatelessWidget {
  final UserModel user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 28,
          backgroundImage: NetworkImage(user.profileImageUrl),
          backgroundColor: user.role == 'gas_plant'
              ? AppColors.gasPlantColor.withValues(alpha: 0.1)
              : AppColors.distributorColor.withValues(alpha: 0.1),
        ),
        title: Text(user.name, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(user.email),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: user.role == 'gas_plant'
                        ? AppColors.gasPlantColor.withValues(alpha: 0.1)
                        : AppColors.distributorColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    user.roleDisplayName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: user.role == 'gas_plant'
                          ? AppColors.gasPlantColor
                          : AppColors.distributorColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (user.plantId != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      user.plantId!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.info,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) async {
            switch (value) {
              case 'view':
                showDialog(
                  context: context,
                  builder: (_) => UserDetailsDialog(user: user),
                );
                break;
              case 'reset':
                _resetPassword(context);
                break;
              case 'delete':
                _deleteUser(context);
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'view',
              child: Row(
                children: [
                  Icon(Icons.visibility, size: 20),
                  SizedBox(width: 8),
                  Text('View Details'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'reset',
              child: Row(
                children: [
                  Icon(Icons.lock_reset, size: 20),
                  SizedBox(width: 8),
                  Text('Reset Password'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: AppColors.error),
                  SizedBox(width: 8),
                  Text('Delete User', style: TextStyle(color: AppColors.error)),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => UserDetailsDialog(user: user),
          );
        },
      ),
    );
  }

  void _resetPassword(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Reset Password'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'New Password',
              hintText: 'Enter new password (min 6 chars)',
            ),
            obscureText: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (controller.text.length < 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password must be at least 6 characters'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                  return;
                }

                final usersProvider = context.read<UsersProvider>();
                final newPassword = await usersProvider.resetPassword(
                  user.id,
                  controller.text,
                );

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }

                if (newPassword != null && context.mounted) {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Password Reset Successful'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('New password:'),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SelectableText(
                              newPassword,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.success,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Please share this with the user.',
                            style: TextStyle(color: AppColors.warning),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }

  void _deleteUser(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final usersProvider = context.read<UsersProvider>();
              final success = await usersProvider.deleteUser(user.id);

              if (dialogContext.mounted) {
                Navigator.pop(dialogContext);
              }

              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('User deleted successfully'),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
