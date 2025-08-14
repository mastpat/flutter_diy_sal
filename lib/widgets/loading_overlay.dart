import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final String? message;

  const LoadingOverlay({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(opacity: 0.6, child: ModalBarrier(dismissible: false, color: Colors.black)),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              if (message != null) ...[
                SizedBox(height: 12),
                Text(message!, style: TextStyle(color: Colors.white)),
              ]
            ],
          ),
        ),
      ],
    );
  }
}
