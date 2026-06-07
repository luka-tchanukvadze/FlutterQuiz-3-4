import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/recipe.dart';
import 'recipe_atoms.dart';

/// A list item for one recipe.
///
/// Uses [TweenAnimationBuilder] (an implicit animation) to fade and slide in,
/// staggered by [index], and a [Hero] so the photo flows into the detail
/// screen.
class RecipeCard extends StatelessWidget {
  const RecipeCard({
    super.key,
    required this.recipe,
    required this.index,
    required this.onTap,
  });

  final Recipe recipe;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final delay = (index % 12) * 60;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0, 1),
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 16),
            child: child,
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Thumbnail(recipe: recipe),
                const SizedBox(width: 12),
                Expanded(child: _Details(recipe: recipe)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'recipe-image-${recipe.id}',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: recipe.image,
          width: 96,
          height: 96,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(color: AppTheme.cream),
          errorWidget: (context, url, error) => Container(
            color: AppTheme.cream,
            child: const Icon(Icons.restaurant_rounded, color: AppTheme.muted),
          ),
        ),
      ),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          recipe.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Flexible(
              child: Text(
                recipe.cuisine,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const SizedBox(width: 8),
            DifficultyBadge(difficulty: recipe.difficulty),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 4,
          children: [
            MetaPill(
              icon: Icons.schedule_rounded,
              label: '${recipe.totalTimeMinutes} min',
            ),
            MetaPill(
              icon: Icons.local_fire_department_rounded,
              label: '${recipe.caloriesPerServing} kcal',
            ),
            RatingLabel(rating: recipe.rating),
          ],
        ),
      ],
    );
  }
}
