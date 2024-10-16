import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rmapp/src/presentation/widgets/character_item_widget.dart';

import '../../../../mocks.dart';

void main() {
  group(
    'Tests in widget CharacterItemWidget',
    () {
      final entity = characterListMock.first;

      testWidgets(
        'Should render character info correctly',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: CharacterItemWidget(
                item: entity,
              ),
            ),
          );

          expect(find.byType(CharacterItemWidget), findsOneWidget);
          expect(find.byType(Card), findsOneWidget);
          expect(find.byType(InkWell), findsOneWidget);
          expect(find.byType(CachedNetworkImage), findsOneWidget);
          expect(find.byType(IconButton), findsNothing);
        },
      );

      testWidgets(
        'Should trigger onTap callback when tapped',
        (tester) async {
          bool tapped = false;

          await tester.pumpWidget(
            MaterialApp(
              home: CharacterItemWidget(
                item: entity,
                onTap: () {
                  tapped = true;
                },
              ),
            ),
          );

          await tester.tap(find.byType(InkWell));
          await tester.pump();

          expect(tapped, true);
        },
      );

      testWidgets(
          'Should trigger onPressedRemove callback when remove icon is pressed',
          (tester) async {
        bool tapped = false;
        await tester.pumpWidget(
          MaterialApp(
            home: CharacterItemWidget(
              item: entity,
              onPressedRemove: () {
                tapped = true;
              },
            ),
          ),
        );

        // Simulate tap on the remove button
        await tester.tap(
          find.byIcon(Icons.remove_circle_outline_rounded),
        );
        await tester.pump();
        expect(tapped, true);
      });
    },
  );
}
