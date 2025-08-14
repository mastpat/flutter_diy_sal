import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/onboarding_provider.dart';
import '../models/address_details_model.dart';
import '../widgets/state_district_dropdowns.dart';
import '../repositories/local_storage.dart';

class AddressDetailsScreen extends StatefulWidget {
  @override
  _AddressDetailsScreenState createState() => _AddressDetailsScreenState();
}

class _AddressDetailsScreenState extends State<AddressDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _addr1 = TextEditingController();
  final TextEditingController _addr2 = TextEditingController();
  String? _state;
  String? _district;
  final TextEditingController _city = TextEditingController();
  final TextEditingController _pincode = TextEditingController();
  final TextEditingController _landmark = TextEditingController();

  final Color _maroon = Color(0xFF9b0b45);
  final Color _accent = Color(0xFFad0b45);
  final Color _muted = Color(0xFF8f8a8f);
  final Color _border = Color(0xFFe6e6e6);
  final Color _btn = Color(0xFFa20f4a);
  final Color _bg = Color(0xFFfaf9fb);

  bool _isSameAddress = true;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<OnboardingProvider>(context, listen: false);
    final a = provider.address;
    if (a != null) {
      _addr1.text = a.addressLine1;
      _addr2.text = a.addressLine2 ?? '';
      _city.text = a.city;
      _state = a.state;
      _district = a.district;
      _pincode.text = a.pincode;
      _landmark.text = a.landmark ?? '';
    }
  }

  @override
  void dispose() {
    _addr1.dispose();
    _addr2.dispose();
    _city.dispose();
    _pincode.dispose();
    _landmark.dispose();
    super.dispose();
  }

  void _saveAndContinue() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = Provider.of<OnboardingProvider>(context, listen: false);
    final employeeCode = provider.personal?.employeeCode ?? 'UNKNOWN';
    final model = AddressDetailsModel(
      employeeCode: employeeCode,
      addressLine1: _addr1.text.trim(),
      addressLine2: _addr2.text.trim().isEmpty ? null : _addr2.text.trim(),
      city: _city.text.trim(),
      state: _state ?? '',
      district: _district ?? '',
      pincode: _pincode.text.trim(),
      landmark: _landmark.text.trim().isEmpty ? null : _landmark.text.trim(),
    );
    provider.updateAddress(model);
    await LocalStorage.saveAddress(model.toJson());
    Navigator.pushNamed(context, '/family');
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
          margin: EdgeInsets.all(0),
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
                          '2/3',
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
                            'Enter Address Details',
                            style: TextStyle(
                              color: _accent,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            'NEXT: ENTER FAMILY DETAILS',
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
                      // Permanent address card
                      _buildLabel('Permanent address'),
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
                                  '', // Strong tag in HTML is empty, so this text is empty.
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFd8f3dc),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Aadhaar fetched',
                                    style: TextStyle(
                                      color: Color(0xFF2b9348),
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            Text(
                              'E 303 Paramount Emotions, Sector - 1, Greater Noida West, 201306',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Residence Type Dropdown
                      _buildLabel('Residence Type'),
                      Container(
                        margin: EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          border: Border.all(color: _border),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: 'Placeholder', // Assuming a placeholder value
                            icon: Icon(Icons.keyboard_arrow_down, color: _muted),
                            items: <String>['Placeholder', 'Owned', 'Rented', 'Other'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(value, style: TextStyle(color: value == 'Placeholder' ? Color(0xFFbfbfbf) : null)),
                                ),
                              );
                            }).toList(),
                            onChanged: (_) {}, // No functionality yet
                          ),
                        ),
                      ),

                      // Communication address radio card
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
                              'Is your communication address same as permanent address?',
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
                                    groupValue: _isSameAddress,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _isSameAddress = value!;
                                      });
                                    },
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<bool>(
                                    title: Row(
                                      children: [
                                        Text('No', style: TextStyle(color: Colors.black)),
                                        Text(' (Update manually)', style: TextStyle(color: _muted, fontSize: 11)),
                                      ],
                                    ),
                                    value: false,
                                    groupValue: _isSameAddress,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _isSameAddress = value!;
                                      });
                                    },
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Proceed button
                      Container(
                        margin: EdgeInsets.only(top: 16),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/family');
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
}



// Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Address Details'),
  //     ),
  //     body: Padding(
  //       padding: const EdgeInsets.all(12.0),
  //       child: Form(
  //           key: _formKey,
  //           child: ListView(
  //             children: [
  //               TextFormField(
  //                 controller: _addr1,
  //                 decoration: InputDecoration(labelText: 'Address Line 1', border: OutlineInputBorder(), isDense: true),
  //                 validator: (v) {
  //                   if (v == null || v.trim().isEmpty) return 'Address Line 1 is required';
  //                   return null;
  //                 },
  //               ),
  //               SizedBox(height: 12),
  //               TextFormField(
  //                 controller: _addr2,
  //                 decoration: InputDecoration(labelText: 'Address Line 2 (optional)', border: OutlineInputBorder(), isDense: true),
  //               ),
  //               SizedBox(height: 12),
  //               StateDistrictDropdowns(
  //                 initialState: _state,
  //                 initialDistrict: _district,
  //                 onStateChanged: (s) => _state = s,
  //                 onDistrictChanged: (d) => _district = d,
  //               ),
  //               SizedBox(height: 12),
  //               TextFormField(
  //                 controller: _city,
  //                 decoration: InputDecoration(labelText: 'City', border: OutlineInputBorder(), isDense: true),
  //                 validator: (v) {
  //                   if (v == null || v.trim().isEmpty) return 'City is required';
  //                   return null;
  //                 },
  //               ),
  //               SizedBox(height: 12),
  //               TextFormField(
  //                 controller: _pincode,
  //                 decoration: InputDecoration(labelText: 'Pincode', border: OutlineInputBorder(), isDense: true),
  //                 keyboardType: TextInputType.number,
  //                 validator: (v) {
  //                   if (v == null || v.trim().isEmpty) return 'Pincode is required';
  //                   if (!AddressDetailsModel.isValidPincode(v.trim())) return 'Pincode must be 6 digits';
  //                   return null;
  //                 },
  //               ),
  //               SizedBox(height: 12),
  //               TextFormField(
  //                 controller: _landmark,
  //                 decoration: InputDecoration(labelText: 'Landmark (optional)', border: OutlineInputBorder(), isDense: true),
  //               ),
  //               SizedBox(height: 16),
  //               Row(
  //                 children: [
  //                   Expanded(child: ElevatedButton(child: Text('Save & Continue'), onPressed: _saveAndContinue)),
  //                   SizedBox(width: 12),
  //                   Expanded(child: TextButton(child: Text('Back'), onPressed: () => Navigator.of(context).pop())),
  //                 ],
  //               )
  //             ],
  //           )),
  //     ),
  //   );
  // }

