import 'package:calender/core/helper/help_functions.dart';
import 'package:flutter/material.dart';

class DashboardDropdown extends StatelessWidget {
  const DashboardDropdown({
    super.key,
    required this.items,
    required this.onChanged, // Add this
    this.value, // Optional: to show current selection
  });

  final List<String>? items;
  final ValueChanged<String?> onChanged; // The callback function
  final String? value;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      validator: (value) => value == null ? 'Select an item' : null,
      initialValue: value,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items:
          dataIsNotEmpty(list: items)
              ? items?.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item, // This is what is returned to onChanged
                      child: Text(item),
                    );
                  }).toList() ??
                  []
              : [],

      onChanged: onChanged, // Pass the function through
    );
  }
}
