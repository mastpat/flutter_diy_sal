import 'package:flutter/material.dart';

class RelationDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;
  final FormFieldValidator<String>? validator;

  const RelationDropdown({Key? key, this.value, required this.onChanged, this.validator}) : super(key: key);

  static const List<String> relations = ["Spouse", "Child", "Parent", "Sibling", "Other"];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: 'Relation',
        border: OutlineInputBorder(),
        isDense: true,
      ),
      items: relations.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
      onChanged: onChanged,
      validator: validator ??
          (v) {
            if (v == null || v.isEmpty) return 'Please select a relation';
            return null;
          },
    );
  }
}
