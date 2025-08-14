import 'package:flutter/material.dart';

/// Minimal splash screen without validation checks.
/// This screen shows a logo briefly and immediately navigates to '/main'.
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Intentionally no checks are performed here.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: 600));
      Navigator.of(context).pushReplacementNamed('/startJourney');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue.shade50),
            padding: EdgeInsets.all(24),
            child: ClipOval(
              child: Image.network(
                'https://upload.wikimedia.org/wikipedia/commons/1/17/Google-flutter-logo.png',
                width: 96,
                height: 96,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: 16),
          CircularProgressIndicator(),
          SizedBox(height: 8),
          Text('Loading...', style: TextStyle(color: Colors.black54)),
        ]),
      ),
    );
  }
}
