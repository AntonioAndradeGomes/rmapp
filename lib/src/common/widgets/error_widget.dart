import 'package:flutter/material.dart';

class ErrorLoadWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onPressed;
  final String messageButton;
  const ErrorLoadWidget({
    super.key,
    required this.message,
    this.onPressed,
    required this.messageButton,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            message,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
          FilledButton(
            onPressed: onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(
              messageButton,
            ),
          )
        ],
      ),
    );
  }
}
