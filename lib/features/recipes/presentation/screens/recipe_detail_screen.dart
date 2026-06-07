import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/recipe.dart';
import '../providers/recipe_providers.dart';
import '../widgets/recipe_atoms.dart';

/// Second screen: full details for one recipe.
///
/// [preview] comes from the list so the header shows instantly, while the
/// single recipe endpoint is fetched for the full record.
class RecipeDetailScreen extends ConsumerStatefulWidget {
  const RecipeDetailScreen({
    super.key,
    required this.recipeId,
    required this.preview,
  });

  final int recipeId;
  final Recipe preview;

  @override
  ConsumerState<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends ConsumerState<RecipeDetailScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Explicit animation that drives the staggered entrance of each section.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(recipeDetailProvider(widget.recipeId));
    // Always render something: full record when ready, preview meanwhile.
    final recipe = detailAsync.value ?? widget.preview;
    const sectionCount = 5;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _Header(recipe: recipe, loading: detailAsync.isLoading),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Section(
                      controller: _controller,
                      index: 0,
                      count: sectionCount,
                      child: _TitleBlock(recipe: recipe),
                    ),
                    const SizedBox(height: 16),
                    _Section(
                      controller: _controller,
                      index: 1,
                      count: sectionCount,
                      child: _StatsCard(recipe: recipe),
                    ),
                    const SizedBox(height: 20),
                    if (recipe.tags.isNotEmpty ||
                        recipe.mealType.isNotEmpty) ...[
                      _Section(
                        controller: _controller,
                        index: 2,
                        count: sectionCount,
                        child: _TagsBlock(recipe: recipe),
                      ),
                      const SizedBox(height: 20),
                    ],
                    _Section(
                      controller: _controller,
                      index: 3,
                      count: sectionCount,
                      child: _IngredientsBlock(recipe: recipe),
                    ),
                    const SizedBox(height: 20),
                    _Section(
                      controller: _controller,
                      index: 4,
                      count: sectionCount,
                      child: _InstructionsBlock(recipe: recipe),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

/// Collapsing image header with a Hero shared with the list card.
class _Header extends StatelessWidget {
  const _Header({required this.recipe, required this.loading});

  final Recipe recipe;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 260,
      backgroundColor: AppTheme.cream,
      foregroundColor: Colors.white,
      bottom: loading
          ? const PreferredSize(
              preferredSize: Size.fromHeight(2),
              child: LinearProgressIndicator(minHeight: 2),
            )
          : null,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 56, vertical: 14),
        title: Text(
          recipe.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        background: Hero(
          tag: 'recipe-image-${recipe.id}',
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: recipe.image,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: AppTheme.cream),
                errorWidget: (context, url, error) => Container(
                  color: AppTheme.cream,
                  child: const Icon(Icons.restaurant_rounded,
                      size: 48, color: AppTheme.muted),
                ),
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black54],
                    stops: [0.55, 1.0],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Wraps a section in a fade and slide, staggered by [index].
class _Section extends StatelessWidget {
  const _Section({
    required this.controller,
    required this.index,
    required this.count,
    required this.child,
  });

  final AnimationController controller;
  final int index;
  final int count;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final start = (index / count) * 0.5;
    final animation = CurvedAnimation(
      parent: controller,
      curve: Interval(start, (start + 0.5).clamp(0.0, 1.0),
          curve: Curves.easeOutCubic),
    );
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.06),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }
}

class _TitleBlock extends StatelessWidget {
  const _TitleBlock({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(recipe.name, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(recipe.cuisine, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(width: 10),
            DifficultyBadge(difficulty: recipe.difficulty),
            const Spacer(),
            RatingLabel(rating: recipe.rating, reviewCount: recipe.reviewCount),
          ],
        ),
      ],
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            _Stat(
              icon: Icons.timer_outlined,
              value: '${recipe.prepTimeMinutes}',
              unit: 'min',
              label: 'Prep',
            ),
            const _StatDivider(),
            _Stat(
              icon: Icons.local_fire_department_rounded,
              value: '${recipe.cookTimeMinutes}',
              unit: 'min',
              label: 'Cook',
            ),
            const _StatDivider(),
            _Stat(
              icon: Icons.people_alt_rounded,
              value: '${recipe.servings}',
              label: 'Servings',
            ),
            const _StatDivider(),
            _Stat(
              icon: Icons.bolt_rounded,
              value: '${recipe.caloriesPerServing}',
              unit: 'kcal',
              label: 'Per serving',
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.icon,
    required this.value,
    required this.label,
    this.unit,
  });

  final IconData icon;
  final String value;
  final String? unit;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 20, color: AppTheme.terracotta),
          const SizedBox(height: 6),
          Text.rich(
            TextSpan(
              text: value,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: AppTheme.ink,
              ),
              children: [
                if (unit != null)
                  TextSpan(
                    text: ' $unit',
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 11,
                      color: AppTheme.muted,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 36, color: AppTheme.hairline);
  }
}

class _TagsBlock extends StatelessWidget {
  const _TagsBlock({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final labels = {...recipe.mealType, ...recipe.tags}.toList();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [for (final label in labels) Chip(label: Text(label))],
    );
  }
}

class _IngredientsBlock extends StatelessWidget {
  const _IngredientsBlock({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(icon: Icons.shopping_basket_outlined, text: 'Ingredients'),
        const SizedBox(height: 12),
        for (final item in recipe.ingredients)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 7),
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppTheme.terracotta,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(item,
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _InstructionsBlock extends StatelessWidget {
  const _InstructionsBlock({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(icon: Icons.menu_book_outlined, text: 'Instructions'),
        const SizedBox(height: 12),
        for (var i = 0; i < recipe.instructions.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 26,
                  height: 26,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppTheme.terracotta.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${i + 1}',
                    style: const TextStyle(
                      color: AppTheme.terracotta,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(recipe.instructions[i],
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 19, color: AppTheme.ink),
        const SizedBox(width: 8),
        Text(text, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}
