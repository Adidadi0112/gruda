/// Ingredient model for structured ingredient data.
class Ingredient {
  final String name;
  final String? amount;
  final String? unit;

  const Ingredient({required this.name, this.amount, this.unit});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'] as String? ?? '',
      amount: json['amount'] as String?,
      unit: json['unit'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'amount': amount, 'unit': unit};
  }

  @override
  String toString() {
    final parts = <String>[];
    if (amount != null && amount!.isNotEmpty) parts.add(amount!);
    if (unit != null && unit!.isNotEmpty) parts.add(unit!);
    parts.add(name);
    return parts.join(' ');
  }
}

/// Instruction model for structured instruction steps.
class InstructionStep {
  final int step;
  final String text;

  const InstructionStep({required this.step, required this.text});

  factory InstructionStep.fromJson(Map<String, dynamic> json) {
    return InstructionStep(
      step: json['step'] as int? ?? 0,
      text: json['text'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'step': step, 'text': text};
  }
}

/// Domain model representing a meal in a 3-day meal prep plan.
class MealPlan {
  final String id;
  final String householdId;
  final String ownerId;
  final String recipeName;
  final DateTime mealDate;
  final String mealType; // 'breakfast', 'lunch', 'dinner', 'snack', 'dessert'
  final String?
  ingredients; // Comma-separated or multiline ingredients (legacy)
  final String? instructions; // Step-by-step cooking instructions (legacy)
  final List<Ingredient>
  ingredientsList; // Structured ingredients with amounts/units
  final List<InstructionStep> instructionsList; // Numbered instruction steps
  final String? notes;
  final String? prepGroupId; // UUID linking meals in a prep session
  final bool isMealPrep; // true for bulk meal preps
  final bool isHousehold;
  final DateTime createdAt;

  const MealPlan({
    required this.id,
    required this.householdId,
    required this.ownerId,
    required this.recipeName,
    required this.mealDate,
    required this.mealType,
    this.ingredients,
    this.instructions,
    this.ingredientsList = const [],
    this.instructionsList = const [],
    this.notes,
    this.prepGroupId,
    required this.isMealPrep,
    required this.isHousehold,
    required this.createdAt,
  });

  /// Create a copy of MealPlan with optional field overrides.
  MealPlan copyWith({
    String? id,
    String? householdId,
    String? ownerId,
    String? recipeName,
    DateTime? mealDate,
    String? mealType,
    String? ingredients,
    String? instructions,
    List<Ingredient>? ingredientsList,
    List<InstructionStep>? instructionsList,
    String? notes,
    String? prepGroupId,
    bool? isMealPrep,
    bool? isHousehold,
    DateTime? createdAt,
  }) {
    return MealPlan(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      ownerId: ownerId ?? this.ownerId,
      recipeName: recipeName ?? this.recipeName,
      mealDate: mealDate ?? this.mealDate,
      mealType: mealType ?? this.mealType,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      ingredientsList: ingredientsList ?? this.ingredientsList,
      instructionsList: instructionsList ?? this.instructionsList,
      notes: notes ?? this.notes,
      prepGroupId: prepGroupId ?? this.prepGroupId,
      isMealPrep: isMealPrep ?? this.isMealPrep,
      isHousehold: isHousehold ?? this.isHousehold,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealPlan &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          recipeName == other.recipeName &&
          mealDate == other.mealDate &&
          mealType == other.mealType;

  @override
  int get hashCode =>
      id.hashCode ^ recipeName.hashCode ^ mealDate.hashCode ^ mealType.hashCode;

  @override
  String toString() =>
      'MealPlan(id: $id, recipeName: $recipeName, mealDate: $mealDate, mealType: $mealType)';
}
