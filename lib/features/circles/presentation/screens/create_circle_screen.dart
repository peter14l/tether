import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../injection_container.dart';
import '../../../../core/widgets/tether_button.dart';
import '../../../../core/widgets/tether_text_field.dart';
import '../bloc/circle_cubit.dart';
import '../bloc/circle_state.dart';

class CreateCircleScreen extends StatefulWidget {
  const CreateCircleScreen({super.key});

  @override
  State<CreateCircleScreen> createState() => _CreateCircleScreenState();
}

class _CreateCircleScreenState extends State<CreateCircleScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedType = 'friends';

  @override
  Widget build(BuildContext context) {
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
          appBar: AppBar(
            title: Text('Create a Circle', style: Theme.of(context).textTheme.headlineMedium),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Circle Name', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                TetherTextField(
                  controller: _nameController,
                  hintText: 'e.g., Sunday Dinners, The Besties',
                ),
                const SizedBox(height: 24),
                Text('Type', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.1)),
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
                const SizedBox(height: 24),
                Text('Description (optional)', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                TetherTextField(
                  controller: _descriptionController,
                  hintText: 'What is this circle for?',
                ),
                const SizedBox(height: 48),
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
                          : const Text('Create Circle', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

