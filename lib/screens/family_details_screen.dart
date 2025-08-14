import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/family_member_model.dart';
import '../models/family_details_model.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/relation_dropdown.dart';
import '../repositories/local_storage.dart';

class FamilyDetailsScreen extends StatefulWidget {
  @override
  _FamilyDetailsScreenState createState() => _FamilyDetailsScreenState();
}

class _FamilyDetailsScreenState extends State<FamilyDetailsScreen> {
  List<FamilyMemberModel> members = [];
  final Color _maroon = Color(0xFF9b0b45);
  final Color _accent = Color(0xFFad0b45);
  final Color _muted = Color(0xFF8f8a8f);
  final Color _border = Color(0xFFe6e6e6);
  final Color _btnDisabled = Color(0xFFd0d0d0);
  final Color _bg = Color(0xFFfaf9fb);

  // State for the nominee address radio buttons
  bool _isNomineeAddressSame = true;


  @override
  void initState() {
    super.initState();
    final provider = Provider.of<OnboardingProvider>(context, listen: false);
    if (provider.family != null && provider.family!.members.isNotEmpty) {
      members = provider.family!.members.map((m) => FamilyMemberModel(id: m.id, name: m.name, relation: m.relation, age: m.age, occupation: m.occupation)).toList();
    } else {
      members = [];
    }
  }

  void _addMember() {
    setState(() {
      members.add(FamilyMemberModel(name: '', relation: 'Spouse', age: 1, occupation: ''));
    });
  }

  void _removeMember(int index) {
    setState(() {
      members.removeAt(index);
    });
  }

  void _saveAndContinue() async {
    // Validate members: allow zero members
    bool valid = true;
    for (var m in members) {
      if (!m.isValid()) {
        valid = false;
        break;
      }
    }
    if (!valid) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please ensure all family members have valid name and age')));
      return;
    }
    final provider = Provider.of<OnboardingProvider>(context, listen: false);
    final model = FamilyDetailsModel(employeeCode: provider.personal?.employeeCode ?? 'UNKNOWN', members: members);
    provider.updateFamily(model);
    await LocalStorage.saveFamily(model.toJson());
    Navigator.pushNamed(context, '/nominee');
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

                      // Nominee Details card
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
                            SizedBox(height: 6),
                            _buildLabel('Nominee Full Name'),
                            TextFormField(
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
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              ),
                            ),
                            _buildLabel('Relationship with Nominee'),
                            Container(
                              margin: EdgeInsets.only(bottom: 14),
                              decoration: BoxDecoration(
                                border: Border.all(color: _border),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: 'Select relationship with nominee',
                                  icon: Icon(Icons.keyboard_arrow_down, color: _muted),
                                  items: <String>['Select relationship with nominee', 'Spouse', 'Child', 'Parent', 'Sibling'].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        child: Text(value, style: TextStyle(color: value == 'Select relationship with nominee' ? Color(0xFFbfbfbf) : null)),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (_) {}, // No functionality yet
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
                                decoration: InputDecoration(
                                  hintText: 'dd/mm/yyyy',
                                  hintStyle: TextStyle(color: Color(0xFFbfbfbf)),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  suffixIcon: Icon(Icons.calendar_today, color: _muted),
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
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Add nominee link
                      GestureDetector(
                        onTap: () {}, // No functionality yet
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            '+ ADD NOMINEE DETAILS',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _accent,
                            ),
                          ),
                        ),
                      ),

                      // Proceed button
                      Container(
                        margin: EdgeInsets.only(top: 16),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/nominee');
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
}


//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(title: Text('Family Details')),
//         body: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Column(children: [
//             Expanded(
//                 child: ListView.builder(
//               itemCount: members.length,
//               itemBuilder: (context, idx) {
//                 final member = members[idx];
//                 return Card(
//                   margin: EdgeInsets.symmetric(vertical: 6),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(children: [
//                       TextFormField(
//                         initialValue: member.name,
//                         decoration: InputDecoration(labelText: 'Name', border: OutlineInputBorder(), isDense: true),
//                         onChanged: (v) => member.name = v,
//                       ),
//                       SizedBox(height: 8),
//                       RelationDropdown(
//                         value: member.relation,
//                         onChanged: (v) => setState(() => member.relation = v ?? 'Other'),
//                       ),
//                       SizedBox(height: 8),
//                       TextFormField(
//                         initialValue: member.age.toString(),
//                         decoration: InputDecoration(labelText: 'Age', border: OutlineInputBorder(), isDense: true),
//                         keyboardType: TextInputType.number,
//                         onChanged: (v) => member.age = int.tryParse(v) ?? 0,
//                       ),
//                       SizedBox(height: 8),
//                       TextFormField(
//                         initialValue: member.occupation ?? '',
//                         decoration: InputDecoration(labelText: 'Occupation', border: OutlineInputBorder(), isDense: true),
//                         onChanged: (v) => member.occupation = v,
//                       ),
//                       SizedBox(height: 8),
//                       Row(
//                         children: [
//                           Spacer(),
//                           IconButton(
//                             icon: Icon(Icons.delete, color: Colors.red),
//                             onPressed: () => _removeMember(idx),
//                           )
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
//                 ElevatedButton.icon(onPressed: _addMember, icon: Icon(Icons.add), label: Text('Add Member')),
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
