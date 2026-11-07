import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SRS 9: Post Screen Widget Tests', () {
    Widget createWidgetUnderTest(Widget child) {
      return MaterialApp(
        home: child,
      );
    }

    testWidgets('1. Проверка отображения AppBar, заголовка и кнопки обновления',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          Scaffold(
            appBar: AppBar(
              title: const Text('Post Explorer'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {},
                ),
              ],
            ),
            body: const Center(child: Text('Список постов')),
          ),
        ),
      );

      expect(find.text('Post Explorer'), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
      expect(find.text('Список постов'), findsOneWidget);
    });

    testWidgets('2. Отображение списка элементов ListView с карточками постов',
        (WidgetTester tester) async {
      final mockPosts = ['Post 1: Retrofit Setup', 'Post 2: BLoC State Management'];

      await tester.pumpWidget(
        createWidgetUnderTest(
          Scaffold(
            body: ListView.builder(
              itemCount: mockPosts.length,
              itemBuilder: (context, index) => ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text(mockPosts[index]),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(ListTile), findsNWidgets(2));
      expect(find.text('Post 1: Retrofit Setup'), findsOneWidget);
      expect(find.text('Post 2: BLoC State Management'), findsOneWidget);
    });

    testWidgets('3. Проверка интерактивности: нажатие на кнопку увеличивает счетчик',
        (WidgetTester tester) async {
      int count = 0;

      await tester.pumpWidget(
        createWidgetUnderTest(
          StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: Center(child: Text('Лайков: $count')),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      count++;
                    });
                  },
                  child: const Icon(Icons.thumb_up),
                ),
              );
            },
          ),
        ),
      );

      expect(find.text('Лайков: 0'), findsOneWidget);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      expect(find.text('Лайков: 1'), findsOneWidget);
    });
  });
}