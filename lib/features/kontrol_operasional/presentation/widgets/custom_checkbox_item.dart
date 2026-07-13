import 'package:flutter/material.dart';

class CustomCheckboxItem extends StatelessWidget {
  final String label;
  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  const CustomCheckboxItem({
    super.key,
    required this.label,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: Checkbox(
              value: isChecked,
              onChanged: onChanged,
              activeColor: const Color(0xFF2CB887),
              checkColor: Colors.white,
              side: BorderSide(color: Colors.grey.withOpacity(0.4), width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isChecked
                      ? const Color(0xFF333333)
                      : Colors.grey.shade500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
