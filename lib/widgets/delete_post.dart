import 'package:flutter/material.dart';
import '../data/posts_api.dart';
import '../data/favorites_store.dart';
import 'quest_widgets.dart';
Future<bool> confirmAndDeletePost(BuildContext context, Map<String, dynamic> post) async {
  final confirmed = await showDialog<bool>(context: context, builder: (dialogContext) => AlertDialog(
    title: const Text('Delete this post?'),
    content: Text('"${post['title']}" will be deleted from MockAPI for everyone using this endpoint. It will also be removed from Favorites on this device.'),
    actions: [
      TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
      ElevatedButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Delete post')),
    ],
  ));
  if(confirmed != true) return false;
  try {
    await const PostsApi().deletePost(post['id'] as String);
  } catch(e) {
    if(context.mounted) showMessage(context, e is ApiFailure ? e.message : 'Could not delete the post. Check your connection and try again.');
    return false;
  }
  var message = 'Post deleted from MockAPI.';
  try { await FavoritesStore.remove(post['id'] as String); }
  catch (_) { message = 'Post deleted from MockAPI. Remove its local favorite manually.'; }
  if(context.mounted) showMessage(context, message);
  return true;
}
