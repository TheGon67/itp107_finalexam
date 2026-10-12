import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/posts_screen.dart';
import 'data/favorites_store.dart';
import 'screens/details_screen.dart';
import 'screens/favorites_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Hive.initFlutter();
    await Hive.openBox(FavoritesStore.boxName);
    runApp(const PostReaderApp());
  } catch (_) {
    runApp(MaterialApp(theme: AppTheme.theme, home: Scaffold(
      appBar: AppBar(title: const Text('Storage error')),
      body: const Center(child: Padding(padding: EdgeInsets.all(24),
        child: Text('Local storage could not open. Restart the app and check available device storage.'))),
    )));
  }
}

class PostReaderApp extends StatelessWidget {
  const PostReaderApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Post Reader & Favorites', debugShowCheckedModeBanner: false,
    theme: AppTheme.theme, initialRoute: '/',
    routes: {
      '/': (_) => const PostsScreen(),
      '/details': (_) => const DetailsScreen(),
      '/favorites': (_) => const FavoritesScreen(),
    },
  );
}
