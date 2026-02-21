import 'package:flutter/material.dart';
import 'package:flutterconf/speaker_details/speaker_details.dart';
import 'package:flutterconf/speakers/speakers.dart';

class SpeakerCard extends StatelessWidget {
  const SpeakerCard({required this.speaker, super.key});

  final Speaker speaker;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Hero(
                tag: speaker.name,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(speaker.avatar),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              speaker.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              speaker.title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => Navigator.of(context).push(
                SpeakerDetailsPage.route(speaker: speaker),
              ),
              child: const Text('View Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
