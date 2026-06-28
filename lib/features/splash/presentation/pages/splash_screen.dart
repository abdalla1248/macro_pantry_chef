import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/theme_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Animated splash screen matching the Stitch design.
///
/// - Blurred kitchen background image
/// - Surface overlay + gradient
/// - Floating glass-panel logo
/// - Fade-in-up title + tagline
/// - Three bouncing dots loader
/// - Auto-navigate to Home after [AppConstants.splashDuration]
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  late final AnimationController _floatController;
  late final Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();

    // ── Fade-in + slide-up ──────────────────────────────────────────
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    // ── Float animation ─────────────────────────────────────────────
    _floatController = AnimationController(
      vsync: this,
      duration: AppConstants.floatAnimationDuration,
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // ── Start animations ────────────────────────────────────────────
    _fadeController.forward();

    // ── Navigate to home after splash duration ──────────────────────
    Future.delayed(AppConstants.splashDuration, () {
      if (mounted) context.goNamed('home');
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.color;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Background Image ──────────────────────────────────────
          Image.network(
            AppConstants.splashBackgroundUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(color: scheme.surface),
          ),

          // ── Surface overlay with blur ─────────────────────────────
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              color: scheme.surface.withO(0.6),
            ),
          ),

          // ── Gradient overlay (bottom → transparent → top) ─────────
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  scheme.surface,
                  Colors.transparent,
                  scheme.surface.withO(0.3),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // ── Main Content ──────────────────────────────────────────
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.containerMargin.w,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── Floating Logo Container ───────────────────
                      AnimatedBuilder(
                        animation: _floatAnimation,
                        builder: (context, child) => Transform.translate(
                          offset: Offset(0, _floatAnimation.value),
                          child: child,
                        ),
                        child: _buildLogoContainer(scheme),
                      ),

                      SizedBox(height: AppSpacing.lg.h),

                      // ── Title ─────────────────────────────────────
                      Text(
                        context.l10n.appName,
                        style:
                            AppTextStyles.displayLgMobile(context).copyWith(
                          color: scheme.primary,
                          letterSpacing: -0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: AppSpacing.sm.h),

                      // ── Tagline ───────────────────────────────────
                      Text(
                        context.l10n.tagline,
                        style: AppTextStyles.bodyLg(context).copyWith(
                          color: scheme.onSurfaceVariant,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: AppSpacing.xl.h),

                      // ── Bouncing Dots ─────────────────────────────
                      _BouncingDots(color: scheme.primary),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoContainer(ColorScheme scheme) {
    return Container(
      width: 192.w,
      height: 192.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: (scheme.brightness == Brightness.dark
                ? Colors.white
                : scheme.surface)
            .withO(0.85),
        border: Border.all(
          color: Colors.white.withO(0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withO(0.05),
            blurRadius: 32.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.md.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.network(
                AppConstants.logoUrl,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => Icon(
                  Icons.restaurant,
                  size: 64.sp,
                  color: scheme.primary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Bouncing Dots ────────────────────────────────────────────────────────
class _BouncingDots extends StatefulWidget {
  const _BouncingDots({required this.color});

  final Color color;

  @override
  State<_BouncingDots> createState() => _BouncingDotsState();
}

class _BouncingDotsState extends State<_BouncingDots>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(3, (i) {
      final controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );

      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) controller.repeat(reverse: true);
      });

      return controller;
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _controllers[i],
          builder: (context, _) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color
                    .withO(0.4 + (_controllers[i].value * 0.6)),
              ),
              transform: Matrix4.translationValues(
                0,
                -8 * _controllers[i].value,
                0,
              ),
            );
          },
        );
      }),
    );
  }
}
