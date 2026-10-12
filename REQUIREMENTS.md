# Exam requirement checklist

| Requirement | Implementation | Runtime check |
| --- | --- | --- |
| '/', '/details', '/favorites' named routes with initialRoute | main.dart | Open each screen |
| pushNamed and pop | All screens | AppBar back and device back |
| Pass id/title/body; retrieve with ModalRoute | PostsScreen, DetailsScreen | Compare tapped title and ID |
| GET called from initState | PostsScreen.fetchPosts via PostsApi | Open app online |
| HTTP 200 + jsonDecode | PostsApi.fetchPosts | Posts appear |
| ListView.builder and ListTile | PostsScreen | Scroll through posts |
| Errors displayed on screen | PostsScreen + other operations | Disable internet and refresh |
| Floating button opens title/body dialog | CreatePostDialog | Open New post |
| Nonempty title/body | Form validators | Try empty/whitespace values |
| POST + jsonEncode + status 201 result | PostsApi.createPost and CreatePostDialog | Submit and screenshot message |
| Flutter binding, Hive init/open before runApp | main.dart | Launch app |
| Save Map with post ID key and put | FavoritesStore.save | Save same post twice |
| Read box.values | FavoritesScreen | Open Favorites |
| Update personal note with put | FavoritesStore.updateNote | Edit and save note |
| Delete with box.delete | FavoritesStore.remove | Confirm removal |
| Favorites survive close/reopen | Hive box | Force-close/reopen; do not clear data |
| Consistent ThemeData | AppTheme | Inspect all three screens |
| Separate screen classes/files | lib/screens | Inspect project tree |
| Project ZIP | Supplied source bundle; setup generates platforms | Run setup then zip complete folder |
| Screenshots/recording | User captures from running app | README demonstration checklist |
| Filled examination form | Personal fields require your information | Fill provided original PDF |

All app features are implemented in source. Runtime verification is pending on a machine with Flutter installed.

## Authorized API change

MockAPI replaces JSONPlaceholder at the supplied URL. Remote posts now support persistent creation and deletion with confirmation. Named routing and local Hive CRUD remain. GitHub Pages workflow is supplied under `.github/workflows/deploy.yml`; actual deployment requires your GitHub repository settings.
