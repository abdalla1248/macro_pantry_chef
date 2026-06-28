import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/pantry_item.dart';
import 'pantry_state.dart';

/// Cubit managing the pantry inventory — CRUD operations and search.
class PantryCubit extends Cubit<PantryState> {
  PantryCubit() : super(const PantryState()) {
    _loadMockData();
  }

  void _loadMockData() {
    emit(state.copyWith(isLoading: true));

    final mockItems = <PantryItem>[
      const PantryItem(
        id: '1',
        name: 'Chicken Breast',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCt00Vnw44KZehfAlk7VB4WoKQ28gUNw7n_XimZgF96fhEZcUlXz0HA7hdR6Z4BxFxIPejWlhXIGAritEGaJobjXDwC2L-XCDZbhK5zVdPEhlhf0kujVL5FnJEwMO4f1TP6LynDZOM7VJRioy_y9MPAZqJ8GwQvAk4IrwhmNnSKjqJlaV01eF0w68zyjUEbJuHrnILJS_ChFJrOkrznAdWN5S4yz1c2qGKS_OChpDVDIfrCTzRD6DFmljXfvGn3m4iD5aCCkOJg7RI',
        quantity: 1.5,
        unit: 'kg',
        protein: 31,
        fat: 3.6,
      ),
      const PantryItem(
        id: '2',
        name: 'Jasmine Rice',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuARKEYul3ZvrTYTdmk5tpi8tXUaGC09Eh3AZJ5LQ82YOEIwrlD7406lHFF16-eQ4PbRDgDy6vbYV3PpxMVTdABo6C91g-8GrxwrckpUndMLMbtvcyRs5cQYw5ZCxEklrfB5EVrxbOI25aQuL_vXj657EnhBiVtDg0HpTVs1rBP03lG9aamk9eR9jnYNKWqqcekgXSmVbelyMJv3P6rdKwj8pFM_HsGgG42s5Pzs4jOoDLw8my9A-Nr5GTGrYLzIEiR0sQ5qQuNuPx4',
        quantity: 2.0,
        unit: 'kg',
        carbs: 45,
        protein: 4,
      ),
      const PantryItem(
        id: '3',
        name: 'Cherry Tomatoes',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAFIUzYOv9UuLjAmwIhcXBgHW6QX9XZk9KJj8P8lonp0b0BNv9X0nPizhdVq3778E_pDtM90eyR7xq-Bcg6oTNiYmCt8gTMBcHO8ZSFZLTPqqNBNRSa5PAy9Ow3hMjg73UP5pyL8LX7vsxa7_V9loQ3q6Mi4Z8GjNdWPTzq2rmjHeNp7uRlMFWhtdTJGn2hNFG9z5-pQGFt2_KHVQGoalG_kxf96eB7crTlw6bhNwdtW6g0UfGUAHF5VPaxwUBGM4LEoORbBIizLL4',
        quantity: 150,
        unit: 'g',
        isLow: true,
      ),
      const PantryItem(
        id: '4',
        name: 'Sweet Potato',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBgGDX-7M_mTGd1beDSQsdQYym1YNpqwtR0A-d5_HIkhbw3IaZ_tPdckImKkoEs7sV33-MVy2o_9y9ZiykzReSVrZvQbturNCxlAW4b8Im6Xm2uOgNhNQh45oAanPIWbo0teY65SMDSoXm9oqdqnYLKjZWEiYj-vk4WyreEGz3vpGgkWzZ7y5bu97otoRAC7sQt-_sQmHLzUrXgBU8w3yn2Uu_ZzoYQdjkMbnoupvBWRk70awXRxJCxvH5UL5ha3z7rBx2I78UP6L0',
        quantity: 1.0,
        unit: 'kg',
        carbs: 20,
        protein: 2,
      ),
      const PantryItem(
        id: '5',
        name: 'Quinoa',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCh6K0yutj4-fLtJwe22M6BW3cN64Bvn8ciT8NRYY7W9tHzTDcfUFQiSJCWh1Lq5jL9gJTEKiBXtZp8DLxvJnAgJ6RcOygm-KECTzZBCrGfU1e2Qa2fR8r16CP2eBGkh-bWSOM_cCL9yvtMbVUWKwxSkrrc5yys1JgCprXsIonO7BOmKNDnPpnRZ0-9fNjPJpHImFqJi_ctkPPVLxCzdRYV1whuf4yTUf6Et7K0d9z5kW5ZCu6Ld9_i9KVMhgeqF39z0twwFI5cY3s',
        quantity: 500,
        unit: 'g',
        carbs: 21,
        protein: 4.4,
        fat: 1.9,
      ),
    ];

    emit(state.copyWith(items: mockItems, isLoading: false));
  }

  /// Updates the search query and triggers re-filtering.
  void search(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  /// Increases the quantity of an item by a fixed step.
  void increaseQuantity(String itemId) {
    final updatedItems = state.items.map((item) {
      if (item.id == itemId) {
        final step = _stepForUnit(item.unit);
        return item.copyWith(quantity: item.quantity + step);
      }
      return item;
    }).toList();
    emit(state.copyWith(items: updatedItems));
  }

  /// Decreases the quantity of an item by a fixed step (min 0).
  void decreaseQuantity(String itemId) {
    final updatedItems = state.items.map((item) {
      if (item.id == itemId) {
        final step = _stepForUnit(item.unit);
        final newQty = (item.quantity - step).clamp(0.0, double.infinity);
        return item.copyWith(quantity: newQty);
      }
      return item;
    }).toList();
    emit(state.copyWith(items: updatedItems));
  }

  /// Removes an item from the pantry.
  void removeItem(String itemId) {
    final updatedItems =
        state.items.where((item) => item.id != itemId).toList();
    emit(state.copyWith(items: updatedItems));
  }

  double _stepForUnit(String unit) {
    switch (unit) {
      case 'kg':
        return 0.5;
      case 'g':
        return 50;
      default:
        return 1;
    }
  }
}
