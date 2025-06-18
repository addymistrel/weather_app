import 'package:flutter/material.dart';

class AdditionalInfoItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final String value;

  const AdditionalInfoItem({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 34),
        const SizedBox(height: 10),
        Text(title, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 10),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
