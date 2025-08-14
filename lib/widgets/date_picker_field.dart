import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerField extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime?> onChanged;
  final String labelText;
  final FormFieldValidator<DateTime>? validator;

  const DatePickerField({
    Key? key,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    required this.onChanged,
    required this.labelText,
    this.validator,
  }) : super(key: key);

  @override
  _DatePickerFieldState createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  final TextEditingController _controller = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    if (_selectedDate != null) _controller.text = DateFormat('dd-MM-yyyy').format(_selectedDate!);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? now,
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _controller.text = DateFormat('dd-MM-yyyy').format(picked);
      });
      widget.onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.calendar_today),
        isDense: true,
      ),
      onTap: _pickDate,
      validator: (val) {
        if (widget.validator != null) {
          return widget.validator!(_selectedDate);
        }
        if (_selectedDate == null) return 'Please select ${widget.labelText}';
        return null;
      },
    );
  }
}
