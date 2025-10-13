import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_super_admin/src/providers/users_provider.dart';
import 'package:tracklet_super_admin/src/widgets/user_card.dart';
import 'package:tracklet_super_admin/src/widgets/create_user_dialog.dart';
import 'package:tracklet_super_admin/src/utils/app_colors.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UsersProvider>().loadUsers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showCreateUserDialog() {
    showDialog(
      context: context,
      builder: (context) => const CreateUserDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usersProvider = context.watch<UsersProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => usersProvider.loadUsers(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by name or email...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              usersProvider.setSearchQuery('');
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    usersProvider.setSearchQuery(value);
                  },
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChip(
                        label: 'All',
                        isSelected: usersProvider.selectedRole == 'all',
                        onTap: () => usersProvider.setRoleFilter('all'),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Distributors',
                        isSelected: usersProvider.selectedRole == 'distributor',
                        onTap: () => usersProvider.setRoleFilter('distributor'),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Gas Plants',
                        isSelected: usersProvider.selectedRole == 'gas_plant',
                        onTap: () => usersProvider.setRoleFilter('gas_plant'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Users List
          Expanded(
            child: usersProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : usersProvider.filteredUsers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.people_outline,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No users found',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () => usersProvider.refresh(),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: usersProvider.filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = usersProvider.filteredUsers[index];
                        return UserCard(user: user);
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateUserDialog,
        icon: const Icon(Icons.person_add),
        label: const Text('Add User'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.primary.withValues(alpha: 0.2),
      checkmarkColor: AppColors.primary,
    );
  }
}
