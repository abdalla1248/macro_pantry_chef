import 'package:equatable/equatable.dart';

import '../../data/models/pantry_item.dart';

/// State for the Pantry screen.
class PantryState extends Equatable {
  const PantryState({
    this.items = const [],
    this.searchQuery = '',
    this.isLoading = false,
  });

  final List<PantryItem> items;
  final String searchQuery;
  final bool isLoading;

  /// Items filtered by the current search query.
  List<PantryItem> get filteredItems {
    if (searchQuery.isEmpty) return items;
    final query = searchQuery.toLowerCase();
    return items
        .where((item) => item.name.toLowerCase().contains(query))
        .toList();
  }

  PantryState copyWith({
    List<PantryItem>? items,
    String? searchQuery,
    bool? isLoading,
  }) {
    return PantryState(
      items: items ?? this.items,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [items, searchQuery, isLoading];
}
