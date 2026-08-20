import 'package:flutter/material.dart';

import '../../models/candidate_place.dart';
import '../theme/app_theme.dart';

class PlaceImage extends StatelessWidget {
  const PlaceImage({
    super.key,
    required this.place,
    this.fit = BoxFit.cover,
    this.emojiSize = 30,
  });

  final CandidatePlace place;
  final BoxFit fit;
  final double emojiSize;

  @override
  Widget build(BuildContext context) {
    final imageUrl = place.imageUrl;
    if (imageUrl == null || imageUrl.isEmpty) return _fallback();

    return Image.network(
      imageUrl,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) => _fallback(),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const ColoredBox(
          color: AppTheme.mint,
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );
      },
    );
  }

  Widget _fallback() => ColoredBox(
        color: AppTheme.mint,
        child: Center(
          child: Text(place.imageEmoji, style: TextStyle(fontSize: emojiSize)),
        ),
      );
}
