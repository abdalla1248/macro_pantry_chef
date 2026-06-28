import 'package:equatable/equatable.dart';

/// Represents a single ingredient in the user's pantry.
class PantryItem extends Equatable {
  const PantryItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.quantity,
    required this.unit,
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
    this.isLow = false,
  });

  final String id;
  final String name;
  final String imageUrl;
  final double quantity;
  final String unit;
  final double protein;
  final double carbs;
  final double fat;
  final bool isLow;

  PantryItem copyWith({
    String? id,
    String? name,
    String? imageUrl,
    double? quantity,
    String? unit,
    double? protein,
    double? carbs,
    double? fat,
    bool? isLow,
  }) {
    return PantryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      isLow: isLow ?? this.isLow,
    );
  }

  @override
  List<Object?> get props =>
      [id, name, imageUrl, quantity, unit, protein, carbs, fat, isLow];
}
