import 'package:flutter/material.dart';

/// Reusable dropdown widget for forms.
class DropdownWidget extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final FormFieldValidator<String>? validator;
  final String? hint;

  const DropdownWidget({
    Key? key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(),
        isDense: true,
      ),
      items: items.map((i) {
        return DropdownMenuItem<String>(
          value: i,
          child: Text(i),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator ??
          (v) {
            if (v == null || v.isEmpty) return 'Please select $label';
            return null;
          },
    );
  }
}
