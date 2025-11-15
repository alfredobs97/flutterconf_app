import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterconf/favorites/favorites.dart';
import 'package:flutterconf/schedule/schedule.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({required this.event, super.key});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<FavoritesCubit, FavoritesState, bool>(
      selector: (state) => state.events.contains(event),
      builder: (context, isFavorite) => IconButton(
        icon: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.pinkAccent : null,
        ),
        onPressed: () {
          context.read<FavoritesCubit>().toggleFavorite(event);
          HapticFeedback.mediumImpact();
        },
      ),
    );
  }
}
