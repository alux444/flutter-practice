import 'package:flutter/material.dart';
import '../service/auth_service.dart';
import '../data/user_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final UserModel? user = authService.getCurrentUserModel();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Form App'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'logout') {
                await authService.signOut();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Sign Out'),
                  ],
                ),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: user?.photoUrl != null 
                    ? NetworkImage(user!.photoUrl!) 
                    : null,
                child: user?.photoUrl == null 
                    ? Text(user?.displayName?.substring(0, 1).toUpperCase() ?? 'U')
                    : null,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome!',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text('Name: ${user?.displayName ?? 'Not provided'}'),
                    Text('Email: ${user?.email ?? 'Not provided'}'),
                    Text('User ID: ${user?.id ?? 'Not provided'}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Your forms and content will go here...',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}