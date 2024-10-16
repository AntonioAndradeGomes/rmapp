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
        },
      );
    },
  );
}
