import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:post_reader_favorites/data/favorites_store.dart';
void main() {
  test('favorites deduplicate, preserve notes, persist on reopen, and delete', () async {
    final directory = await Directory.systemTemp.createTemp('quest_hive_');
    Hive.init(directory.path);
    try {
      await Hive.openBox(FavoritesStore.boxName);
      final post = {'id': '7', 'title': 'A post', 'body': 'A body'};
      await FavoritesStore.save(post);
      await FavoritesStore.save(post);
      expect(FavoritesStore.box.length, 1);
      await FavoritesStore.updateNote('7', 'My note');
      await FavoritesStore.save(post);
      expect((FavoritesStore.box.get('7') as Map)['note'], 'My note');
      await FavoritesStore.box.close();
      await Hive.openBox(FavoritesStore.boxName);
      expect((FavoritesStore.box.get('7') as Map)['note'], 'My note');
      await FavoritesStore.remove('7');
      await FavoritesStore.box.close();
      await Hive.openBox(FavoritesStore.boxName);
      expect(FavoritesStore.box.isEmpty, true);
    } finally {
      await Hive.close(); await directory.delete(recursive: true);
    }
  });
}
