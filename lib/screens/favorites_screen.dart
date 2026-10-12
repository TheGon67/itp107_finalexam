import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/favorites_store.dart';
import '../widgets/quest_widgets.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});
  Future<void> _note(BuildContext context, Map<String, dynamic> post) async {
    final note = await showDialog<String>(context: context, builder: (_) => NoteDialog(initial: post['note'] as String? ?? ''));
    if(note == null) return;
    try {
      await FavoritesStore.updateNote(post['id'] as String, note);
      if(context.mounted) showMessage(context, 'Personal note saved.');
    } catch (_) {
      if(context.mounted) showMessage(context, 'Could not save your note. Try again.');
    }
  }
  Future<void> _delete(BuildContext context, Map<String, dynamic> post) async {
    final confirmed = await showDialog<bool>(context: context, builder: (dialogContext) => AlertDialog(
      title: const Text('Remove favorite?'), content: Text(post['title'] as String), actions: [
        TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
        ElevatedButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Remove')),
      ],
    ));
    if(confirmed != true) return;
    try {
      await FavoritesStore.remove(post['id'] as String);
      if(context.mounted) showMessage(context, 'Favorite removed.');
    } catch (_) {
      if(context.mounted) showMessage(context, 'Could not remove the favorite. Try again.');
    }
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Favorites'), leading: IconButton(tooltip: 'Back to previous screen',
      icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context))),
    body: ValueListenableBuilder(valueListenable: FavoritesStore.box.listenable(), builder: (context, box, _) {
      // Module 12: read saved Maps directly from box.values.
      final posts = box.values.map((value) => Map<String, dynamic>.from(value as Map)).toList();
      if(posts.isEmpty) return const QuestState(icon: Icons.star_border, title: 'No favorites yet',
        message: 'Open a post and choose Save to Favorites. Your saved posts and notes stay on this device.');
      return ListView.builder(padding: const EdgeInsets.all(18), itemCount: posts.length + 1, itemBuilder: (context, index) {
        if(index == 0) return ValleyHeader(label: 'YOUR COLLECTION', subtitle: '${posts.length} saved posts • Stored locally with Hive');
        final post = posts[index - 1];
        return PixelPanel(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          ListTile(contentPadding: EdgeInsets.zero,
            leading: PostEmblem(id: post['id'] as String),
            title: Text(post['title'] as String, style: Theme.of(context).textTheme.titleMedium),
            subtitle: Text('Post #${post['id']} • Tap to read'),
            onTap: () => Navigator.pushNamed(context, '/details', arguments: {'id': post['id'], 'title': post['title'], 'body': post['body']})),
          const Divider(),
          Text((post['note'] as String? ?? '').isEmpty ? 'No personal note. Add one below.' : 'Your note: ${post['note']}'),
          const SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8, children: [
            OutlinedButton.icon(onPressed: () => _note(context, post), icon: const Icon(Icons.edit), label: const Text('Edit note')),
            TextButton.icon(onPressed: () => _delete(context, post), icon: const Icon(Icons.delete_outline), label: const Text('Remove')),
          ]),
        ]));
      });
    }),
  );
}
class NoteDialog extends StatefulWidget {
  final String initial;
  const NoteDialog({super.key, required this.initial});
  @override
  State<NoteDialog> createState() => _NoteDialogState();
}
class _NoteDialogState extends State<NoteDialog> {
  late final TextEditingController _controller;
  @override
  void initState() { super.initState(); _controller = TextEditingController(text: widget.initial); }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => AlertDialog(title: const Text('Personal note'),
    content: SizedBox(width: 420, child: TextField(controller: _controller, autofocus: true,
      maxLength: 200, minLines: 2, maxLines: 4, decoration: const InputDecoration(labelText: 'Note (optional)'))),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
      ElevatedButton(onPressed: () => Navigator.pop(context, _controller.text), child: const Text('Save note')),
    ],
  );
}
