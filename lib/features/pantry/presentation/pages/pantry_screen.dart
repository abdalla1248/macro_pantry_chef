import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';


import 'package:macro_pantry_chef/core/theme/app_spacing.dart';
import 'package:macro_pantry_chef/core/extensions/theme_extensions.dart';
import 'package:macro_pantry_chef/core/widgets/pantry_item_card.dart';
import '../cubit/pantry_cubit.dart';
import '../cubit/pantry_state.dart';

class PantryScreen extends StatelessWidget {
  const PantryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PantryCubit(),
      child: const _PantryView(),
    );
  }
}

class _PantryView extends StatelessWidget {
  const _PantryView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = context.color;
    final textTheme = context.textTheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header: "Your Pantry"
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.containerMargin.w,
                AppSpacing.md.h,
                AppSpacing.containerMargin.w,
                AppSpacing.sm.h,
              ),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.yourPantry,
                      style: textTheme.displayMedium?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    Text(
                      l10n.pantryDescription,
                      style: textTheme.bodyLarge?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Action Bar: Search & Add Manually
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.containerMargin.w,
                vertical: AppSpacing.md.h,
              ),
              sliver: SliverToBoxAdapter(
                child: const _PantryActionBar(),
              ),
            ),

            // Inventory Header
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.containerMargin.w,
              ),
              sliver: SliverToBoxAdapter(
                child: Text(
                  l10n.currentInventory,
                  style: textTheme.headlineSmall?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // Inventory List
            BlocBuilder<PantryCubit, PantryState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (state.filteredItems.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'No ingredients found.',
                        style: textTheme.bodyLarge?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: EdgeInsets.only(
                    left: AppSpacing.containerMargin.w,
                    right: AppSpacing.containerMargin.w,
                    top: AppSpacing.sm.h,
                    bottom: AppSpacing.xl.h,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = state.filteredItems[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: AppSpacing.md.h),
                          child: PantryItemCard(
                            name: item.name,
                            imageUrl: item.imageUrl,
                            quantity: item.quantity,
                            unit: item.unit,
                            protein: item.protein,
                            carbs: item.carbs,
                            fat: item.fat,
                            isLow: item.isLow,
                            onIncrement: () => context
                                .read<PantryCubit>()
                                .increaseQuantity(item.id),
                            onDecrement: () => context
                                .read<PantryCubit>()
                                .decreaseQuantity(item.id),
                          ),
                        );
                      },
                      childCount: state.filteredItems.length,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomAction(context),
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    final scheme = context.color;
    final l10n = context.l10n;

    return Container(
      padding: EdgeInsets.all(AppSpacing.containerMargin.w),
      decoration: BoxDecoration(
        color: scheme.surface,
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.05),
            offset: const Offset(0, -4),
            blurRadius: 16,
          ),
        ],
      ),
      child: SafeArea(
        child: FilledButton(
          onPressed: () => context.goNamed('macroFilter'),
          style: FilledButton.styleFrom(
            backgroundColor: scheme.primary,
            foregroundColor: scheme.onPrimary,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            elevation: 4,
            shadowColor: scheme.primary.withValues(alpha: 0.3),
          ),
          child: Text(
            l10n.savePantryInventory,
            style: context.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
        ),
      ),
    );
  }
}

class _PantryActionBar extends StatelessWidget {
  const _PantryActionBar();

  @override
  Widget build(BuildContext context) {
    final scheme = context.color;
    final l10n = context.l10n;

    return LayoutBuilder(builder: (context, constraints) {
      final isWide = constraints.maxWidth > 600;

      final searchField = TextField(
        onChanged: (value) => context.read<PantryCubit>().search(value),
        decoration: InputDecoration(
          hintText: l10n.searchIngredientsPlaceholder,
          hintStyle: TextStyle(color: scheme.outline),
          prefixIcon: Icon(Icons.search, color: scheme.onSurfaceVariant),
          filled: true,
          fillColor: scheme.surfaceContainerLowest,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(color: scheme.outlineVariant),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(color: scheme.outlineVariant),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(color: scheme.primary, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
        ),
      );

      final addButton = FilledButton.icon(
        onPressed: () {}, // Future phase
        icon: const Icon(Icons.add),
        label: Text(l10n.addManually),
        style: FilledButton.styleFrom(
          backgroundColor: scheme.surfaceContainerHigh,
          foregroundColor: scheme.primary,
          padding: EdgeInsets.symmetric(
            horizontal: 24.w,
            vertical: 16.h,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      );

      if (isWide) {
        return Row(
          children: [
            Expanded(child: searchField),
            SizedBox(width: AppSpacing.md.w),
            addButton,
          ],
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          searchField,
          SizedBox(height: AppSpacing.sm.h),
          addButton,
        ],
      );
    });
  }
}
