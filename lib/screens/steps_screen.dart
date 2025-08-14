import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/onboarding_provider.dart';
import '../models/personal_details_model.dart';
import 'package:flutter/material.dart';


class StepsScreen extends StatelessWidget {
  const StepsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define colors from the HTML's CSS variables
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
            margin: const EdgeInsets.all(18),
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
                    padding: const EdgeInsets.all(16),
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
                        Expanded(
                          child: Container(
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
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
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