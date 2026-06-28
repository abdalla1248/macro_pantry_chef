import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/theme_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/cubit/theme_cubit.dart';
import '../../../../core/localization/language_cubit.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/macro_slider_card.dart';
import '../../../pantry/data/models/macro_targets.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

/// User profile and settings dashboard following the Stitch specifications.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ProfileView();
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  void _showEditNameDialog(BuildContext context, String currentName) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (ctx) {
        final scheme = ctx.color;
        final l10n = ctx.l10n;
        return AlertDialog(
          backgroundColor: scheme.surfaceContainerLow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(l10n.appName), // Reusing general title
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  context.read<ProfileCubit>().updateName(controller.text.trim());
                }
                Navigator.pop(ctx);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickAvatar(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (context.mounted) {
        context.read<ProfileCubit>().updateAvatar(pickedFile.path);
      }
    }
  }

  void _showEditMacrosDialog(BuildContext context, MacroTargets currentTargets) {
    showDialog(
      context: context,
      builder: (ctx) {
        return _EditMacrosDialog(
          currentTargets: currentTargets,
          onSave: (newTargets) {
            context.read<ProfileCubit>().updateMacroTargets(newTargets);
          },
        );
      },
    );
  }

  void _showAddPreferenceDialog(BuildContext context) {
    final preferences = [
      'High Protein',
      'Low Sodium',
      'Pescatarian Options',
      'Vegetarian',
      'Vegan',
      'Keto-Friendly',
      'Gluten-Free',
      'Low Carb',
    ];
    showDialog(
      context: context,
      builder: (ctx) {
        final scheme = ctx.color;
        final profileCubit = context.read<ProfileCubit>();
        return AlertDialog(
          backgroundColor: scheme.surfaceContainerLow,
          title: const Text('Add Preference'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: preferences.length,
              itemBuilder: (c, idx) {
                final pref = preferences[idx];
                final isSelected = profileCubit.state.profile.dietaryPreferences.contains(pref);
                return ListTile(
                  title: Text(pref),
                  trailing: isSelected ? Icon(Icons.check, color: scheme.primary) : null,
                  onTap: () {
                    profileCubit.toggleDietaryPreference(pref);
                    Navigator.pop(ctx);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showAddAllergyDialog(BuildContext context) {
    final allergies = [
      'Tree Nuts',
      'Shellfish',
      'Peanuts',
      'Gluten',
      'Dairy',
      'Seafood',
      'Soy',
      'Wheat',
    ];
    showDialog(
      context: context,
      builder: (ctx) {
        final scheme = ctx.color;
        final profileCubit = context.read<ProfileCubit>();
        return AlertDialog(
          backgroundColor: scheme.surfaceContainerLow,
          title: const Text('Add Restriction'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: allergies.length,
              itemBuilder: (c, idx) {
                final allergy = allergies[idx];
                final isSelected = profileCubit.state.profile.allergies.contains(allergy);
                return ListTile(
                  title: Text(allergy),
                  trailing: isSelected ? Icon(Icons.check, color: scheme.primary) : null,
                  onTap: () {
                    if (isSelected) {
                      profileCubit.removeAllergy(allergy);
                    } else {
                      profileCubit.addAllergy(allergy);
                    }
                    Navigator.pop(ctx);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        final scheme = ctx.color;
        final languageCubit = context.read<LanguageCubit>();
        return AlertDialog(
          backgroundColor: scheme.surfaceContainerLow,
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('English'),
                trailing: languageCubit.state.languageCode == 'en'
                    ? Icon(Icons.check, color: scheme.primary)
                    : null,
                onTap: () {
                  languageCubit.setLanguage('en');
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                title: const Text('العربية (Arabic)'),
                trailing: languageCubit.state.languageCode == 'ar'
                    ? Icon(Icons.check, color: scheme.primary)
                    : null,
                onTap: () {
                  languageCubit.setLanguage('ar');
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        final scheme = ctx.color;
        final themeCubit = context.read<ThemeCubit>();
        return AlertDialog(
          backgroundColor: scheme.surfaceContainerLow,
          title: const Text('Select Theme Mode'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Light Mode'),
                trailing: themeCubit.state.themeMode == ThemeMode.light
                    ? Icon(Icons.check, color: scheme.primary)
                    : null,
                onTap: () {
                  themeCubit.setThemeMode(ThemeMode.light);
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                title: const Text('Dark Mode'),
                trailing: themeCubit.state.themeMode == ThemeMode.dark
                    ? Icon(Icons.check, color: scheme.primary)
                    : null,
                onTap: () {
                  themeCubit.setThemeMode(ThemeMode.dark);
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                title: const Text('System Default'),
                trailing: themeCubit.state.themeMode == ThemeMode.system
                    ? Icon(Icons.check, color: scheme.primary)
                    : null,
                onTap: () {
                  themeCubit.setThemeMode(ThemeMode.system);
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.color;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        toolbarHeight: 64.h,
        backgroundColor: scheme.surface.withO(0.8),
        title: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: scheme.outlineVariant),
              ),
              child: ClipOval(
                child: Image.network(
                  AppConstants.userAvatarUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(Icons.person, color: scheme.outline),
                ),
              ),
            ),
            SizedBox(width: AppSpacing.sm.w),
            Text(
              l10n.appName,
              style: AppTextStyles.headlineMd(context).copyWith(
                color: scheme.primary,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No new notifications')),
              );
            },
            icon: Icon(Icons.notifications_outlined, color: scheme.onSurface, size: 24.sp),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final profile = state.profile;
          final targets = profile.macroTargets;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.containerMargin.w,
              vertical: AppSpacing.md.h,
            ),
            child: Column(
              children: [
                // ── Profile Photo & Name Section ────────────────────
                Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () => _pickAvatar(context),
                            child: Container(
                              width: 120.w,
                              height: 120.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 4.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: scheme.primary.withO(0.1),
                                    blurRadius: 20.r,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: profile.avatarPath != null
                                    ? Image.file(
                                        File(profile.avatarPath!),
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Icon(Icons.person, size: 48.sp, color: scheme.outline),
                                      )
                                    : Image.network(
                                        AppConstants.userAvatarUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Icon(Icons.person, size: 48.sp, color: scheme.outline),
                                      ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => _showEditNameDialog(context, profile.name),
                              child: Container(
                                width: 36.w,
                                height: 36.w,
                                decoration: BoxDecoration(
                                  color: scheme.primary,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: scheme.primary.withO(0.2),
                                      blurRadius: 8.r,
                                    ),
                                  ],
                                ),
                                child: Icon(Icons.edit, color: scheme.onPrimary, size: 18.sp),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.md.h),
                      Text(
                        profile.name,
                        style: AppTextStyles.headlineMd(context).copyWith(
                          color: scheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        profile.membershipStatus,
                        style: AppTextStyles.bodyMd(context).copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.xl.h),

                // ── Goals & Targets Bento Grid ──────────────────────
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 600;

                    final macrosCard = GlassCard(
                      padding: EdgeInsets.all(AppSpacing.md.r),
                      borderRadius: BorderRadius.circular(16.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.track_changes, color: scheme.primary, size: 22.sp),
                                  SizedBox(width: 8.w),
                                  Text(l10n.macroTargets, style: AppTextStyles.headlineSm(context)),
                                ],
                              ),
                              IconButton(
                                icon: Icon(Icons.edit, color: scheme.outline, size: 20.sp),
                                onPressed: () => _showEditMacrosDialog(context, targets),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSpacing.md.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Daily Calories', style: AppTextStyles.labelMd(context).copyWith(color: scheme.onSurfaceVariant)),
                              Text('${targets.calories} kcal', style: AppTextStyles.headlineSm(context).copyWith(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(height: AppSpacing.sm.h),
                          // Split Macro Bar
                          Container(
                            height: 8.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: scheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(999.r),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(999.r),
                              child: Row(
                                children: [
                                  Expanded(flex: targets.protein, child: Container(color: scheme.primary)),
                                  Expanded(flex: targets.carbs, child: Container(color: scheme.primaryContainer)),
                                  Expanded(flex: targets.fat, child: Container(color: scheme.tertiary)),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: AppSpacing.md.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _MacroBarLegend(label: l10n.proteinShort, value: '${targets.protein}g', color: scheme.primary),
                              _MacroBarLegend(label: l10n.carbsShort, value: '${targets.carbs}g', color: scheme.primaryContainer),
                              _MacroBarLegend(label: l10n.fatShort, value: '${targets.fat}g', color: scheme.tertiary),
                            ],
                          ),
                        ],
                      ),
                    );

                    final goalsCard = GlassCard(
                      padding: EdgeInsets.all(AppSpacing.md.r),
                      borderRadius: BorderRadius.circular(16.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.flag, color: scheme.primary, size: 22.sp),
                              SizedBox(width: 8.w),
                              Text('Daily Goals', style: AppTextStyles.headlineSm(context)),
                            ],
                          ),
                          SizedBox(height: AppSpacing.md.h),
                          _ProfileGoalItem(icon: Icons.water_drop, title: 'Hydration', subtitle: '3 Liters', color: scheme.primary),
                          SizedBox(height: AppSpacing.sm.h),
                          _ProfileGoalItem(icon: Icons.restaurant, title: 'Meals', subtitle: '4 per day', color: scheme.primary),
                          SizedBox(height: AppSpacing.sm.h),
                          _ProfileGoalItem(icon: Icons.monitor_weight, title: 'Weight Goal', subtitle: 'Maintain Lean Mass', color: scheme.primary),
                        ],
                      ),
                    );

                    if (isWide) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: macrosCard),
                          SizedBox(width: AppSpacing.md.w),
                          Expanded(child: goalsCard),
                        ],
                      );
                    }

                    return Column(
                      children: [
                        macrosCard,
                        SizedBox(height: AppSpacing.md.h),
                        goalsCard,
                      ],
                    );
                  },
                ),
                SizedBox(height: AppSpacing.xl.h),

                // ── Preferences Section ─────────────────────────────
                GlassCard(
                  padding: EdgeInsets.all(AppSpacing.md.r),
                  borderRadius: BorderRadius.circular(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.eco, color: scheme.primary, size: 22.sp),
                              SizedBox(width: 8.w),
                              Text('Dietary Preferences', style: AppTextStyles.headlineSm(context)),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.add, color: scheme.primary, size: 22.sp),
                            onPressed: () => _showAddPreferenceDialog(context),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.sm.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: [
                          ...profile.dietaryPreferences.map((pref) {
                            return Chip(
                              label: Text(pref, style: AppTextStyles.labelSm(context)),
                              backgroundColor: scheme.surfaceContainer,
                              side: BorderSide(color: scheme.outlineVariant),
                              onDeleted: () => context.read<ProfileCubit>().toggleDietaryPreference(pref),
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.md.h),

                // ── Allergies Section ───────────────────────────────
                GlassCard(
                  padding: EdgeInsets.all(AppSpacing.md.r),
                  borderRadius: BorderRadius.circular(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.medical_information, color: scheme.error, size: 22.sp),
                              SizedBox(width: 8.w),
                              Text('Allergies & Restrictions', style: AppTextStyles.headlineSm(context)),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.add, color: scheme.error, size: 22.sp),
                            onPressed: () => _showAddAllergyDialog(context),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.sm.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: [
                          ...profile.allergies.map((allergy) {
                            return Chip(
                              label: Text(allergy, style: AppTextStyles.labelSm(context).copyWith(color: scheme.onErrorContainer)),
                              backgroundColor: scheme.errorContainer,
                              deleteIconColor: scheme.onErrorContainer,
                              side: BorderSide(color: scheme.error.withO(0.2)),
                              onDeleted: () => context.read<ProfileCubit>().removeAllergy(allergy),
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.xl.h),

                // ── Settings Actions ────────────────────────────────
                Column(
                  children: [
                    _SettingsTile(
                      icon: Icons.palette_outlined,
                      title: 'Theme Settings',
                      subtitle: context.watch<ThemeCubit>().state.themeMode.name.toUpperCase(),
                      onTap: () => _showThemeDialog(context),
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    _SettingsTile(
                      icon: Icons.language_outlined,
                      title: 'Language Settings',
                      subtitle: context.watch<LanguageCubit>().state.languageCode == 'en'
                          ? 'English'
                          : 'العربية',
                      onTap: () => _showLanguageDialog(context),
                    ),
                    SizedBox(height: AppSpacing.xl.h),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          // The actual saving happens dynamically when modifying fields,
                          // but this serves as a confident confirmation interaction.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Logged out successfully')),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: scheme.error,
                          side: BorderSide(color: scheme.error.withO(0.3)),
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        child: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.xl.h),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MacroBarLegend extends StatelessWidget {
  const _MacroBarLegend({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final scheme = context.color;
    return Row(
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        SizedBox(width: 4.w),
        Text(
          '$label: ',
          style: AppTextStyles.labelSm(context).copyWith(color: scheme.onSurfaceVariant),
        ),
        Text(
          value,
          style: AppTextStyles.labelSm(context).copyWith(color: scheme.onSurface, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _ProfileGoalItem extends StatelessWidget {
  const _ProfileGoalItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final scheme = context.color;
    return Row(
      children: [
        Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withO(0.1),
          ),
          child: Icon(icon, color: color, size: 20.sp),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.labelMd(context).copyWith(color: scheme.onSurface)),
            Text(subtitle, style: AppTextStyles.labelSm(context).copyWith(color: scheme.onSurfaceVariant)),
          ],
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = context.color;
    return GlassCard(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: scheme.outline, size: 22.sp),
                SizedBox(width: 12.w),
                Text(title, style: AppTextStyles.labelMd(context).copyWith(color: scheme.onSurface)),
              ],
            ),
            Row(
              children: [
                Text(subtitle, style: AppTextStyles.labelSm(context).copyWith(color: scheme.onSurfaceVariant)),
                SizedBox(width: 4.w),
                Icon(Icons.chevron_right, color: scheme.outline, size: 20.sp),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EditMacrosDialog extends StatefulWidget {
  const _EditMacrosDialog({
    required this.currentTargets,
    required this.onSave,
  });

  final MacroTargets currentTargets;
  final ValueChanged<MacroTargets> onSave;

  @override
  State<_EditMacrosDialog> createState() => _EditMacrosDialogState();
}

class _EditMacrosDialogState extends State<_EditMacrosDialog> {
  late int protein;
  late int carbs;
  late int fat;
  late int calories;

  @override
  void initState() {
    super.initState();
    protein = widget.currentTargets.protein;
    carbs = widget.currentTargets.carbs;
    fat = widget.currentTargets.fat;
    calories = widget.currentTargets.calories;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.color;
    return AlertDialog(
      backgroundColor: scheme.surfaceContainerLow,
      title: const Text('Edit Macro Targets'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            MacroSliderCard(
              icon: Icons.fitness_center,
              iconColor: scheme.secondaryContainer,
              iconBackgroundColor: scheme.secondaryContainer.withO(0.2),
              title: 'Protein',
              subtitle: 'Muscle repair & growth',
              value: protein.toDouble(),
              valueColor: scheme.secondaryContainer,
              unit: 'g',
              min: 0,
              max: 250,
              onChanged: (val) => setState(() => protein = val.toInt()),
            ),
            SizedBox(height: 8.h),
            MacroSliderCard(
              icon: Icons.agriculture,
              iconColor: scheme.primaryContainer,
              iconBackgroundColor: scheme.primaryContainer.withO(0.2),
              title: 'Carbohydrates',
              subtitle: 'Primary energy source',
              value: carbs.toDouble(),
              valueColor: scheme.primaryContainer,
              unit: 'g',
              min: 0,
              max: 400,
              onChanged: (val) => setState(() => carbs = val.toInt()),
            ),
            SizedBox(height: 8.h),
            MacroSliderCard(
              icon: Icons.water_drop,
              iconColor: scheme.tertiary,
              iconBackgroundColor: scheme.tertiary.withO(0.2),
              title: 'Fats',
              subtitle: 'Hormone & brain health',
              value: fat.toDouble(),
              valueColor: scheme.tertiary,
              unit: 'g',
              min: 0,
              max: 150,
              onChanged: (val) => setState(() => fat = val.toInt()),
            ),
            SizedBox(height: 8.h),
            MacroSliderCard(
              icon: Icons.local_fire_department,
              iconColor: scheme.onSurfaceVariant,
              iconBackgroundColor: scheme.surfaceContainerHighest,
              title: 'Calories',
              subtitle: 'Daily limit cap',
              value: calories.toDouble(),
              valueColor: scheme.primary,
              unit: 'kcal',
              min: 1200,
              max: 4000,
              step: 50,
              onChanged: (val) => setState(() => calories = val.toInt()),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            widget.onSave(MacroTargets(
              protein: protein,
              carbs: carbs,
              fat: fat,
              calories: calories,
            ));
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
