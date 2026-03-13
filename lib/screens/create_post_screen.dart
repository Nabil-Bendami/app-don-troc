import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../config/index.dart';
import '../providers/providers.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _createPost() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final currentUser = await ref.read(currentUserProvider.future);
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final firestoreService = ref.read(firestoreServiceProvider);

      await firestoreService.addPost(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        image: null,
        userId: currentUser.uid,
        userName: currentUser.name,
        userPhotoUrl: currentUser.photoUrl,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post created successfully!')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Constants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Post Title
              Text(
                'Post Title',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: Constants.paddingSmall),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'What are you sharing?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      Constants.borderRadiusMedium,
                    ),
                  ),
                ),
                maxLines: 1,
              ),
              const SizedBox(height: Constants.paddingLarge),

              /// Post Description
              Text(
                'Description',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: Constants.paddingSmall),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'Add details about your post...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      Constants.borderRadiusMedium,
                    ),
                  ),
                ),
                maxLines: 8,
              ),
              const SizedBox(height: Constants.paddingLarge),

              /// Info
              Container(
                padding: const EdgeInsets.all(Constants.paddingMedium),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withAlpha(26),
                  borderRadius: BorderRadius.circular(
                    Constants.borderRadiusMedium,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline),
                    const SizedBox(width: Constants.paddingMedium),
                    Expanded(
                      child: Text(
                        'Make sure to provide accurate and honest information about your post.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Constants.paddingLarge),

              /// Create Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _createPost,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Create Post'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
