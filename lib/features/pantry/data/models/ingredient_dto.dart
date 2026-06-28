import '../../data/models/recipe.dart'; // RecipeIngredient is in recipe.dart

/// DTO representing an ingredient in the Spoonacular API response.
class IngredientDto {
  const IngredientDto({
    required this.name,
    required this.amount,
    required this.unit,
  });

  factory IngredientDto.fromJson(Map<String, dynamic> json) {
    return IngredientDto(
      name: json['name'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      unit: json['unit'] as String? ?? '',
    );
  }

  final String name;
  final double amount;
  final String unit;

  /// Converts this DTO to the domain entity [RecipeIngredient].
  RecipeIngredient toDomain() {
    final amountString = amount == amount.roundToDouble()
        ? amount.toInt().toString()
        : amount.toStringAsFixed(1);
    final unitString = unit.isNotEmpty ? ' $unit' : '';
    return RecipeIngredient(
      name: name,
      amount: '$amountString$unitString',
    );
  }
}
