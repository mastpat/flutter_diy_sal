import 'package:flutter/material.dart';
import '../models/account_opening_request.dart';
import '../services/account_opening_service.dart';

class AccountOpeningScreen extends StatefulWidget {
  @override
  State<AccountOpeningScreen> createState() => _AccountOpeningScreenState();
}

class _AccountOpeningScreenState extends State<AccountOpeningScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = AccountOpeningService();

  String mobile = "";
  String email = "";
  String aadhaar = "";
  String pan = "";
  bool agreed = false;

  void _submitForm() async {
    if (_formKey.currentState!.validate() && agreed) {
      final request = AccountOpeningRequest(
        mobileNumber: mobile,
        email: email,
        aadhaarNumber: aadhaar,
        panNumber: pan,
        agreedToTerms: agreed,
      );
      Navigator.pushNamed(context, '/steps');
      final success = await _service.submitRequest(request);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Account request submitted")));


      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Submission failed")));
      }
    }
  }

  Widget _buildVerifyField(String label, Function(String) onChanged) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(labelText: label),
            validator: (val) => val == null || val.isEmpty ? 'Required' : null,
            onChanged: onChanged,
          ),
        ),
        SizedBox(width: 8),
        ElevatedButton(onPressed: () {}, child: Text("VERIFY")),
      ],
    );
  }

  @override

  // version 3
  Widget build(BuildContext context) {
    const maroon = Color(0xFF9B0B45);
    const lightMaroon = Color(0xFFF6DBE3);
    const muted = Color(0xFF9B9B9B);
    const accent = Color(0xFFFF4D88);
    const border = Color(0xFFE6E6E6);
    const btnDisabled = Color(0xFFD0D0D0);

    final screenWidth = MediaQuery.of(context).size.width;

    // Card width: full for mobiles, fixed max for tablets/desktops
    double cardWidth = screenWidth < 600 ? screenWidth : 500;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(1),
          child: Container(
            width: cardWidth,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 28,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top bar
                Container(
                  color: maroon,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
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
                      const SizedBox(width: 8),
                      const Text(
                        "AXIS BANK",
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                      const Spacer(),
                      const Text(
                        "open | PRIME",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),

                // Hero card
                Container(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 6),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(155, 11, 69, 0.03),
                        Colors.transparent
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: lightMaroon,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Open New A/c",
                                style: TextStyle(
                                    fontSize: 18, color: Color(0xFF3B2D3B)),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Open a new salary account hassle free",
                                style: TextStyle(fontSize: 13, color: muted),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 120,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFE6F0), Colors.white],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Form
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      // Mobile number
                      _buildLabel("Mobile Number (Aadhaar linked)", muted),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInput(
                              initialValue: "+91 12345678",
                              border: border,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              "VERIFY",
                              style: TextStyle(
                                  color: accent, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Email
                      _buildLabel("Email ID", muted),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInput(
                              hintText: "e.g name@email.com",
                              border: border,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              "VERIFY",
                              style: TextStyle(
                                  color: accent, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Aadhaar
                      _buildLabel("Aadhar Number", muted),
                      _buildInput(
                        hintText: "Enter 12 digit Aadhar number",
                        filled: true,
                        fillColor: const Color(0xFFF1F1F1),
                        border: border,
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          side: BorderSide(color: border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text("I DON'T HAVE AN AADHAAR"),
                      ),
                      const SizedBox(height: 14),

                      // PAN
                      _buildLabel("PAN Number", muted),
                      _buildInput(
                        hintText: "Enter PAN number",
                        filled: true,
                        fillColor: const Color(0xFFF1F1F1),
                        border: border,
                      ),
                      const SizedBox(height: 14),

                      // Terms
                      Row(
                        children: [
                          Checkbox(value: false, onChanged: (_) {}),
                          const Expanded(
                            child: Text.rich(
                              TextSpan(
                                text: "I agree to all applicable ",
                                style: TextStyle(fontSize: 13, color: Color(0xFF7A7A7A)),
                                children: [
                                  TextSpan(
                                    text: "Terms & Conditions",
                                    style: TextStyle(
                                      color: accent,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Proceed
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: maroon,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/steps');
                          },
                          child: const Text(
                            "Proceed",
                            style: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, color: color),
      ),
    );
  }

  Widget _buildInput({
    String? hintText,
    String? initialValue,
    bool filled = false,
    Color fillColor = Colors.white,
    required Color border,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        hintText: hintText,
        filled: filled,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: border),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: border),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      style: const TextStyle(fontSize: 14),
    );
  }

  //version 3 end

  // Version 2 design

  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     body: SingleChildScrollView(
  //       padding: const EdgeInsets.all(20),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           const SizedBox(height: 40),
  //           // Top Image
  //           Center(
  //             child: Column(
  //               children: [
  //                 Image.asset(
  //                   'assets/bank_img.png', // Replace with your asset
  //                   height: 150,
  //                 ),
  //                 const SizedBox(height: 10),
  //                 const Text(
  //                   "Open New A/c",
  //                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
  //                 ),
  //                 const Text(
  //                   "Open a new salary account hassle free",
  //                   style: TextStyle(color: Colors.grey),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           const SizedBox(height: 30),
  //
  //           // Mobile Number
  //           Row(
  //             children: [
  //               Expanded(
  //                 flex: 3,
  //                 child: TextFormField(
  //                   initialValue: "+91 12345678",
  //                   decoration: InputDecoration(
  //                     labelText: "Mobile Number (Aadhaar linked)",
  //                     border: OutlineInputBorder(),
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(width: 10),
  //               ElevatedButton(
  //                 onPressed: () {},
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: Colors.pink,
  //                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  //                 ),
  //                 child: const Text("VERIFY"),
  //               )
  //             ],
  //           ),
  //           const SizedBox(height: 15),
  //
  //           // Email ID
  //           Row(
  //             children: [
  //               Expanded(
  //                 flex: 3,
  //                 child: TextFormField(
  //                   decoration: InputDecoration(
  //                     labelText: "Email ID",
  //                     hintText: "e.g name@email.com",
  //                     border: OutlineInputBorder(),
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(width: 10),
  //               ElevatedButton(
  //                 onPressed: () {},
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: Colors.pink,
  //                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  //                 ),
  //                 child: const Text("VERIFY"),
  //               )
  //             ],
  //           ),
  //           const SizedBox(height: 15),
  //
  //           // Aadhaar Number
  //           TextFormField(
  //             decoration: InputDecoration(
  //               labelText: "Aadhaar Number",
  //               hintText: "Enter 12 digit Aadhaar number",
  //               border: OutlineInputBorder(),
  //             ),
  //           ),
  //           const SizedBox(height: 10),
  //
  //           // PAN Number
  //           TextFormField(
  //             decoration: InputDecoration(
  //               labelText: "PAN Number",
  //               hintText: "Enter PAN number",
  //               border: OutlineInputBorder(),
  //             ),
  //           ),
  //           const SizedBox(height: 15),
  //
  //           // Checkbox
  //           Row(
  //             children: [
  //               Checkbox(
  //                 value: agreed,
  //                 onChanged: (value) {
  //                   setState(() {
  //                     agreed = value ?? false;
  //                   });
  //                 },
  //               ),
  //               const Expanded(
  //                 child: Text.rich(
  //                   TextSpan(
  //                     text: "I agree to all applicable ",
  //                     children: [
  //                       TextSpan(
  //                         text: "Terms & Conditions",
  //                         style: TextStyle(color: Colors.pink),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               )
  //             ],
  //           ),
  //           const SizedBox(height: 20),
  //
  //           // Proceed Button
  //           SizedBox(
  //             width: double.infinity,
  //             child: ElevatedButton(
  //               onPressed: agreed ? () {Navigator.pushNamed(context, '/main');} : null,
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: Colors.grey[800],
  //                 padding: const EdgeInsets.symmetric(vertical: 15),
  //               ),
  //               child: const Text(
  //                 "Proceed",
  //                 style: TextStyle(fontSize: 16, color: Colors.white),
  //
  //               ),
  //             ),
  //
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }




  // original Version 1
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: Text("Open New A/c")),
  //     body: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Form(
  //         key: _formKey,
  //         child: ListView(
  //           children: [
  //             Text("Open a new salary account hassle free", style: TextStyle(fontSize: 16)),
  //             SizedBox(height: 20),
  //             _buildVerifyField("Mobile Number (Aadhaar linked)", (val) => mobile = val),
  //             SizedBox(height: 10),
  //             _buildVerifyField("Email ID", (val) => email = val),
  //             SizedBox(height: 10),
  //             TextFormField(
  //               decoration: InputDecoration(labelText: "Aadhaar Number"),
  //               keyboardType: TextInputType.number,
  //               validator: (val) => val == null || val.length != 12 ? 'Enter 12-digit Aadhaar' : null,
  //               onChanged: (val) => aadhaar = val,
  //             ),
  //             SizedBox(height: 10),
  //             TextFormField(
  //               decoration: InputDecoration(labelText: "PAN Number"),
  //               validator: (val) => val == null || val.isEmpty ? 'Required' : null,
  //               onChanged: (val) => pan = val,
  //             ),
  //             SizedBox(height: 10),
  //             CheckboxListTile(
  //               title: Text("I agree to all applicable Terms & Conditions"),
  //               value: agreed,
  //               onChanged: (val) => setState(() => agreed = val ?? false),
  //             ),
  //             SizedBox(height: 20),
  //             ElevatedButton(
  //               onPressed: _submitForm,
  //               child: Text("Proceed"),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
