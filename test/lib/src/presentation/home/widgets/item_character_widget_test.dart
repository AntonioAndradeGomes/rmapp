import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rmapp/src/presentation/home/widgets/item_character_widget.dart';

import '../../../../../mocks.dart';

void main() {
  group(
    'Tests in ItemCharacterWidget',
    () {
      testWidgets(
        "Should display character name and image",
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ItemCharacterWidget(
                  item: characterListMock.first,
                ),
              ),
            ),
          );

          expect(find.byType(ItemCharacterWidget), findsOneWidget);
          expect(find.byType(CachedNetworkImage), findsOneWidget);
          expect(find.byType(InkWell), findsOneWidget);
        },
      );

      testWidgets(
        "Should trigger onTap callback when tapped",
        (tester) async {
          bool tapped = false;
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ItemCharacterWidget(
                  item: characterListMock.first,
                  onTap: () {
                    tapped = true;
                  },
                ),
              ),
            ),
          );

          expect(find.byType(ItemCharacterWidget), findsOneWidget);
          expect(find.byType(CachedNetworkImage), findsOneWidget);
          expect(find.byType(InkWell), findsOneWidget);

          await tester.tap(find.byType(InkWell));
          await tester.pumpAndSettle();

          expect(tapped, true);
        },
      );
    },
  );
}
