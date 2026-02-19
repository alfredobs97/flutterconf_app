import 'package:flutter/material.dart';
import 'package:flutterconf/sponsors/sponsors.dart';
import 'package:flutterconf/theme/widgets/fc_app_bar.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SponsorsPage extends StatelessWidget {
  const SponsorsPage({super.key});

  @override
  Widget build(BuildContext context) => const SponsorsView();
}

class SponsorsView extends StatelessWidget {
  const SponsorsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: FCAppBar(), body: const SponsorsListView());
  }
}

class SponsorsListView extends StatelessWidget {
  const SponsorsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (platinumSponsors.isNotEmpty)
          const _SponsorTierSection(
            title: 'Platinum',
            sponsors: platinumSponsors,
            logoHeight: 100,
            spacing: 32,
          ),
        if (goldSponsors.isNotEmpty)
          const _SponsorTierSection(
            title: 'Gold',
            sponsors: goldSponsors,
            logoHeight: 80,
            spacing: 24,
          ),
        if (venuePartner.isNotEmpty)
          const _SponsorTierSection(
            title: 'Venue Partner',
            sponsors: venuePartner,
            logoHeight: 120,
            spacing: 20,
          ),
      ],
    );
  }
}

class _SponsorTierSection extends StatelessWidget {
  const _SponsorTierSection({
    required this.title,
    required this.sponsors,
    required this.logoHeight,
    required this.spacing,
  });

  final String title;
  final List<Sponsor> sponsors;
  final double logoHeight;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      height: 200,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 32),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: spacing,
              runSpacing: spacing,
              children: sponsors
                  .map(
                    (sponsor) => SponsorItem(
                      sponsor: sponsor,
                      height: logoHeight,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class SponsorItem extends StatelessWidget {
  const SponsorItem({required this.sponsor, required this.height, super.key});

  final Sponsor sponsor;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 300,
      child: InkWell(
        onTap: () => launchUrlString(sponsor.url),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: height,
              maxWidth: height * 2,
            ),
            child: Image.asset(
              sponsor.logo,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
