import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../injection_container.dart';
import '../bloc/heritage_cubit.dart';
import '../bloc/heritage_state.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';


class HeritageCornerScreen extends StatelessWidget {
  final String circleId;
  const HeritageCornerScreen({super.key, required this.circleId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HeritageCubit>()..loadItems(circleId),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Heritage Corner', style: Theme.of(context).textTheme.headlineMedium),
        ),
        body: BlocBuilder<HeritageCubit, HeritageState>(
          builder: (context, state) {
            if (state is HeritageLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HeritageLoaded) {
              if (state.items.isEmpty) {
                return const Center(child: Text('No family archives yet.'));
              }
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  final item = state.items[index];
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        item.mediaUrl.startsWith('http') 
                          ? Image.network(item.mediaUrl, fit: BoxFit.cover)
                          : const Placeholder(),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              item.eraLabel ?? 'Unknown Era',
                              style: const TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            onPressed: () => _showUploadDialog(context),
            child: const Icon(FluentIcons.camera_add_24_regular),
          ),
        ),
      ),
    );
  }

  void _showUploadDialog(BuildContext context) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (dialogContext) => _UploadHeritageDialog(
            imageFile: File(image.path),
            onUpload: (file, caption, era) {
              context.read<HeritageCubit>().uploadItem(
                circleId: circleId,
                file: file,
                caption: caption,
                eraLabel: era,
              );
            },
          ),
        );
      }
    }
  }
}

class _UploadHeritageDialog extends StatefulWidget {
  final File imageFile;
  final Function(File file, String caption, String era) onUpload;

  const _UploadHeritageDialog({
    required this.imageFile,
    required this.onUpload,
  });

  @override
  State<_UploadHeritageDialog> createState() => _UploadHeritageDialogState();
}

class _UploadHeritageDialogState extends State<_UploadHeritageDialog> {
  final _captionController = TextEditingController();
  final _eraController = TextEditingController();

  @override
  void dispose() {
    _captionController.dispose();
    _eraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add to Heritage'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.file(widget.imageFile, height: 150),
            const SizedBox(height: 16),
            TextField(
              controller: _captionController,
              decoration: const InputDecoration(labelText: 'Caption (optional)'),
            ),
            TextField(
              controller: _eraController,
              decoration: const InputDecoration(labelText: 'Era (e.g. 1970s)'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onUpload(
              widget.imageFile,
              _captionController.text,
              _eraController.text,
            );
            Navigator.pop(context);
          },
          child: const Text('Upload'),
        ),
      ],
    );
  }
}
