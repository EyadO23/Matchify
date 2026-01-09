import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:matchifiy/services/admin_service.dart';
import 'package:matchifiy/services/app_localizations.dart';
import 'package:matchifiy/widgets/CustomBackgroundScaffold.dart';
import 'package:matchifiy/widgets/user_details_screen.dart';

class UsersManagementScreen extends StatefulWidget {
  const UsersManagementScreen({super.key});

  @override
  State<UsersManagementScreen> createState() => _UsersManagementScreenState();
}

class _UsersManagementScreenState extends State<UsersManagementScreen> {
  final AdminService _adminService = AdminService();
  List<dynamic> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    try {
      final users = await _adminService.getAllUsers();
      log(users.toString());
      setState(() => _users = users);
    } catch (e) {
      _showSnackBar(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleDelete(int userId) async {
    try {
      final result = await _adminService.deleteUser(userId);
      _showSnackBar(result['message']);
      _loadUsers();
    } catch (e) {
      _showSnackBar(e.toString());
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return CustomBackgroundScaffold(
      appBar: AppBar(
        title: Text(
          t.translate('users_management_title'),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(onPressed: _loadUsers, icon: const Icon(Icons.refresh)),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildUsersList(),
    );
  }

  Widget _buildUsersList() {
    final t = AppLocalizations.of(context);

    if (_users.isEmpty) {
      return Center(
        child: Text(
          t.translate('empty_list'),
          style: const TextStyle(color: Colors.white),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _users.length,
      itemBuilder: (context, index) {
        final user = _users[index];
        return Card(
          color: Colors.white.withOpacity(0.05),
          child: ListTile(
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => UserDetailsScreen(
                          userId: user['id'],
                          userName: user['name'],
                        ),
                  ),
                ),
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(
              user['name'],
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              user['email'],
              style: const TextStyle(color: Colors.white70),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () => _confirmDelete(user['id'], user['name']),
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete(int id, String name) {
    final t = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(t.translate('confirm_delete')),
            content: Text(
              t.translate('confirm_delete_message').replaceAll('{name}', name),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(t.translate('cancel')),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.pop(ctx);
                  _handleDelete(id);
                },
                child: Text(t.translate('delete')),
              ),
            ],
          ),
    );
  }
}
