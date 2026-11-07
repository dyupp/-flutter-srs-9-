import 'package:flutter_test/flutter_test.dart';

// Тестируемая структура данных и бизнес-логика из стека Retrofit/JSON
class Post {
  final int id;
  final int userId;
  final String title;
  final String body;

  const Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('id') || !json.containsKey('title')) {
      throw const FormatException('Некорректный JSON: отсутствует обязательное поле');
    }
    return Post(
      id: json['id'] as int,
      userId: json['userId'] as int? ?? 0,
      title: json['title'] as String,
      body: json['body'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'title': title,
        'body': body,
      };

  Post copyWith({String? title, String? body}) {
    return Post(
      id: id,
      userId: userId,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }
}

// Вспомогательная функция фильтрации (логика поиска постов)
List<Post> filterPosts(List<Post> posts, String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return posts;
  return posts
      .where((p) => p.title.toLowerCase().contains(q) || p.body.toLowerCase().contains(q))
      .toList();
}

void main() {
  group('SRS 9: Post Model & Logic Unit Tests', () {
    final validJson = {
      'id': 101,
      'userId': 1,
      'title': 'Flutter Architecture Guide',
      'body': 'Unit testing models and repositories with Dio and Retrofit.',
    };

    test('1. fromJson корректно преобразует валидный Map в объект Post', () {
      final post = Post.fromJson(validJson);

      expect(post.id, equals(101));
      expect(post.userId, equals(1));
      expect(post.title, equals('Flutter Architecture Guide'));
      expect(post.body, contains('Unit testing'));
    });

    test('2. toJson корректно формирует Map-структуру для сетевого запроса', () {
      final post = Post.fromJson(validJson);
      final json = post.toJson();

      expect(json['id'], 101);
      expect(json['userId'], 1);
      expect(json['title'], 'Flutter Architecture Guide');
      expect(json, isA>());
    });

    test('3. copyWith корректно обновляет указанные поля без изменения остальных', () {
      final post = Post.fromJson(validJson);
      final updated = post.copyWith(title: 'New Title');

      expect(updated.title, equals('New Title'));
      expect(updated.id, equals(post.id));
      expect(updated.body, equals(post.body));
    });

    test('4. filterPosts корректно находит посты по вхождению в title или body', () {
      final posts = [
        const Post(id: 1, userId: 1, title: 'Learn Flutter', body: 'Crossplatform'),
        const Post(id: 2, userId: 1, title: 'Learn Dart', body: 'Async & streams'),
        const Post(id: 3, userId: 2, title: 'Clean Code', body: 'Architecture in Flutter'),
      ];

      final result = filterPosts(posts, 'flutter');

      expect(result.length, equals(2));
      expect(result.map((e) => e.id), containsAll([1, 3]));
    });

    test('5. fromJson выбрасывает FormatException при отсутствии ключевых полей', () {
      final brokenJson = {'body': 'No id and no title'};

      expect(
        () => Post.fromJson(brokenJson),
        throwsA(isA<FormatException>()),
      );
    });
  });
}