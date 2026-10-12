import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiFailure implements Exception {
  final String message;
  const ApiFailure(this.message);
  @override
  String toString() => message;
}
class PostsApi {
  static const endpoint = 'https://6acc9ec1b406cb8ec0c60bd4.mockapi.io/api/v1/posts';
  final http.Client? client;
  const PostsApi({this.client});
  static Map<String, dynamic> parsePost(dynamic value) {
    if(value is! Map) throw const ApiFailure('The server returned an invalid post.');
    final post = Map<String, dynamic>.from(value);
    final id = post['id'];
    if((id is! String && id is! int) || id.toString().isEmpty ||
       post['title'] is! String || post['body'] is! String) {
      throw const ApiFailure('Check your MockAPI resource: every post needs id, title, and body.');
    }
    // MockAPI commonly returns IDs as strings. Keep the original identity.
    return {'id': id.toString(), 'title': post['title'], 'body': post['body']};
  }
  Future<List<Map<String, dynamic>>> fetchPosts() async {
    final uri = Uri.parse(endpoint);
    final response = await (client == null ? http.get(uri) : client!.get(uri))
      .timeout(const Duration(seconds: 20));
    if(response.statusCode != 200) throw ApiFailure('Could not load posts: HTTP ${response.statusCode}.');
    final data = jsonDecode(response.body);
    if(data is! List) throw const ApiFailure('The posts endpoint must return a JSON list.');
    return data.map(parsePost).toList();
  }
  Future<Map<String, dynamic>> createPost(String title, String body) async {
    if(title.trim().isEmpty || body.trim().isEmpty) throw const ApiFailure('Title and body cannot be empty.');
    final uri = Uri.parse(endpoint);
    const headers = {'Content-Type': 'application/json; charset=UTF-8'};
    final payload = jsonEncode({'title': title.trim(), 'body': body.trim()});
    final response = await (client == null ? http.post(uri, headers: headers, body: payload)
      : client!.post(uri, headers: headers, body: payload)).timeout(const Duration(seconds: 20));
    if(response.statusCode != 201) throw ApiFailure('Could not create post: HTTP ${response.statusCode}.');
    return parsePost(jsonDecode(response.body));
  }
  Future<void> deletePost(String id) async {
    final uri = Uri.parse('$endpoint/${Uri.encodeComponent(id)}');
    final response = await (client == null ? http.delete(uri) : client!.delete(uri))
      .timeout(const Duration(seconds: 20));
    // 404 means another client has already removed this post.
    if(response.statusCode != 200 && response.statusCode != 204 && response.statusCode != 404) {
      throw ApiFailure('Could not delete post: HTTP ${response.statusCode}.');
    }
  }
}
