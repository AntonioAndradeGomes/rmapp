import 'package:flutter_test/flutter_test.dart';
import 'package:rmapp/src/presentation/home/controllers/characters/pagination_manager.dart';

void main() {
  group(
    'Tests in PaginationManager',
    () {
      late PaginationManager controller;

      setUp(() {
        controller = PaginationManager();
      });

      test(
        'Must return the initial state of the class',
        () async {
          expect(controller.page, 1);
          expect(controller.hasMoreItems, true);
        },
      );

      test(
        'Must add the value of the page',
        () async {
          controller.nextPage();
          expect(controller.page, 2);
          expect(controller.hasMoreItems, true);
        },
      );

      test(
        'Should add call noMoreItens',
        () async {
          controller.noMoreItems();
          expect(controller.page, 1);
          expect(controller.hasMoreItems, false);
        },
      );

      test(
        'Must add call reset',
        () async {
          controller.nextPage();
          expect(controller.page, 2);
          expect(controller.hasMoreItems, true);
          controller.nextPage();
          controller.noMoreItems();
          expect(controller.page, 3);
          expect(controller.hasMoreItems, false);
          controller.reset();
          expect(controller.page, 1);
          expect(controller.hasMoreItems, true);
        },
      );

      test(
        'Tests in props',
        () async {
          expect(controller.props, [1, true]);
        },
      );
    },
  );
}
