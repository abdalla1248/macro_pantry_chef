import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/theme_extensions.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Main shell providing the bottom navigation bar.
///
/// Uses [StatefulNavigationShell] from GoRouter to preserve
/// each branch's navigation state independently.
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final scheme = context.color;
    final l10n = context.l10n;
    final currentIndex = navigationShell.currentIndex;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: scheme.surface.withO(0.8),
          border: Border(
            top: BorderSide(
              color: Colors.white.withO(0.1),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: scheme.primary.withO(0.05),
              blurRadius: 20.r,
              offset: Offset(0, -4.h),
            ),
          ],
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16.r),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16.r),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 2.w,
                vertical: 2.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    label: l10n.navHome,
                    isActive: currentIndex == 0,
                    onTap: () => _onTap(0),
                  ),
                  _NavItem(
                    icon: Icons.kitchen_outlined,
                    activeIcon: Icons.kitchen,
                    label: l10n.navPantry,
                    isActive: currentIndex == 1,
                    onTap: () => _onTap(1),
                  ),
                  _NavItem(
                    icon: Icons.calendar_today_outlined,
                    activeIcon: Icons.calendar_today,
                    label: l10n.navPlanner,
                    isActive: currentIndex == 2,
                    onTap: () => _onTap(2),
                  ),
                  _NavItem(
                    icon: Icons.favorite_border,
                    activeIcon: Icons.favorite,
                    label: l10n.navFavorites,
                    isActive: currentIndex == 3,
                    onTap: () => _onTap(3),
                  ),
                  _NavItem(
                    icon: Icons.person_outline,
                    activeIcon: Icons.person,
                    label: l10n.navProfile,
                    isActive: currentIndex == 4,
                    onTap: () => _onTap(4),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

/// A single bottom navigation item matching the Stitch design.
///
/// Active state: pill-shaped `primaryContainer` background with filled icon.
/// Inactive state: outlined icon with `onSurfaceVariant` colour.
class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = context.color;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 16.w : 16.w,
          vertical: 6.h,
        ),
        decoration: BoxDecoration(
          color: isActive ? scheme.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive
                  ? scheme.onPrimaryContainer
                  : scheme.onSurfaceVariant,
              size: 24.sp,
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: AppTextStyles.labelSm(context).copyWith(
                color: isActive
                    ? scheme.onPrimaryContainer
                    : scheme.onSurfaceVariant,
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
