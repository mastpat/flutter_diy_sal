import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/personal_details_model.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/date_picker_field.dart';
import '../widgets/dropdown_widget.dart';
import '../repositories/local_storage.dart';

class PersonalDetailsScreen extends StatefulWidget {
  @override
  _PersonalDetailsScreenState createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _employeeController = TextEditingController();
  final TextEditingController _firstController = TextEditingController();
  final TextEditingController _lastController = TextEditingController();
  DateTime? _dob;
  String? _gender;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // New form field controllers and values for the HTML design conversion
  String? _maritalStatus;
  String? _educationQualification;
  String? _occupation;
  String? _industryType;
  String? _sourceOfFund;
  final TextEditingController _yearsInEmploymentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<OnboardingProvider>(context, listen: false);
    if (provider.personal != null) {
      final p = provider.personal!;
      _employeeController.text = p.employeeCode;
      _firstController.text = p.firstName;
      _lastController.text = p.lastName;
      _dob = p.dob;
      _gender = p.gender;
      _emailController.text = p.email ?? '';
      _phoneController.text = p.phone;
    }
  }

  @override
  void dispose() {
    _employeeController.dispose();
    _firstController.dispose();
    _lastController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _yearsInEmploymentController.dispose();
    super.dispose();
  }

  void _saveAndContinue() async {
    if (!_formKey.currentState!.validate()) return;
    final model = PersonalDetailsModel(
      employeeCode: _employeeController.text.trim(),
      firstName: _firstController.text.trim(),
      lastName: _lastController.text.trim(),
      dob: _dob!,
      gender: _gender ?? 'Other',
      email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
      phone: _phoneController.text.trim(),
    );
    final provider = Provider.of<OnboardingProvider>(context, listen: false);
    provider.updatePersonal(model);
    await LocalStorage.savePersonal(model.toJson());
    Navigator.pushNamed(context, '/address');
  }

  @override
  Widget build(BuildContext context) {
    const maroon = Color(0xFF9B0B45);
    return Scaffold(
      body: Center(
        child: Container(
          width: 420,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top bar
              Container(
                color: Color(0xFF9b0b45), // --maroon
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
                        border: Border.all(color: Color(0xFFad0b45), width: 2), // --accent
                      ),
                      child: Center(
                        child: Text(
                          '1/3',
                          style: TextStyle(
                            color: Color(0xFFad0b45), // --accent
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
                            'Enter Personal Details',
                            style: TextStyle(
                              color: Color(0xFFad0b45), // --accent
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            'NEXT: ENTER ADDRESS DETAILS',
                            style: TextStyle(
                              color: Color(0xFF8f8a8f), // --muted
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
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        // Aadhaar fetched card
                        Container(
                          margin: EdgeInsets.only(bottom: 14),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFFe6e6e6)), // --border
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Personal Details',
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
                              _buildCardRow('Photo', 'VIEW'),
                              _buildCardRow('Full Name', 'Tarni Ramesh Singh'),
                              _buildCardRow('Gender', 'Female'),
                              _buildCardRow('Date of Birth', '15/07/2015'),
                            ],
                          ),
                        ),

                        // Dropdowns and input fields
                        _buildLabel('Marital Status'),
                        _buildDropdown(
                          'Select marital status',
                          _maritalStatus,
                          ['Single', 'Married', 'Divorced', 'Widowed'],
                              (value) {
                            setState(() {
                              _maritalStatus = value;
                            });
                          },
                        ),
                        _buildLabel('Education Qualification'),
                        _buildDropdown(
                          'Select education qualification',
                          _educationQualification,
                          ['High School', 'Bachelor\'s Degree', 'Master\'s Degree', 'PhD'],
                              (value) {
                            setState(() {
                              _educationQualification = value;
                            });
                          },
                        ),
                        _buildLabel('Occupation'),
                        _buildDropdown(
                          'Select Occupation',
                          _occupation,
                          ['Salaried', 'Self-employed', 'Student', 'Homemaker'],
                              (value) {
                            setState(() {
                              _occupation = value;
                            });
                          },
                        ),
                        _buildLabel('Industry Type/Nature of Business'),
                        _buildDropdown(
                          'Select industry type',
                          _industryType,
                          ['IT', 'Finance', 'Healthcare', 'Education'],
                              (value) {
                            setState(() {
                              _industryType = value;
                            });
                          },
                        ),
                        _buildLabel('Source of fund'),
                        _buildDropdown(
                          'Select source of funds',
                          _sourceOfFund,
                          ['Salary', 'Business', 'Investments', 'Inheritance'],
                              (value) {
                            setState(() {
                              _sourceOfFund = value;
                            });
                          },
                        ),
                        _buildLabel('No of years in employment/business'),
                        TextFormField(
                          controller: _yearsInEmploymentController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Enter Number of years',
                            hintStyle: TextStyle(color: Color(0xFFbfbfbf)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Color(0xFFe6e6e6)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Color(0xFFe6e6e6)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Color(0xFFad0b45)),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                        ),
                        SizedBox(height: 16),
                        // Proceed button
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/address');
                          }, // Currently disabled
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF9B0B45), // --btn-disabled
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
                        SizedBox(height: 18),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
              color: value == 'VIEW' ? Color(0xFFad0b45) : Color(0xFF333333),
              fontWeight: value == 'VIEW' ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 12),
      child: Text(
        text,
        style: TextStyle(
          color: Color(0xFF8f8a8f), // --muted
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildDropdown(
      String hintText,
      String? value,
      List<String> items,
      void Function(String?) onChanged,
      ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFe6e6e6)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFF8f8a8f)),
          hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              hintText,
              style: TextStyle(color: Color(0xFFbfbfbf)),
            ),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(item),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _employeeController = TextEditingController();
//   final TextEditingController _firstController = TextEditingController();
//   final TextEditingController _lastController = TextEditingController();
//   DateTime? _dob;
//   String? _gender;
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     final provider = Provider.of<OnboardingProvider>(context, listen: false);
//     if (provider.personal != null) {
//       final p = provider.personal!;
//       _employeeController.text = p.employeeCode;
//       _firstController.text = p.firstName;
//       _lastController.text = p.lastName;
//       _dob = p.dob;
//       _gender = p.gender;
//       _emailController.text = p.email ?? '';
//       _phoneController.text = p.phone;
//     }
//   }
//
//   @override
//   void dispose() {
//     _employeeController.dispose();
//     _firstController.dispose();
//     _lastController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     super.dispose();
//   }
//
//   void _saveAndContinue() async {
//     if (!_formKey.currentState!.validate()) return;
//     final model = PersonalDetailsModel(
//       employeeCode: _employeeController.text.trim(),
//       firstName: _firstController.text.trim(),
//       lastName: _lastController.text.trim(),
//       dob: _dob!,
//       gender: _gender ?? 'Other',
//       email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
//       phone: _phoneController.text.trim(),
//     );
//     final provider = Provider.of<OnboardingProvider>(context, listen: false);
//     provider.updatePersonal(model);
//     await LocalStorage.savePersonal(model.toJson());
//     Navigator.pushNamed(context, '/address');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Personal Details'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Form(
//             key: _formKey,
//             child: ListView(
//               children: [
//                 TextFormField(
//                   controller: _employeeController,
//                   decoration: InputDecoration(labelText: 'Employee Code', border: OutlineInputBorder(), isDense: true),
//                   validator: (v) {
//                     if (v == null || v.trim().isEmpty) return 'Employee code is required';
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 12),
//                 TextFormField(
//                   controller: _firstController,
//                   decoration: InputDecoration(labelText: 'First Name', border: OutlineInputBorder(), isDense: true),
//                   validator: (v) {
//                     if (v == null || v.trim().isEmpty) return 'First name is required';
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 12),
//                 TextFormField(
//                   controller: _lastController,
//                   decoration: InputDecoration(labelText: 'Last Name', border: OutlineInputBorder(), isDense: true),
//                 ),
//                 SizedBox(height: 12),
//                 DatePickerField(
//                   initialDate: _dob,
//                   onChanged: (d) => _dob = d,
//                   labelText: 'Date of Birth',
//                   firstDate: DateTime(1900),
//                   lastDate: DateTime.now(),
//                   validator: (d) {
//                     if (d == null) return 'Please pick your date of birth';
//                     if (!PersonalDetailsModel.isAdult(d)) return 'You must be 18 years or older';
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 12),
//                 DropdownWidget(
//                   label: 'Gender',
//                   value: _gender,
//                   items: ['Male', 'Female', 'Other'],
//                   onChanged: (v) => setState(() => _gender = v),
//                 ),
//                 SizedBox(height: 12),
//                 TextFormField(
//                   controller: _emailController,
//                   decoration: InputDecoration(labelText: 'Email (optional)', border: OutlineInputBorder(), isDense: true),
//                   validator: (v) {
//                     if (v == null || v.trim().isEmpty) return null;
//                     if (!PersonalDetailsModel.isValidEmail(v.trim())) return 'Enter a valid email';
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 12),
//                 TextFormField(
//                   controller: _phoneController,
//                   decoration: InputDecoration(labelText: 'Phone', border: OutlineInputBorder(), isDense: true),
//                   keyboardType: TextInputType.number,
//                   validator: (v) {
//                     if (v == null || v.trim().isEmpty) return 'Phone is required';
//                     if (!PersonalDetailsModel.isValidPhone(v.trim())) return 'Enter a 10 digit phone number';
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 16),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton(
//                         child: Text('Save & Continue'),
//                         onPressed: _saveAndContinue,
//                       ),
//                     ),
//                     SizedBox(width: 12),
//                     Expanded(
//                       child: TextButton(
//                         child: Text('Back'),
//                         onPressed: () => Navigator.of(context).pop(),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             )),
//       ),
//     );
//   }
// }
