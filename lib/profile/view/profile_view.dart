import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterconf/auth/auth.dart';
import 'package:flutterconf/profile/models/user_profile.dart';
import 'package:flutterconf/profile/view/scanned_history_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({
    required this.profile,
    this.isMe = false,
    super.key,
  });

  final UserProfile profile;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final hasBio = profile.bio?.isNotEmpty ?? false;
    final hasSocials =
        (profile.linkedin?.isNotEmpty ?? false) ||
        (profile.twitter?.isNotEmpty ?? false) ||
        (profile.youtube?.isNotEmpty ?? false) ||
        (profile.medium?.isNotEmpty ?? false);
    final jobAndCompany =
        '${profile.jobRole ?? ''}'
        '${profile.company != null ? ' at ${profile.company}' : ''}';

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              const SizedBox(
                height: 100,
                width: double.infinity,
              ),
              Positioned(
                top: 50,
                left: 0,
                right: 0,
                child: Center(
                  child: Hero(
                    tag: 'profile-image-${profile.id}',
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.surface,
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: 0.1,
                            ),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: profile.photoUrl != null
                            ? NetworkImage(profile.photoUrl!)
                            : null,
                        child: profile.photoUrl == null
                            ? const Icon(Icons.person, size: 50)
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
          Center(
            child: Column(
              children: [
                Text(
                  profile.displayName ?? 'No Name',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (profile.jobRole != null || profile.company != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    jobAndCompany,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          if (profile.workStatus != WorkStatus.none) ...[
            Center(
              child: Chip(
                label: Text(
                  profile.workStatus == WorkStatus.hiring
                      ? 'Hiring'
                      : profile.workStatus == WorkStatus.busy
                      ? 'Busy'
                      : 'Looking for work',
                ),
                backgroundColor: profile.workStatus == WorkStatus.hiring
                    ? Colors.green.shade100
                    : profile.workStatus == WorkStatus.busy
                    ? Colors.orange.shade100
                    : Colors.blue.shade100,
                labelStyle: TextStyle(
                  color: profile.workStatus == WorkStatus.hiring
                      ? Colors.green.shade900
                      : profile.workStatus == WorkStatus.busy
                      ? Colors.orange.shade900
                      : Colors.blue.shade900,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          const SizedBox(height: 16),
          if (hasBio || hasSocials)
            Card(
              elevation: 0,
              color: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasBio) ...[
                      Text(
                        'Bio',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(
                                context,
                              ).colorScheme.primary,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        profile.bio!,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      if (hasSocials) const SizedBox(height: 24),
                    ],
                    if (hasSocials) ...[
                      Text(
                        'Socials',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(
                                context,
                              ).colorScheme.primary,
                            ),
                      ),
                      const SizedBox(height: 8),
                      if (profile.linkedin != null &&
                          profile.linkedin!.isNotEmpty)
                        _buildSocialTile(
                          context,
                          icon: FontAwesomeIcons.linkedin,
                          label: 'LinkedIn',
                          value: profile.linkedin!,
                          color: const Color(0xFF0077B5),
                        ),
                      if (profile.twitter != null &&
                          profile.twitter!.isNotEmpty)
                        _buildSocialTile(
                          context,
                          icon: FontAwesomeIcons.twitter,
                          label: 'Twitter',
                          value: profile.twitter!,
                          color: const Color(0xFF1DA1F2),
                        ),
                      if (profile.youtube != null &&
                          profile.youtube!.isNotEmpty)
                        _buildSocialTile(
                          context,
                          icon: FontAwesomeIcons.youtube,
                          label: 'YouTube',
                          value: profile.youtube!,
                          color: const Color(0xFFFF0000),
                        ),
                      if (profile.medium != null && profile.medium!.isNotEmpty)
                        _buildSocialTile(
                          context,
                          icon: FontAwesomeIcons.medium,
                          label: 'Medium',
                          value: profile.medium!,
                          color: const Color(0xFF000000),
                        ),
                    ],
                  ],
                ),
              ),
            ),
          const SizedBox(height: 24),
          if (isMe)
            Column(
              children: [
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () => context.push('/scan-qr'),
                    icon: const Icon(Icons.qr_code, size: 24),
                    label: const Text(
                      'Your QR',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      useSafeArea: true,
                      builder: (context) => const ScannedHistoryPage(),
                    );
                  },
                  icon: const Icon(Icons.history, size: 20),
                  label: const Text('View Scanned History'),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(
                      context,
                    ).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Log out'),
                        content: const Text(
                          'Are you sure you want to log out?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              context.read<AuthCubit>().logOut();
                            },
                            child: const Text(
                              'Log out',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text(
                    'Log out',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSocialTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: color),
      ),
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        value,
        style: Theme.of(context).textTheme.bodySmall,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Icon(
        Icons.chevron_right,
        size: 16,
        color: Theme.of(context).colorScheme.outline,
      ),
      onTap: () {
        final url = Uri.tryParse(value);
        if (url != null) {
          launchUrl(url);
        }
      },
    );
  }
}
