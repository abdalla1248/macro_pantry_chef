import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/theme_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../pantry/data/models/recipe.dart';
import '../../../pantry/data/models/pantry_item.dart';
import '../../../pantry/presentation/cubit/pantry_cubit.dart';
import '../cubit/shopping_list_cubit.dart';
import '../cubit/shopping_list_state.dart';

/// Modal overlay that aggregates all ingredients from scheduled recipes and checks them against pantry stock.
class ShoppingListModal extends StatelessWidget {
  const ShoppingListModal({super.key, required this.plannedRecipes});

  final List<Recipe> plannedRecipes;

  List<RecipeIngredient> _compileMissingIngredients(
    List<Recipe> recipes,
    PantryCubit pantryCubit,
  ) {
    final pantry = pantryCubit.state.items;
    final Map<String, RecipeIngredient> missingMap = {};

    for (final recipe in recipes) {
      for (final ing in recipe.ingredients) {
        // Search for a pantry item matching this ingredient name
        final match = pantry.firstWhere(
          (p) =>
              p.name.toLowerCase().contains(ing.name.toLowerCase()) ||
              ing.name.toLowerCase().contains(p.name.toLowerCase()),
          orElse: () => const PantryItem(id: '', name: '', imageUrl: '', quantity: 0, unit: ''),
        );

        // If the item is not in pantry, or quantity is 0, add to shopping list
        if (match.name.isEmpty || match.quantity <= 0) {
          final key = ing.name.toLowerCase();
          if (missingMap.containsKey(key)) {
            final existing = missingMap[key]!;
            missingMap[key] = RecipeIngredient(
              name: existing.name,
              amount: '${existing.amount} + ${ing.amount}',
            );
          } else {
            missingMap[key] = ing;
          }
        }
      }
    }
    return missingMap.values.toList();
  }

  void _shareShoppingList(BuildContext context, List<RecipeIngredient> items) {
    if (items.isEmpty) return;
    final itemsText = items.map((i) => '• ${i.name} (${i.amount})').join('\n');
    final text = '🛒 Macro Pantry Chef — Shopping List:\n\n'
        '$itemsText\n\n'
        'Generated from my meal plan.';
    
    final messenger = ScaffoldMessenger.of(context);
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Shopping list copied to clipboard!'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.color;
    final textTheme = context.textTheme;
    final l10n = context.l10n;
    final pantryCubit = context.watch<PantryCubit>();

    final missingIngredients = _compileMissingIngredients(plannedRecipes, pantryCubit);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (ctx, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.containerMargin.w),
          child: Column(
            children: [
              SizedBox(height: 12.h),
              // Drag Indicator
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: scheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: AppSpacing.md.h),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.shoppingList,
                    style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.copy_outlined),
                        onPressed: () => _shareShoppingList(context, missingIngredients),
                        tooltip: 'Copy List',
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                l10n.missingIngredientsAggregated,
                style: AppTextStyles.labelSm(context).copyWith(color: scheme.onSurfaceVariant),
              ),
              SizedBox(height: AppSpacing.md.h),

              Expanded(
                child: missingIngredients.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle_outline, color: scheme.primary, size: 48.sp),
                            SizedBox(height: 8.h),
                            Text(
                              l10n.allIngredientsInStock,
                              style: AppTextStyles.labelMd(context).copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    : BlocBuilder<ShoppingListCubit, ShoppingListState>(
                        builder: (context, shoppingState) {
                          return ListView.builder(
                            controller: scrollController,
                            itemCount: missingIngredients.length,
                            itemBuilder: (context, index) {
                              final item = missingIngredients[index];
                              final isChecked = shoppingState.checkedItems.contains(item.name);
                              return Card(
                                color: isChecked ? scheme.surfaceContainerHighest : scheme.surfaceContainerLow,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                margin: EdgeInsets.only(bottom: 8.h),
                                child: ListTile(
                                  leading: Checkbox(
                                    value: isChecked,
                                    onChanged: (_) {
                                      context.read<ShoppingListCubit>().toggleItem(item.name);
                                    },
                                    activeColor: scheme.primary,
                                  ),
                                  title: Text(
                                    item.name,
                                    style: AppTextStyles.labelMd(context).copyWith(
                                      decoration: isChecked ? TextDecoration.lineThrough : null,
                                      color: isChecked ? scheme.onSurfaceVariant : null,
                                    ),
                                  ),
                                  trailing: Text(
                                    item.amount,
                                    style: AppTextStyles.labelSm(context).copyWith(
                                      color: isChecked ? scheme.onSurfaceVariant : scheme.primary,
                                      fontWeight: FontWeight.bold,
                                      decoration: isChecked ? TextDecoration.lineThrough : null,
                                    ),
                                  ),
                                  onTap: () {
                                    context.read<ShoppingListCubit>().toggleItem(item.name);
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
              // Clear checked items button
              BlocBuilder<ShoppingListCubit, ShoppingListState>(
                builder: (context, state) {
                  if (state.checkedItems.isEmpty) return const SizedBox.shrink();
                  return Padding(
                    padding: EdgeInsets.only(top: AppSpacing.sm.h, bottom: AppSpacing.md.h),
                    child: TextButton.icon(
                      onPressed: () => context.read<ShoppingListCubit>().clearCheckedItems(),
                      icon: const Icon(Icons.clear_all),
                      label: const Text('Clear Checked Items'),
                      style: TextButton.styleFrom(
                        foregroundColor: scheme.error,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
