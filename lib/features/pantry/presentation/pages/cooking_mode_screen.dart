import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../../core/extensions/theme_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/translated_text.dart';
import '../../../nutrition/presentation/cubit/macro_target_cubit.dart';

class CookingModeScreen extends StatefulWidget {
  const CookingModeScreen({super.key, required this.recipeId});

  final String recipeId;

  @override
  State<CookingModeScreen> createState() => _CookingModeScreenState();
}

class _CookingModeScreenState extends State<CookingModeScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Keep screen awake during cooking mode
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    // Allow screen to sleep when exiting cooking mode
    WakelockPlus.disable();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.color;
    final textTheme = context.textTheme;
    final l10n = context.l10n;
    
    final recipe = context.read<MacroTargetCubit>().getRecipeById(widget.recipeId);

    if (recipe == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.recipeNotFound)),
      );
    }

    final steps = recipe.instructions;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: TranslatedText(recipe.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        backgroundColor: scheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: scheme.onSurface),
            onPressed: () => context.pop(),
          ),
        ],
      ),
      body: steps.isEmpty
          ? Center(
              child: Text(
                'No instructions available for this recipe.',
                style: textTheme.titleMedium,
              ),
            )
          : Column(
              children: [
                // Progress Bar
                LinearProgressIndicator(
                  value: (_currentIndex + 1) / steps.length,
                  backgroundColor: scheme.surfaceContainerHighest,
                  color: scheme.primary,
                  minHeight: 8.h,
                ),
                
                SizedBox(height: AppSpacing.md.h),
                
                // Step Counter
                Text(
                  'Step ${_currentIndex + 1} of ${steps.length}',
                  style: textTheme.titleMedium?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                SizedBox(height: AppSpacing.lg.h),
                
                // PageView for Steps
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemCount: steps.length,
                    itemBuilder: (context, index) {
                      final step = steps[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl.w),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: AppSpacing.xl.h),
                              TranslatedText(
                                step.title,
                                textAlign: TextAlign.center,
                                style: textTheme.headlineMedium?.copyWith(
                                  color: scheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: AppSpacing.lg.h),
                              TranslatedText(
                                step.description,
                                textAlign: TextAlign.center,
                                style: textTheme.bodyLarge?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                  height: 1.6,
                                ),
                              ),
                              SizedBox(height: AppSpacing.xl.h * 2),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // Navigation Buttons
                Padding(
                  padding: EdgeInsets.all(AppSpacing.xl.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _currentIndex > 0
                          ? OutlinedButton.icon(
                              onPressed: () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              icon: const Icon(Icons.arrow_back),
                              label: const Text('Previous'),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                              ),
                            )
                          : const SizedBox.shrink(),
                      
                      _currentIndex < steps.length - 1
                          ? FilledButton.icon(
                              onPressed: () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              icon: const Icon(Icons.arrow_forward),
                              iconAlignment: IconAlignment.end,
                              label: const Text('Next Step'),
                              style: FilledButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                              ),
                            )
                          : FilledButton.icon(
                              onPressed: () {
                                context.pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Cooking Complete! Enjoy your meal!')),
                                );
                              },
                              icon: const Icon(Icons.check),
                              label: const Text('Finish'),
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
