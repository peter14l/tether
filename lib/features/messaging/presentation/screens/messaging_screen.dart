import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MessagingScreen extends StatelessWidget {
  const MessagingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages', style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5, // Mock threads
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                child: const Icon(Icons.person),
              ),
              title: Text('Person $index', style: Theme.of(context).textTheme.titleLarge),
              subtitle: const Text('Latest message snippet...'),
              onTap: () => context.push('/messaging/chat/mock_circle_id/mock_user_$index'),
            ),
          );
        },
      ),
    );
  }
}
