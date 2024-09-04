import 'package:flutter/material.dart';

class DetailListTileWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isThreeLine;
  const DetailListTileWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.isThreeLine = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      leading: Icon(
        icon,
      ),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      isThreeLine: isThreeLine,
    );
  }
}
