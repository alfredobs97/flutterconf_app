import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProfileQRDialog extends StatelessWidget {
  const ProfileQRDialog({
    required this.data,
    super.key,
  });

  final String data;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share Profile',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            QrImageView(
              data: data,
              size: 200,
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
