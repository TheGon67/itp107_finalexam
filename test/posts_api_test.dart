import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:post_reader_favorites/data/posts_api.dart';
void main() {
  test('GET accepts MockAPI string IDs without losing leading zeros', () async {
    final api = PostsApi(client: MockClient((request) async {
      expect(request.method, 'GET'); expect(request.url.toString(), PostsApi.endpoint);
      return http.Response('[{"id":"007","title":"Book","body":"Story"}]', 200);
    }));
    expect((await api.fetchPosts()).single['id'], '007');
  });
  test('POST sends title/body JSON and validates persisted response', () async {
    final api = PostsApi(client: MockClient((request) async {
      expect(request.method, 'POST');
      expect(jsonDecode(request.body), {'title': 'Book', 'body': 'Story'});
      return http.Response('{"id":"21","title":"Book","body":"Story"}', 201);
    }));
    expect((await api.createPost(' Book ', ' Story '))['id'], '21');
  });
  test('DELETE targets the selected ID', () async {
    final api = PostsApi(client: MockClient((request) async {
      expect(request.method, 'DELETE'); expect(request.url.path, '/api/v1/posts/21');
      return http.Response('', 200);
    }));
    await api.deletePost('21');
  });
  test('server failures are reported instead of treated as success', () async {
    final api = PostsApi(client: MockClient((_) async => http.Response('unavailable', 500)));
    await expectLater(api.fetchPosts(), throwsA(isA<ApiFailure>()));
    await expectLater(api.createPost('Book', 'Story'), throwsA(isA<ApiFailure>()));
    await expectLater(api.deletePost('21'), throwsA(isA<ApiFailure>()));
  });
  test('invalid resource schema is rejected with an actionable error', () async {
    final api = PostsApi(client: MockClient((_) async => http.Response('[{"id":"1","name":"Wrong schema"}]', 200)));
    await expectLater(api.fetchPosts(), throwsA(isA<ApiFailure>()));
  });
}
