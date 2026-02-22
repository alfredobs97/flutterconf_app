import 'package:flutter/material.dart';
import 'package:flutterconf/organizers/organizers.dart';
import 'package:flutterconf/settings/settings.dart';
import 'package:flutterconf/theme/widgets/fc_app_bar.dart';
import 'package:flutterconf/theme/widgets/theme_toggle.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(builder: (_) => const SettingsPage());
  }

  @override
  Widget build(BuildContext context) {
    return const SettingsView();
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headingStyle = theme.textTheme.titleMedium;
    return Scaffold(
      appBar: FCAppBar(title: const Text('Settings')),
      body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          children: [
            Text('Preferences', style: headingStyle),
            const ThemeToggle(),
            const SizedBox(height: 16),
            Text('Socials', style: headingStyle),
            ListTile(
              leading: const Icon(
                FontAwesomeIcons.linkedin,
                color: Colors.indigo,
              ),
              title: const Text('LinkedIn'),
              subtitle: const Text('@flutterconf'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => launchUrlString(
                'https://www.linkedin.com/company/flutterconf',
              ),
            ),
            ListTile(
              leading: const Icon(FontAwesomeIcons.xTwitter),
              title: const Text('X.com'),
              subtitle: const Text('@flutterconfes'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => launchUrlString('https://x.com/flutterconfes'),
            ),
            const SizedBox(height: 16),
            Text('About', style: headingStyle),

            ListTile(
              title: const Text('Website'),
              subtitle: const Text('View the official website'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => launchUrlString(
                'https://flutterconf.es/',
              ),
            ),
            ListTile(
              title: const Text('Organizers'),
              subtitle: const Text('View the conference organizers'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(OrganizersPage.route()),
            ),
            ListTile(
              title: const Text('Source Code'),
              subtitle: const Text('View the full source code on GitHub'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => launchUrlString(
                'https://github.com/alfredobs97/flutterconf_app',
              ),
            ),
            ListTile(
              title: const Text('Licenses'),
              subtitle: const Text('View the licenses of the libraries used'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => showLicensePage(
                context: context,
                applicationIcon: Image.asset(
                  'assets/logo.png',
                  height: 120,
                ),
                applicationName: 'FlutterConf',
              ),
            ),
            ListTile(
              title: const Text('Privacy Policy'),
              subtitle: const Text('View the privacy policy'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => launchUrlString(
                'https://github.com/alfredobs97/flutterconf_app/blob/main/privacy.md',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
