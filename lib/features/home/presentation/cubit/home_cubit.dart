import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_state.dart';

/// Manages the Home dashboard state.
///
/// Phase 1: Emits static placeholder data immediately.
/// Phase 3+: Will integrate with Spoonacular repository.
class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState.initial());

  /// Reload / refresh data (no-op for Phase 1).
  Future<void> loadData() async {
    emit(state.copyWith(status: HomeStatus.loading));

    // Phase 1 — placeholder data is already in the initial state.
    await Future<void>.delayed(const Duration(milliseconds: 300));

    emit(state.copyWith(status: HomeStatus.loaded));
  }
}
