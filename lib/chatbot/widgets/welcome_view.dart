import 'package:flutter/material.dart';
import 'package:flutterconf/chatbot/widgets/suggestion_chip.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({required this.onSuggestionTapped, super.key});

  final ValueChanged<String> onSuggestionTapped;

  static const _suggestions = [
    '📅 ¿Que hay en la agenda el primer día?',
    '💙 ¿Con que asistentes he conectado?',
    '⭐ ¿Que charlas tengo en favoritos?',
    '🔎 ¿Cómo llegar a la venue el segundo día?',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.0, 0.6],
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withValues(alpha: 0.6),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_awesome,
              size: 36,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Asistente Gemini',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pregúntame sobre la agenda, los ponentes\n'
            'o añade charlas a tus favoritos.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 36),
          Text(
            'Prueba a preguntar…',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: _suggestions
                .map(
                  (s) => SuggestionChip(
                    label: s,
                    onTap: () => onSuggestionTapped(s),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
