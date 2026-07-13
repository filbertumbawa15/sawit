import 'package:flutter/material.dart';

class ReadOnlyCheckboxItem extends StatelessWidget {
  final String label;
  final bool isChecked;

  const ReadOnlyCheckboxItem({
    super.key,
    required this.label,
    required this.isChecked,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: isChecked ? const Color(0xFF2CB887) : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color:
                    isChecked ? const Color(0xFF2CB887) : Colors.grey.shade400,
                width: 1.5,
              ),
            ),
            child: isChecked
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isChecked ? Colors.grey.shade700 : Colors.grey.shade500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
