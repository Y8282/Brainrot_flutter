import 'package:brainrot_flutter/login/model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Homeview extends ConsumerWidget {
  final TextEditingController _controller = TextEditingController();
  
   Homeview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Image Generator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Search Term'),
            ),
            ElevatedButton(
              onPressed: homeState.isLoading
                  ? null
                  : () {
                      ref.read(homeViewModelProvider.notifier).generateImage(_controller.text, context);
                    },
              child: homeState.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Generate Image'),
            ),
            if (homeState.imageUrl != null)
              Image.network(
                homeState.imageUrl!,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const CircularProgressIndicator();
                },
                errorBuilder: (context, error, stackTrace) => const Text('Failed to load image'),
              )
            else
              const Text('No image generated yet'),
            if (homeState.errorMessage != null)
              Text(
                homeState.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}