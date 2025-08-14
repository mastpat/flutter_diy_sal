import 'package:flutter/material.dart';

typedef StringCallback = void Function(String);

/// Composite widget for State and District selection.
///
/// If a state has a list of districts defined, a district dropdown is shown.
/// Otherwise a free-text district TextFormField is shown.
class StateDistrictDropdowns extends StatefulWidget {
  final String? initialState;
  final String? initialDistrict;
  final ValueChanged<String> onStateChanged;
  final ValueChanged<String> onDistrictChanged;

  const StateDistrictDropdowns({
    Key? key,
    this.initialState,
    this.initialDistrict,
    required this.onStateChanged,
    required this.onDistrictChanged,
  }) : super(key: key);

  @override
  _StateDistrictDropdownsState createState() => _StateDistrictDropdownsState();
}

class _StateDistrictDropdownsState extends State<StateDistrictDropdowns> {
  static const Map<String, List<String>> statesToDistricts = {
    "Karnataka": ["Bengaluru Urban", "Mysuru", "Mangaluru"],
    "Maharashtra": ["Mumbai", "Pune", "Nagpur"],
    "Delhi": ["New Delhi"],
    "Tamil Nadu": ["Chennai", "Coimbatore"],
    "West Bengal": ["Kolkata", "Howrah"],
  };

  String? _selectedState;
  String? _selectedDistrict;
  final TextEditingController _districtController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedState = widget.initialState;
    _selectedDistrict = widget.initialDistrict;
    if (_selectedDistrict != null) _districtController.text = _selectedDistrict!;
  }

  @override
  void dispose() {
    _districtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final states = statesToDistricts.keys.toList()..sort();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: _selectedState,
          decoration: InputDecoration(
            labelText: 'State',
            border: OutlineInputBorder(),
            isDense: true,
          ),
          items: states.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
          onChanged: (val) {
            setState(() {
              _selectedState = val;
              _selectedDistrict = null;
              _districtController.text = '';
            });
            widget.onStateChanged(val ?? '');
          },
          validator: (v) {
            if (v == null || v.isEmpty) return 'Please select a state';
            return null;
          },
        ),
        const SizedBox(height: 12),
        Builder(builder: (context) {
          final districts = _selectedState != null ? statesToDistricts[_selectedState!] : null;
          if (districts != null && districts.isNotEmpty) {
            return DropdownButtonFormField<String>(
              value: _selectedDistrict,
              decoration: InputDecoration(
                labelText: 'District',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              items: districts.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedDistrict = val;
                });
                widget.onDistrictChanged(val ?? '');
              },
              validator: (v) {
                if (v == null || v.isEmpty) return 'Please select a district';
                return null;
              },
            );
          } else {
            return TextFormField(
              controller: _districtController,
              decoration: InputDecoration(
                labelText: 'District',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (val) => widget.onDistrictChanged(val),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Please enter a district';
                return null;
              },
            );
          }
        }),
      ],
    );
  }
}
