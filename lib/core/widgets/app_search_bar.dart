import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/color_extensions.dart';

/// Search bar matching the Stitch design.
///
/// Rounded-full shape with a leading search icon, placeholder text,
/// and a trailing filter (tune) icon button in `primary` colour.
class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    super.key,
    this.hint,
    this.onChanged,
    this.onFilterTap,
    this.controller,
  });

  final String? hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: scheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withO(0.05),
            blurRadius: 4.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(width: 16.w),
          Icon(Icons.search, color: scheme.outline, size: 24.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 16.h),
                isDense: true,
              ),
            ),
          ),
          // Filter button
          Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: Material(
              color: scheme.primary,
              borderRadius: BorderRadius.circular(999.r),
              child: InkWell(
                onTap: onFilterTap,
                borderRadius: BorderRadius.circular(999.r),
                child: Padding(
                  padding: EdgeInsets.all(8.r),
                  child: Icon(
                    Icons.tune,
                    color: scheme.onPrimary,
                    size: 20.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
