import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String label;
  final int? selectedValue; // Berubah jadi int karena pakai ID
  final List<DropdownMenuItem<int>> items; // Menerima widget menu langsung
  final ValueChanged<int?>? onChanged; // Jika null, dropdown otomatis disabled

  const CustomDropdown({
    super.key,
    required this.label,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Cek apakah dropdown sedang disabled (karena onChanged bernilai null)
    final bool isDisabled = onChanged == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
          child: Text(
            label,
            style: TextStyle(
                color: isDisabled ? Colors.grey.shade400 : Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            // Warna background jadi abu-abu kalau disabled
            color: isDisabled ? Colors.grey.shade100 : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDisabled
                  ? Colors.grey.shade300
                  : Colors.grey.withOpacity(0.3),
            ),
          ),
          child: DropdownButtonFormField<int>(
            value: selectedValue,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            hint: Text(
              '-- Choose option --',
              style: TextStyle(
                  color: isDisabled ? Colors.grey.shade400 : Colors.grey,
                  fontSize: 12),
            ),
            icon: Icon(Icons.keyboard_arrow_down,
                color: isDisabled ? Colors.grey.shade300 : Colors.grey),
            isExpanded: true,
            items: items,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
