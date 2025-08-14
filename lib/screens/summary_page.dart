import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/onboarding_provider.dart';
import '../models/personal_details_model.dart';
import '../models/address_details_model.dart';
import '../models/family_details_model.dart';
import '../models/nominee_details_model.dart';
import '../repositories/local_storage.dart';

class SummaryPage extends StatefulWidget {
  @override
  _SummaryPageState createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  String? membershipIdLocal;
  // const SummaryScreen({Key? key}) : super(key: key);

  // Define colors from the HTML's CSS variables
  final Color _maroon = const Color(0xFF9b0b45);
  final Color _accent = const Color(0xFFad0b45);
  final Color _muted = const Color(0xFF8f8a8f);
  final Color _border = const Color(0xFFe6e6e6);
  final Color _btn = const Color(0xFFa20f4a);
  final Color _bg = const Color(0xFFfaf9fb);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Center(
        // Constrains the content to a max width of 420, similar to the HTML's `min(420px, 100%)`
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Container(
            margin: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x1F101828), // rgba(16, 24, 40, 0.12)
                  blurRadius: 30,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top bar section
                Container(
                  decoration: BoxDecoration(
                    color: _maroon,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                  child: Row(
                    children: [
                      // Back arrow icon
                      const Icon(Icons.arrow_back, color: Colors.white, size: 18),
                      const SizedBox(width: 12),
                      Text(
                        'AXIS BANK',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
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

                // Header section
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                  child: Text(
                    'Confirm your details',
                    style: TextStyle(
                      color: _accent,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                  child: Text(
                    'Go through your details before submitting',
                    style: TextStyle(
                      color: _muted,
                      fontSize: 13,
                    ),
                  ),
                ),

                // Main form content with all the summary cards
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView(
                      children: [
                        // Personal Details Card
                        _buildSummaryCard(
                          title: 'Personal Details',
                          actionText: 'Aadhaar fetched',
                          isAddAction: true,
                          children: [
                            _buildCardRow('Photo', 'VIEW', isLink: true),
                            _buildCardRow('Full Name', 'Ramesh Singh'),
                            _buildCardRow('Gender', 'Male'),
                            _buildCardRow('Date of Birth', '15/07/2015'),
                          ],
                        ),
                        // Personal Added Card
                        _buildSummaryCard(
                          title: 'Personal Added',
                          actionText: 'EDIT',
                          children: [
                            _buildCardRow('Marital Status', 'Married'),
                            _buildCardRow('Education', 'Masters'),
                            _buildCardRow('Occupation', 'Engineer'),
                            _buildCardRow('Industry', 'IT'),
                            _buildCardRow('Source of Funds', 'Salary'),
                            _buildCardRow('Experience', '10 Years'),
                          ],
                        ),
                        // Permanent Address Card
                        _buildSummaryCard(
                          title: 'Permanent Address',
                          actionText: 'Aadhaar fetched',
                          isAddAction: true,
                          children: [
                            _buildCardRow(
                                'E 303 Paramount Emotions, Sector - 1, Greater Noida West, 201306',
                                null),
                          ],
                        ),
                        // Communication Address Card
                        _buildSummaryCard(
                          title: 'Communication Address',
                          actionText: 'EDIT',
                          children: [
                            _buildCardRow('Flat no, Street, Locality, Pincode', null),
                          ],
                        ),
                        // Family Details Card
                        _buildSummaryCard(
                          title: 'Family Details',
                          actionText: 'EDIT',
                          children: [
                            _buildCardRow('Father\'s Name', 'Ramesh Singh'),
                            _buildCardRow('Mother\'s Name', 'Shilpa Singh'),
                          ],
                        ),
                        // Nominee Details Card
                        _buildSummaryCard(
                          title: 'Nominee Details',
                          actionText: 'EDIT',
                          children: [
                            _buildCardRow('Name', 'Ritika Singh'),
                            _buildCardRow('Relationship', 'Sister'),
                            _buildCardRow('Date of Birth', '15/03/1994'),
                            _buildCardRow('Address', 'House no. 2, street no. 3, ...'),
                          ],
                        ),

                        // Proceed Button
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          child: ElevatedButton(
                            onPressed: () {}, // No functionality yet
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _btn,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                            child: const Text('Proceed'),
                          ),
                        ),
                        const SizedBox(height: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget to build each summary card
  Widget _buildSummaryCard({
    required String title,
    required String actionText,
    bool isAddAction = false,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(10),
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
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {}, // No functionality yet
                child: Text(
                  actionText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isAddAction ? const Color(0xFF2b9348) : _accent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ...children,
        ],
      ),
    );
  }

  // Helper widget to build the rows inside the summary cards
  Widget _buildCardRow(String label, String? value, {bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF333333),
              ),
            ),
          ),
          if (value != null)
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color: isLink ? _accent : const Color(0xFF333333),
                fontWeight: isLink ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
        ],
      ),
    );
  }


  // @override
  // Widget build(BuildContext context) {
  //   final provider = Provider.of<OnboardingProvider>(context);
  //   final personal = provider.personal;
  //   final address = provider.address;
  //   final family = provider.family;
  //   final nominee = provider.nominee;
  //
  //   return Scaffold(
  //     appBar: AppBar(title: Text('Summary')),
  //     body: Padding(
  //       padding: const EdgeInsets.all(12.0),
  //       child: ListView(
  //         children: [
  //           _sectionCard(
  //             title: 'Personal Details',
  //             child: personal != null ? _buildPersonal(personal) : Text('No personal details'),
  //             onEdit: () => Navigator.pushNamed(context, '/personal'),
  //           ),
  //           _sectionCard(
  //             title: 'Address',
  //             child: address != null ? _buildAddress(address) : Text('No address details'),
  //             onEdit: () => Navigator.pushNamed(context, '/address'),
  //           ),
  //           _sectionCard(
  //             title: 'Family',
  //             child: family != null ? _buildFamily(family) : Text('No family members'),
  //             onEdit: () => Navigator.pushNamed(context, '/family'),
  //           ),
  //           _sectionCard(
  //             title: 'Nominees',
  //             child: nominee != null ? _buildNominees(nominee) : Text('No nominees'),
  //             onEdit: () => Navigator.pushNamed(context, '/nominee'),
  //           ),
  //           SizedBox(height: 12),
  //           ElevatedButton(
  //             child: Text('Submit Final (Local)'),
  //             onPressed: () => _submitFinalLocal(provider),
  //           ),
  //           SizedBox(height: 8),
  //           ElevatedButton.icon(
  //             icon: Icon(Icons.copy),
  //             label: Text('Copy Summary JSON'),
  //             onPressed: () => _copySummaryToClipboard(provider),
  //           ),
  //           if (membershipIdLocal != null) ...[
  //             SizedBox(height: 12),
  //             Text('Local Membership ID: $membershipIdLocal', style: TextStyle(fontWeight: FontWeight.bold)),
  //           ],
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _sectionCard({required String title, required Widget child, required VoidCallback onEdit}) {
  //   return Card(
  //     margin: EdgeInsets.symmetric(vertical: 8),
  //     child: Padding(
  //       padding: const EdgeInsets.all(12.0),
  //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //         Row(
  //           children: [
  //             Expanded(child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
  //             IconButton(icon: Icon(Icons.edit), onPressed: onEdit),
  //           ],
  //         ),
  //         SizedBox(height: 8),
  //         child,
  //       ]),
  //     ),
  //   );
  // }
  //
  // Widget _buildPersonal(PersonalDetailsModel p) {
  //   return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //     Text('Employee Code: ${p.employeeCode}'),
  //     Text('Name: ${p.firstName} ${p.lastName}'),
  //     Text('DOB: ${p.dob.toIso8601String().split('T').first}'),
  //     Text('Gender: ${p.gender}'),
  //     Text('Email: ${p.email ?? '-'}'),
  //     Text('Phone: ${p.phone}'),
  //   ]);
  // }
  //
  // Widget _buildAddress(AddressDetailsModel a) {
  //   return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //     Text('${a.addressLine1}'),
  //     if (a.addressLine2 != null && a.addressLine2!.isNotEmpty) Text('${a.addressLine2}'),
  //     Text('City: ${a.city}'),
  //     Text('State: ${a.state}'),
  //     Text('District: ${a.district}'),
  //     Text('Pincode: ${a.pincode}'),
  //     Text('Landmark: ${a.landmark ?? '-'}'),
  //   ]);
  // }
  //
  // Widget _buildFamily(FamilyDetailsModel f) {
  //   if (f.members.isEmpty) return Text('No members recorded');
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: f.members.map((m) => Text('${m.name} (${m.relation}) - Age: ${m.age}, ${m.occupation ?? ''}')).toList(),
  //   );
  // }
  //
  // Widget _buildNominees(NomineeDetailsModel n) {
  //   if (n.nominees.isEmpty) return Text('No nominees recorded');
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: n.nominees.map((m) => Text('${m.name} (${m.relation}) - Age: ${m.age}, Share: ${m.sharePercentage}%')).toList(),
  //   );
  // }
  //
  // Future<void> _submitFinalLocal(OnboardingProvider provider) async {
  //   final confirmed = await showDialog<bool>(
  //         context: context,
  //         builder: (c) => AlertDialog(
  //           title: Text('Confirm'),
  //           content: Text('This will mark onboarding completed locally. Proceed?'),
  //           actions: [
  //             TextButton(onPressed: () => Navigator.of(c).pop(false), child: Text('Cancel')),
  //             TextButton(onPressed: () => Navigator.of(c).pop(true), child: Text('Proceed')),
  //           ],
  //         ),
  //       ) ??
  //       false;
  //   if (!confirmed) return;
  //   await provider.markCompleted(true);
  //   await provider.saveAllToLocal();
  //   final ts = DateTime.now().millisecondsSinceEpoch;
  //   final mid = 'DIY_LOCAL_$ts';
  //   setState(() => membershipIdLocal = mid);
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Onboarding completed locally')));
  // }
  //
  // Future<void> _copySummaryToClipboard(OnboardingProvider provider) async {
  //   final map = {
  //     'personal': provider.personal?.toJson(),
  //     'address': provider.address?.toJson(),
  //     'family': provider.family?.toJson(),
  //     'nominee': provider.nominee?.toJson(),
  //     'onboarding_completed': provider.onboardingCompleted,
  //   };
  //   final jsonText = jsonEncode(map);
  //   await Clipboard.setData(ClipboardData(text: jsonText));
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Summary copied to clipboard')));
  // }
}
