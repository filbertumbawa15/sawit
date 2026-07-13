import 'package:flutter/material.dart';

class InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const InfoItem({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF333333),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}
