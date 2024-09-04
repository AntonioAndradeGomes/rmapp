import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoadingMoreItemsWidget extends StatelessWidget {
  final ValueListenable<bool> valueListenable;
  const LoadingMoreItemsWidget({
    super.key,
    required this.valueListenable,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: valueListenable,
      builder: (_, state, __) {
        if (!state) {
          return const SizedBox();
        }
        return Positioned(
          left: (MediaQuery.of(context).size.width / 2) - 20,
          bottom: 24,
          child: const SizedBox(
            width: 40,
            height: 40,
            child: CircleAvatar(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
