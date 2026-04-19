import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../injection_container.dart';
import '../../../../core/widgets/tether_button.dart';
import '../../../../core/widgets/tether_text_field.dart';
import '../../../../core/widgets/whisper_text.dart';
import '../bloc/circle_cubit.dart';
import '../bloc/circle_state.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';


class CreateCircleScreen extends StatefulWidget {
  const CreateCircleScreen({super.key});

  @override
  State<CreateCircleScreen> createState() => _CreateCircleScreenState();
}

class _CreateCircleScreenState extends State<CreateCircleScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _avatarUrlController = TextEditingController();
  String _selectedType = 'friends';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocProvider(
      create: (context) => getIt<CircleCubit>(),
      child: BlocListener<CircleCubit, CircleState>(
        listener: (context, state) {
          if (state is CircleCreated) {
            context.pop();
          } else if (state is CircleError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                pinned: true,
                backgroundColor: colorScheme.surface.withOpacity(0.01),
                surfaceTintColor: Colors.transparent,
                flexibleSpace: ClipRect(
                  child: BackdropFilter(
                    filter: ColorFilter.mode(colorScheme.surface.withOpacity(0.8), BlendMode.srcOver),
                    child: Container(color: Colors.transparent),
                  ),
                ),
                leading: IconButton(
                  icon: Icon(FluentIcons.dismiss_24_regular, color: colorScheme.primary),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  'Create Sanctuary',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: colorScheme.primary,
                    fontStyle: FontStyle.italic,
                    fontSize: 24,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 100),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const WhisperText('DEFINE YOUR SPACE'),
                      const SizedBox(height: 8),
                      Text(
                        'New Circle', 
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          fontSize: 32,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 48),
                      Text(
                        'Circle Name', 
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TetherTextField(
                        controller: _nameController,
                        hintText: 'e.g., Sunday Dinners, The Besties',
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Circle Image URL (optional)', 
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TetherTextField(
                        controller: _avatarUrlController,
                        hintText: 'https://example.com/image.png',
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Type of Connection', 
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _selectedType,
                        dropdownColor: colorScheme.surfaceContainerHigh,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: colorScheme.surfaceContainerLow,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.18)),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.18)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: colorScheme.primary, width: 2),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'friends', child: Text('Friends')),
                          DropdownMenuItem(value: 'couple', child: Text('Couple (exactly 2)')),
                          DropdownMenuItem(value: 'family', child: Text('Family')),
                          DropdownMenuItem(value: 'inlaw', child: Text('In-Law')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedType = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Description (optional)', 
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TetherTextField(
                        controller: _descriptionController,
                        hintText: 'What is this circle for?',
                      ),
                      const SizedBox(height: 64),
                      BlocBuilder<CircleCubit, CircleState>(
                        builder: (context, state) {
                          final isLoading = state is CircleLoading;
                          return TetherButton(
                            isFullWidth: true,
                            onPressed: isLoading
                                ? null
                                : () {
                                    if (_nameController.text.isNotEmpty) {
                                      context.read<CircleCubit>().createCircle(
                                            name: _nameController.text,
                                            type: _selectedType,
                                            description: _descriptionController.text,
                                            avatarUrl: _avatarUrlController.text.isEmpty ? null : _avatarUrlController.text,
                                          );
                                    }
                                  },
                            tooltip: 'Finalize circle creation',
                            semanticsLabel: 'Create Circle Button',
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : const Text('Establish Circle', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

