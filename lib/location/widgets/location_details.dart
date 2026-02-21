import 'package:flutter/material.dart';
import 'package:flutterconf/schedule/schedule.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LocationDetails extends StatelessWidget {
  const LocationDetails({required this.location, super.key});

  final Location location;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.location_on_outlined,
          size: 18,
          color: theme.colorScheme.primary,
        ),
        InkWell(
          onTap: () => launchUrlString(
            location.mapUrl ??
                'https://maps.google.com/?q=${location.coordinates.$1},${location.coordinates.$2}',
          ),
          child: Text(
            location.name,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
