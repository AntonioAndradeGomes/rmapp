import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rmapp/src/common/widgets/error_widget.dart';

void main() {
  group(
    'Tests in ErrorLoadWidget',
    () {
      testWidgets(
        'ErrorLoadWidget render correctly',
        (tester) async {
          const testMessage = "Erro ao carregar dados";
          const buttonText = "Tentar novamente";

          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: ErrorLoadWidget(
                  message: testMessage,
                  messageButton: buttonText,
                ),
              ),
            ),
          );

          expect(
            find.byType(ErrorLoadWidget),
            findsOneWidget,
          );

          expect(
            find.text(testMessage),
            findsOneWidget,
          );

          expect(
            find.text(buttonText),
            findsOneWidget,
          );

          expect(find.byType(FilledButton), findsOneWidget);
          expect(find.byType(Text), findsAtLeast(2));
          expect(find.byType(Column), findsOneWidget);
        },
      );

      testWidgets(
        'ErrorLoadWidget triggers onPressed callback',
        (tester) async {
          bool buttonPressed = false;
          const testMessage = "Erro ao carregar dados";
          const buttonText = "Tentar novamente";

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ErrorLoadWidget(
                  message: testMessage,
                  messageButton: buttonText,
                  onPressed: () {
                    buttonPressed = true;
                  },
                ),
              ),
            ),
          );
          expect(buttonPressed, isFalse);

          expect(
            find.byType(ErrorLoadWidget),
            findsOneWidget,
          );

          await tester.tap(find.byType(FilledButton));
          await tester.pump();
          expect(buttonPressed, isTrue);
        },
      );
    },
  );
}
