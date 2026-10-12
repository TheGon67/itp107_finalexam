import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/favorites_store.dart';
import '../widgets/quest_widgets.dart';
import '../widgets/delete_post.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});
  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}
class _DetailsScreenState extends State<DetailsScreen> {
  bool _saving = false, _deleting = false;
  Future<void> _delete(Map<String, dynamic> post) async {
    setState(() => _deleting = true);
    final deleted = await confirmAndDeletePost(context, post);
    if(!mounted) return;
    setState(() => _deleting = false);
    if(deleted) Navigator.pop(context, true);
  }
  Future<void> _save(Map<String, dynamic> post) async {
    setState(() => _saving = true);
    try {
      await FavoritesStore.save(post);
      if(mounted) showMessage(context, 'Saved to Favorites. Available after reopening the app.');
    } catch (_) {
      if(mounted) showMessage(context, 'Could not save this favorite. Please try again.');
    } finally { if(mounted) setState(() => _saving = false); }
  }
  @override
  Widget build(BuildContext context) {
    // Module 11: retrieve the id, title and body from the named route.
    final raw = ModalRoute.of(context)!.settings.arguments;
    final args = raw is Map ? Map<String, dynamic>.from(raw) : <String, dynamic>{};
    final valid = args['id'] is String && args['title'] is String && args['body'] is String;
    return Scaffold(
      appBar: AppBar(title: const Text('Post Details'), leading: IconButton(tooltip: 'Back to previous screen',
        icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context))),
      body: !valid ? const QuestState(icon: Icons.warning_amber, title: 'Post unavailable', message: 'Go back and select a post from the list.')
        : _content(args),
    );
  }
  Widget _content(Map<String, dynamic> post) => SingleChildScrollView(padding: const EdgeInsets.all(18), child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      ValleyHeader(label: 'POST #${post['id']}', subtitle: 'A page from the library reading collection'),
      PixelPanel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(post['title'] as String, style: Theme.of(context).textTheme.titleMedium),
        const Divider(height: 32), SelectableText(post['body'] as String, style: Theme.of(context).textTheme.bodyLarge),
      ])),
      ValueListenableBuilder(valueListenable: FavoritesStore.box.listenable(), builder: (context, box, _) {
        final saved = box.containsKey(post['id']);
        return ElevatedButton.icon(onPressed: _saving || _deleting || saved ? null : () => _save(post),
          icon: Icon(saved ? Icons.star : Icons.star_border),
          label: Text(_saving ? 'Saving...' : saved ? 'Already in Favorites' : 'Save to Favorites'));
      }),
      const SizedBox(height: 12),
      OutlinedButton(onPressed: _deleting ? null : () => Navigator.pushNamed(context, '/favorites'), child: const Text('Open Favorites')),
      const SizedBox(height: 12),
      TextButton.icon(onPressed: _deleting || _saving ? null : () => _delete(post),
        icon: const Icon(Icons.delete_outline), label: Text(_deleting ? 'Deleting...' : 'Delete post from MockAPI')),
    ],
  ));
}
