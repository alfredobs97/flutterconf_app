import 'package:flutter/material.dart';
import 'package:flutterconf/settings/settings.dart';

class FFAppBar extends AppBar {
  FFAppBar({Widget? title, List<Widget>? actions, super.bottom, super.key})
    : super(
        title:
            title ??
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Image.asset('assets/logo.png', height: kToolbarHeight),
            ),
        actions: actions ?? [const _SettingsButton()],
      );
}

class _SettingsButton extends StatelessWidget {
  const _SettingsButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings),
      onPressed: () => Navigator.of(context).push(SettingsPage.route()),
    );
  }
}
