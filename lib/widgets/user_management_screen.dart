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
  List<Map<String, dynamic>> _blockedUsers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    setState(() => _isLoading = true);
    try {
      final users = await _adminService.getAllUsers();
      final blockedUsers = await _adminService.getBlockedUsers();

      // تحويل المستخدمين العاديين
      final List<Map<String, dynamic>> usersAsMap =
          users
              .map<Map<String, dynamic>>((u) => Map<String, dynamic>.from(u))
              .toList();

      final List<Map<String, dynamic>> blockedAsMap =
          blockedUsers.map<Map<String, dynamic>>((u) {
            final map = Map<String, dynamic>.from(u);
            map['role'] = 'blocked';
            return map;
          }).toList();

      setState(() {
        _users = usersAsMap;
        _blockedUsers = blockedAsMap;
      });
    } catch (e) {
      _showSnackBar(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleBlock(int userId) async {
    try {
      final result = await _adminService.blockUser(userId);
      _showSnackBar(result['message']);
      _loadAllData();
    } catch (e) {
      _showSnackBar(e.toString());
    }
  }

  Future<void> _handleUnblock(int userId) async {
    try {
      final result = await _adminService.unblockUser(userId);
      _showSnackBar(result['message']);
      _loadAllData();
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
          IconButton(onPressed: _loadAllData, icon: const Icon(Icons.refresh)),
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

    if (_users.isEmpty && _blockedUsers.isEmpty) {
      return Center(
        child: Text(
          t.translate('empty_list'),
          style: const TextStyle(color: Colors.white),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ..._users.map((user) => _buildUserTile(user)),
        if (_blockedUsers.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            t.translate('blocked_users'),
            style: const TextStyle(
              color: Colors.redAccent,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ..._blockedUsers.map((user) => _buildUserTile(user)),
        ],
      ],
    );
  }

  Widget _buildUserTile(Map<String, dynamic> user) {
    final int userId = user['id'];
    final bool isBlocked = user['role'] == 'blocked';

    return Card(
      color: Colors.white.withOpacity(0.05),
      child: ListTile(
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => UserDetailsScreen(
                      userId: userId,
                      userName: user['name'] ?? '',
                    ),
              ),
            ),
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(
          user['name'] ?? '',
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          user['email'] ?? '',
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: IconButton(
          icon: Icon(
            isBlocked ? Icons.lock_open : Icons.block,
            color: isBlocked ? Colors.greenAccent : Colors.redAccent,
          ),
          onPressed:
              () => _confirmAction(userId, user['name'] ?? '', isBlocked),
        ),
      ),
    );
  }

  void _confirmAction(int id, String name, bool isBlocked) {
    final t = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(
              isBlocked
                  ? t.translate('confirm_unblock')
                  : t.translate('confirm_block'),
            ),
            content: Text(
              isBlocked
                  ? t
                      .translate('confirm_unblock_message')
                      .replaceAll('{name}', name)
                  : t
                      .translate('confirm_block_message')
                      .replaceAll('{name}', name),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(t.translate('cancel')),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isBlocked ? Colors.green : Colors.red,
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  isBlocked ? _handleUnblock(id) : _handleBlock(id);
                },
                child: Text(
                  isBlocked ? t.translate('unblock') : t.translate('block'),
                ),
              ),
            ],
          ),
    );
  }
}
