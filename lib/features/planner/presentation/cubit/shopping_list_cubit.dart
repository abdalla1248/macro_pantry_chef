import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'shopping_list_state.dart';

class ShoppingListCubit extends Cubit<ShoppingListState> {
  ShoppingListCubit() : super(ShoppingListState.initial()) {
    _loadState();
  }

  static const _storageKey = 'shopping_list_checked_items';

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final items = prefs.getStringList(_storageKey) ?? [];
    emit(state.copyWith(checkedItems: items.toSet()));
  }

  Future<void> toggleItem(String itemName) async {
    final newChecked = Set<String>.from(state.checkedItems);
    if (newChecked.contains(itemName)) {
      newChecked.remove(itemName);
    } else {
      newChecked.add(itemName);
    }
    
    emit(state.copyWith(checkedItems: newChecked));
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, newChecked.toList());
  }

  Future<void> clearCheckedItems() async {
    emit(state.copyWith(checkedItems: {}));
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
