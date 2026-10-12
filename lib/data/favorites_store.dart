import 'package:hive/hive.dart';
class FavoritesStore {
  // Separate MockAPI favorites from old JSONPlaceholder records with overlapping IDs.
  static const boxName = 'mockApiFavoritesBox';
  static Box get box => Hive.box(boxName);
  // String post IDs are keys: saving an existing post never creates a duplicate.
  static Future<void> save(Map<String, dynamic> post) async {
    final id = post['id'] as String;
    final existing = box.get(id);
    await box.put(id, {'id': id, 'title': post['title'], 'body': post['body'],
      'note': existing is Map ? existing['note'] ?? '' : ''});
  }
  static Future<void> updateNote(String id, String note) async {
    final value = box.get(id);
    if (value is! Map) throw StateError('This favorite has been removed.');
    await box.put(id, {...Map<String, dynamic>.from(value), 'note': note.trim()});
  }
  static Future<void> remove(String id) => box.delete(id);
}
