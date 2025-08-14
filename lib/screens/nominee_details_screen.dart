import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/nominee_model.dart';
import '../models/nominee_details_model.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/relation_dropdown.dart';
import '../repositories/local_storage.dart';

class NomineeDetailsScreen extends StatefulWidget {
  @override
  _NomineeDetailsScreenState createState() => _NomineeDetailsScreenState();
}

class _NomineeDetailsScreenState extends State<NomineeDetailsScreen> {
  List<NomineeModel> nominees = [];

  // Define colors from the HTML's CSS variables
  final Color _maroon = Color(0xFF9b0b45);
  final Color _accent = Color(0xFFad0b45);
  final Color _muted = Color(0xFF8f8a8f);
  final Color _border = Color(0xFFe6e6e6);
  final Color _btn = Color(0xFFa20f4a);
  final Color _bg = Color(0xFFfaf9fb);

  // State for the nominee address radio buttons
  bool _isNomineeAddressSame = false;

  // Text controllers for the new nominee form fields
  final TextEditingController _nomineeNameController = TextEditingController(
      text: 'Ritika Singh');
  final TextEditingController _nomineeDobController = TextEditingController(
      text: '13/08/1994');

  String? _selectedRelationship = 'Sister';
  final List<String> _relationshipOptions = [
    'Sister',
    'Spouse',
    'Child',
    'Parent',
    'Sibling'
  ];


  @override
  void initState() {
    super.initState();
    final provider = Provider.of<OnboardingProvider>(context, listen: false);
    if (provider.nominee != null && provider.nominee!.nominees.isNotEmpty) {
      nominees = provider.nominee!.nominees.map((n) =>
          NomineeModel(id: n.id,
              name: n.name,
              relation: n.relation,
              age: n.age,
              sharePercentage: n.sharePercentage)).toList();
    } else {
      nominees = [];
    }
  }

  void _addNominee() {
    setState(() {
      nominees.add(NomineeModel(
          name: '', relation: 'Spouse', age: 1, sharePercentage: 0.0));
    });
  }

  void _removeNominee(int index) {
    setState(() {
      nominees.removeAt(index);
    });
  }

