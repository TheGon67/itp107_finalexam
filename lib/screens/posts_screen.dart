import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/posts_api.dart';
import '../data/favorites_store.dart';
import '../widgets/quest_widgets.dart';
import '../theme/app_theme.dart';
import '../widgets/create_post_dialog.dart';
import '../widgets/delete_post.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});
  @override
  State<PostsScreen> createState() => _PostsScreenState();
}
class _PostsScreenState extends State<PostsScreen> {
  List<Map<String, dynamic>> _posts = [];
  bool _loading = true, _deleting = false;
  String? _error;
  @override
  void initState() { super.initState(); fetchPosts(); }
  Future<void> fetchPosts() async {
    if(!mounted) return;
    setState(() { _loading = true; _error = null; });
    try {
      final posts = await const PostsApi().fetchPosts();
      if(mounted) setState(() => _posts = posts);
    } catch(e) {
      if(mounted) setState(() => _error = e is ApiFailure ? e.message : 'Could not load posts. Check your connection and try again.');
    } finally { if(mounted) setState(() => _loading = false); }
  }
  Future<void> _create() async {
    await showDialog<bool>(context: context, barrierDismissible: false, builder: (_) => const CreatePostDialog());
    // Refresh even if the successful dialog is closed with the device Back button.
    if(mounted) await fetchPosts();
  }
  Future<void> _open(Map<String, dynamic> post) async {
    await Navigator.pushNamed(context, '/details', arguments: post);
    if(mounted) await fetchPosts();
  }
  Future<void> _favorites() async {
    await Navigator.pushNamed(context, '/favorites');
    if(mounted) await fetchPosts();
  }
  Future<void> _delete(Map<String, dynamic> post) async {
    if(_deleting) return;
    setState(() => _deleting = true);
    final deleted = await confirmAndDeletePost(context, post);
    if(mounted) {
      setState(() => _deleting = false);
      if(deleted) await fetchPosts();
    }
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Posts'), actions: [
      IconButton(tooltip: 'Refresh posts', onPressed: _loading || _deleting ? null : fetchPosts, icon: const Icon(Icons.refresh)),
      IconButton(tooltip: 'Open Favorites', onPressed: _deleting ? null : _favorites, icon: const Icon(Icons.star)),
    ]),
    body: _loading ? const QuestState(icon: Icons.hourglass_top, title: 'Loading posts...', message: 'Opening the library reading collection.')
      : _error != null ? QuestState(icon: Icons.wifi_off, title: 'Could not load posts', message: _error!,
        action: ElevatedButton(onPressed: fetchPosts, child: const Text('Try again')))
      : _posts.isEmpty ? const QuestState(icon: Icons.inbox, title: 'No posts yet', message: 'Tap New post to add the first page to this library.')
      : ValueListenableBuilder(valueListenable: FavoritesStore.box.listenable(), builder: (context, box, _) =>
        RefreshIndicator(onRefresh: _deleting ? () async {} : fetchPosts, child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 100), itemCount: _posts.length + 1,
          itemBuilder: (context, index) {
            if(index == 0) return ValleyHeader(label: 'POST READER', subtitle: '${_posts.length} posts to explore • ${box.length} favorites saved');
            final post = _posts[index - 1];
            final saved = box.containsKey(post['id']);
            return PixelPanel(padding: EdgeInsets.zero, child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leading: PostEmblem(id: post['id'] as String),
              title: Text(post['title'] as String, maxLines: 2, overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium),
              subtitle: Padding(padding: const EdgeInsets.only(top: 6), child: Text(saved ? '★ Saved • Open post' : 'Open post →')),
              trailing: IconButton(tooltip: 'Delete post from MockAPI', onPressed: _deleting ? null : () => _delete(post),
                icon: Icon(Icons.delete_outline, color: _deleting ? AppTheme.muted : AppTheme.rose)),
              onTap: _deleting ? null : () => _open(post),
            ));
          },
        ))),
    floatingActionButton: FloatingActionButton.extended(onPressed: _deleting || _loading ? null : _create,
      icon: const Icon(Icons.add), label: const Text('New post')),
  );
}
