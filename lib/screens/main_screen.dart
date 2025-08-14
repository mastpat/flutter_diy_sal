import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/onboarding_provider.dart';
import '../models/personal_details_model.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

/// The main entry screen for onboarding. Shows summary and actions to start/continue.
class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OnboardingProvider>(context);

    String nameLine = 'No details yet';
    String codeLine = '';
    if (provider.personal != null) {
      nameLine = '${provider.personal!.firstName} ${provider.personal!.lastName}';
      codeLine = provider.personal!.employeeCode;
    }

    bool personalDone = provider.personal != null;
    bool addressDone = provider.address != null;
    bool familyDone = provider.family != null && provider.family!.members.isNotEmpty;
    bool nomineeDone = provider.nominee != null && provider.nominee!.nominees.isNotEmpty;

    final Color maroon = const Color(0xFF9b0b45);
    final Color lightMaroon = const Color(0xFFf6dbe3);
    final Color muted = const Color(0xFF8f8a8f);
    final Color accent = const Color(0xFFad0b45);
    final Color pageBg = const Color(0xFFfaf9fb);
    final Color border = const Color(0xFFe6e6e6);
    final Color cardBg = const Color(0xFFffffff);

    return Scaffold(
      backgroundColor: pageBg,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Container(
            margin: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: cardBg,
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
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                  decoration: BoxDecoration(
                    color: maroon,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14),
                    ),
                  ),
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
                      const SizedBox(width: 12),
                      const Text(
                        'AXIS BANK',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      const Text(
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

                // Hero section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        maroon.withOpacity(0.03),
                        Colors.white.withOpacity(0),
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Open New A/c',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF32303a),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Open a new salary account hassle free',
                              style: TextStyle(
                                color: muted,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 140,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color(0xFFffe6f0),
                              Colors.white,
                            ],
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.white,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Main content area
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 90),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'OPEN A NEW A/C IN SIMPLE STEPS :',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF666666),
                            letterSpacing: 0.6,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: border),
                            borderRadius: BorderRadius.circular(10),
                            color: cardBg,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x0A101828), // rgba(16, 24, 40, 0.04)
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _buildStep(
                                context,
                                stepNumber: 1,
                                title: 'Personal Details',
                                subtitle: 'Provide your name, DOB and contact details',
                                isFirst: true,
                              ),
                              _buildStep(
                                context,
                                stepNumber: 2,
                                title: 'Address Details',
                                subtitle: 'Current & permanent address for KYC',
                              ),
                              _buildStep(
                                context,
                                stepNumber: 3,
                                title: 'Family Details',
                                subtitle: 'Nominee and family information',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // Fixed proceed button at the bottom
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(1),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/personal');
            }, // No functionality yet
            style: ElevatedButton.styleFrom(
              backgroundColor: accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
              elevation: 0, // Removes the default shadow
            ),
            child: const Text('Proceed'),
          ),
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context, {
    required int stepNumber,
    required String title,
    required String subtitle,
    bool isFirst = false,
  }) {
    return Column(
      children: [
        if (!isFirst)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(color: Color(0xFFeeeeee), height: 1, thickness: 1),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFd8d0d3)),
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    '$stepNumber',
                    style: const TextStyle(
                      color: Color(0xFF6b6b6b),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: const Color(0xFF8f8a8f),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

//     return Scaffold(
//       appBar: AppBar(title: Text('DIY Journey - Main')),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           children: [
//             Card(
//               child: ListTile(
//                 leading: CircleAvatar(child: Icon(Icons.person)),
//                 title: Text(nameLine),
//                 subtitle: Text(codeLine.isNotEmpty ? 'Code: $codeLine' : 'No employee code'),
//               ),
//             ),
//             SizedBox(height: 12),
//             Expanded(
//               child: ListView(
//                 children: [
//                   _buildStepTile('Personal Details', personalDone, '/personal'),
//                   _buildStepTile('Address Details', addressDone, '/address'),
//                   _buildStepTile('Family Details', familyDone, '/family'),
//                   _buildStepTile('Nominee Details', nomineeDone, '/nominee'),
//                   _buildStepTile('Summary', provider.onboardingCompleted, '/summary'),
//                 ],
//               ),
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     child: Text('Start Onboarding'),
//                     onPressed: () {
//                       Navigator.pushNamed(context, '/personal');
//                     },
//                   ),
//                 ),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton(
//                     child: Text('Continue'),
//                     onPressed: () {
//                       // Navigate to the first incomplete screen
//                       if (!personalDone) {
//                         Navigator.pushNamed(context, '/personal');
//                         return;
//                       }
//                       if (!addressDone) {
//                         Navigator.pushNamed(context, '/address');
//                         return;
//                       }
//                       if (!familyDone) {
//                         Navigator.pushNamed(context, '/family');
//                         return;
//                       }
//                       if (!nomineeDone) {
//                         Navigator.pushNamed(context, '/nominee');
//                         return;
//                       }
//                       Navigator.pushNamed(context, '/summary');
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 8),
//             TextButton.icon(
//               icon: Icon(Icons.view_agenda),
//               label: Text('View Summary'),
//               onPressed: () {
//                 Navigator.pushNamed(context, '/summary');
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStepTile(String title, bool done, String route) {
//     return Card(
//       child: ListTile(
//         title: Text(title),
//         trailing: done ? Icon(Icons.check_circle, color: Colors.green) : Icon(Icons.radio_button_unchecked),
//         onTap: () {
//           Navigator.of(context).pushNamed(route);
//         },
//       ),
//     );
//   }
// }
