import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rmapp/src/presentation/home/widgets/loading_more_items_widget.dart';

void main() {
  group(
    'Tests in LoadingMoreItemsWidget',
    () {
      testWidgets(
        "hould display CircularProgressIndicator when loading is true",
        (tester) async {
          final loadingNotifier = ValueNotifier<bool>(true);
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Stack(
                  children: [
                    LoadingMoreItemsWidget(
                      valueListenable: loadingNotifier,
                    ),
                  ],
                ),
              ),
            ),
          );

          expect(
            find.byType(CircularProgressIndicator),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'Should not display CircularProgressIndicator when loading is false',
        (tester) async {
          final loadingNotifier = ValueNotifier<bool>(false);
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Stack(
                  children: [
                    LoadingMoreItemsWidget(
                      valueListenable: loadingNotifier,
                    ),
                  ],
                ),
              ),
            ),
          );

          expect(
            find.byType(CircularProgressIndicator),
            findsNothing,
          );
        },
      );

      testWidgets(
        'Should update the widget when ValueListenable changes',
        (tester) async {
          final loadingNotifier = ValueNotifier<bool>(false);
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Stack(
                  children: [
                    LoadingMoreItemsWidget(
                      valueListenable: loadingNotifier,
                    ),
                  ],
                ),
              ),
            ),
          );

          expect(
            find.byType(CircularProgressIndicator),
            findsNothing,
          );

          loadingNotifier.value = true;
          await tester.pump();

          expect(
            find.byType(CircularProgressIndicator),
            findsOneWidget,
          );
        },
      );
    },
  );
}
