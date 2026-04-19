import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../injection_container.dart';
import '../../../../core/widgets/squircle_avatar.dart';
import '../../../../core/widgets/whisper_text.dart';
import '../../../../core/widgets/glass_panel.dart';
import '../../../../core/widgets/tether_button.dart';
import '../bloc/user_search_cubit.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';


class NewMessageScreen extends StatefulWidget {
  const NewMessageScreen({super.key});

  @override
  State<NewMessageScreen> createState() => _NewMessageScreenState();
}

class _NewMessageScreenState extends State<NewMessageScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocListener<UserSearchCubit, UserSearchState>(
      listener: (context, state) {
        if (state is UserSearchRoomCreated) {
          context.pushReplacementNamed(
            'chat',
            pathParameters: {'roomId': state.roomId},
            queryParameters: {'otherUserId': state.otherUserId},
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorScheme.surface.withOpacity(0.01),
          elevation: 0,
          title: const Text('New Message'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by username or name...',
                  prefixIcon: const Icon(FluentIcons.search_24_regular),
                  filled: true,
                  fillColor: colorScheme.surface.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  context.read<UserSearchCubit>().searchUsers(value);
                },
              ),
              const SizedBox(height: 24),
              Expanded(
                child: BlocBuilder<UserSearchCubit, UserSearchState>(
                  builder: (context, state) {
                    if (state is UserSearchLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is UserSearchLoaded) {
                      if (state.users.isEmpty) {
                        return const Center(child: Text('No users found.'));
                      }
                      return ListView.builder(
                        itemCount: state.users.length,
                        itemBuilder: (context, index) {
                          final user = state.users[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: InkWell(
                              onTap: () => context
                                  .read<UserSearchCubit>()
                                  .startConversation(user.id),
                              borderRadius: BorderRadius.circular(18),
                              child: GlassPanel(
                                padding: const EdgeInsets.all(12),
                                opacity: 0.1,
                                child: Row(
                                  children: [
                                    SquircleAvatar(
                                      imageUrl: user.avatarUrl ?? '',
                                      size: 48,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user.displayName,
                                            style: theme.textTheme.titleMedium
                                                ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          WhisperText('@${user.username}'),
                                        ],
                                      ),
                                    ),
                                    const Icon(FluentIcons.chevron_right_24_regular),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is UserSearchError) {
                      return Center(child: Text('Error: ${state.message}'));
                    }
                    return const Center(
                      child: WhisperText('Start typing to find someone'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
