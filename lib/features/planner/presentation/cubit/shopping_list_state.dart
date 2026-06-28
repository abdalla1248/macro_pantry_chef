import 'package:equatable/equatable.dart';

class ShoppingListState extends Equatable {
  const ShoppingListState({
    required this.checkedItems,
  });

  /// Set of ingredient names that are checked off.
  final Set<String> checkedItems;

  factory ShoppingListState.initial() => const ShoppingListState(
        checkedItems: {},
      );

  ShoppingListState copyWith({
    Set<String>? checkedItems,
  }) {
    return ShoppingListState(
      checkedItems: checkedItems ?? this.checkedItems,
    );
  }

  @override
  List<Object?> get props => [checkedItems];
}