  void _saveAndContinue() async {
    if (nominees.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please add at least one nominee')));
      return;
    }
    bool valid = true;
    for (final n in nominees) {
      if (!n.isValid()) {
        valid = false;
        break;
      }
    }
    if (!valid) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please ensure all nominee entries are valid')));
      return;
    }
    final model = NomineeDetailsModel(employeeCode: Provider
        .of<OnboardingProvider>(context, listen: false)
        .personal
        ?.employeeCode ?? 'UNKNOWN', nominees: nominees);
    if (!model.validateTotalPercentage()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
          'Total share percentage across nominees must equal 100')));
      return;
    }
    final provider = Provider.of<OnboardingProvider>(context, listen: false);
    provider.updateNominee(model);
    await LocalStorage.saveNominee(model.toJson());
    Navigator.pushNamed(context, '/summary');
  }

  @override
  Widget build(BuildContext context) {
    // The main scaffold for the screen
    return Scaffold(
      backgroundColor: _bg,
      body: Center(
        // The main container that mimics the .phone class in the HTML
        child: Container(
          width: 420, // max-width of 420px for larger screens
          margin: EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Color(0x1F101828), // rgba(16, 24, 40, 0.12)
                blurRadius: 30,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top bar
              Container(
                decoration: BoxDecoration(
                  color: _maroon,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 18,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'AXIS BANK',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    Text(
                      'open | PRIME',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              // Header step
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: _accent, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          '3/3',
                          style: TextStyle(
                            color: _accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enter Family Details',
                            style: TextStyle(
                              color: _accent,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            'NEXT: YOU ARE DONE',
                            style: TextStyle(
                              color: _muted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Form content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView(
                    children: [
                      // Parent's Details card
                      Container(
                        margin: EdgeInsets.only(bottom: 14),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: _border),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Parent's Details",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'EDIT',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: _accent,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            _buildCardRow("Father's Name", 'Ramesh Singh'),
                            _buildCardRow("Mother's Name", 'Shilpa Singh'),
                          ],
                        ),
                      ),

                      // 1st Nominee Details - Display
                      Container(
                        margin: EdgeInsets.only(bottom: 14),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: _border),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "1st Nominee Details",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'EDIT',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: _accent,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'DELETE',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: _accent,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            _buildCardRow("Nominee Full Name", 'Ritika Singh'),
                            _buildCardRow("Relationship", 'Sister'),
                            _buildCardRow("Date of Birth", '15/03/1994'),
                            SizedBox(height: 6),
                            Text(
                              'Address',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF333333),
                              ),
                            ),
                            Text(
                              '(House name, street name, locality, district, pincode, state, country, POA type, POA no.)',
                              style: TextStyle(
                                fontSize: 11,
                                color: _muted,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 2nd Nominee Details - Form
                      Container(
                        margin: EdgeInsets.only(bottom: 14),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: _border),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "2nd Nominee Details",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'DELETE',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: _accent,
                                  ),
                                ),
                              ],
                            ),
                            _buildLabel('Nominee Full Name'),
                            TextFormField(
                              controller: _nomineeNameController,
                              decoration: InputDecoration(
                                hintText: 'eg. Ritika Singh',
                                hintStyle: TextStyle(color: Color(0xFFbfbfbf)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: _border),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: _border),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: _accent),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                isDense: true,
                              ),
                            ),
                            _buildLabel('Relationship with Nominee'),
                            Container(
                              height: 48,
                              decoration: BoxDecoration(
                                border: Border.all(color: _border),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: _selectedRelationship,
                                  icon: Icon(
                                      Icons.keyboard_arrow_down, color: _muted),
                                  items: _relationshipOptions.map((
                                      String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Text(value),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedRelationship = newValue;
                                    });
                                  },
                                ),
                              ),
                            ),
                            _buildLabel("Nominee's Date of Birth (As per PAN)"),
                            Container(
                              margin: EdgeInsets.only(bottom: 14),
                              decoration: BoxDecoration(
                                border: Border.all(color: _border),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextFormField(
                                controller: _nomineeDobController,
                                decoration: InputDecoration(
                                  hintText: 'dd/mm/yyyy',
                                  hintStyle: TextStyle(
                                      color: Color(0xFFbfbfbf)),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                  suffixIcon: Icon(
                                      Icons.calendar_today, color: _muted),
                                ),
                              ),
                            ),

                            // Nominee address radio card
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Color(0xFFf7f8fa),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Is your Nominee address same as your Permanent Aadhaar fetched address?',
                                    style: TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  _buildRadioGroup(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Proceed button
                      Container(
                        margin: EdgeInsets.only(top: 16),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/summary');
                          }, // No functionality yet
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _maroon,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                          child: Text('Proceed'),
                        ),
                      ),
                      SizedBox(height: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to build the labels
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 12),
      child: Text(
        text,
        style: TextStyle(
          color: _muted,
          fontSize: 12,
        ),
      ),
    );
  }

  // Helper widget to build the card rows
  Widget _buildCardRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF333333),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for the radio group
  Widget _buildRadioGroup() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: RadioListTile<bool>(
                title: const Text('Yes'),
                value: true,
                groupValue: _isNomineeAddressSame,
                onChanged: (bool? value) {
                  setState(() {
                    _isNomineeAddressSame = value!;
                  });
                },
                dense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: RadioListTile<bool>(
                title: const Text('No'),
                value: false,
                groupValue: _isNomineeAddressSame,
                onChanged: (bool? value) {
                  setState(() {
                    _isNomineeAddressSame = value!;
                  });
                },
                dense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          '(House name, street name, locality, district, pincode, state, country, POA type, POA no.)',
          style: TextStyle(
            fontSize: 11,
            color: _muted,
          ),
        ),
      ],
    );
  }
}
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(title: Text('Nominee Details')),
//         body: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Column(children: [
//             Expanded(
//                 child: ListView.builder(
//               itemCount: nominees.length,
//               itemBuilder: (context, idx) {
//                 final n = nominees[idx];
//                 return Card(
//                   margin: EdgeInsets.symmetric(vertical: 6),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(children: [
//                       TextFormField(
//                         initialValue: n.name,
//                         decoration: InputDecoration(labelText: 'Name', border: OutlineInputBorder(), isDense: true),
//                         onChanged: (v) => n.name = v,
//                       ),
//                       SizedBox(height: 8),
//                       RelationDropdown(
//                         value: n.relation,
//                         onChanged: (v) => setState(() => n.relation = v ?? 'Other'),
//                       ),
//                       SizedBox(height: 8),
//                       TextFormField(
//                         initialValue: n.age.toString(),
//                         decoration: InputDecoration(labelText: 'Age', border: OutlineInputBorder(), isDense: true),
//                         keyboardType: TextInputType.number,
//                         onChanged: (v) => n.age = int.tryParse(v) ?? 0,
//                       ),
//                       SizedBox(height: 8),
//                       TextFormField(
//                         initialValue: n.sharePercentage.toString(),
//                         decoration: InputDecoration(labelText: 'Share Percentage', border: OutlineInputBorder(), isDense: true),
//                         keyboardType: TextInputType.numberWithOptions(decimal: true),
//                         onChanged: (v) => n.sharePercentage = double.tryParse(v) ?? 0.0,
//                       ),
//                       SizedBox(height: 8),
//                       Row(
//                         children: [
//                           Spacer(),
//                           IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () => _removeNominee(idx))
//                         ],
//                       )
//                     ]),
//                   ),
//                 );
//               },
//             )),
//             SizedBox(height: 8),
//             Row(
//               children: [
//                 ElevatedButton.icon(onPressed: _addNominee, icon: Icon(Icons.add), label: Text('Add Nominee')),
//                 Spacer(),
//                 ElevatedButton(child: Text('Save & Continue'), onPressed: _saveAndContinue),
//               ],
//             ),
//             SizedBox(height: 8),
//             TextButton(child: Text('Back'), onPressed: () => Navigator.of(context).pop()),
//           ]),
//         ));
//   }
// }
