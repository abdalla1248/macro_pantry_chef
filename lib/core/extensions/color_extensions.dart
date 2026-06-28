import 'package:flutter/material.dart';

/// Extension providing a concise, non-deprecated way to set alpha on a [Color].
///
/// Flutter 3.12+ deprecated Color.withOpacity. This extension uses the
/// recommended [Color.withValues] API under the hood.
extension ColorAlpha on Color {
  /// Returns a new colour with the given [opacity] (0.0 – 1.0).
  Color withO(double opacity) => withValues(alpha: opacity);
}
