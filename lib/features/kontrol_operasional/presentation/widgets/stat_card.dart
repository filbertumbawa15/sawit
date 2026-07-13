import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String unit;

  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.black54, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Text(
            unit,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
