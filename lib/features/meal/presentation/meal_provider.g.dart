// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mealPlanRepositoryHash() =>
    r'2d6bd289c833672c5160ea8779abf4a5b0455aa1';

/// Provider for the MealPlanRepository instance.
///
/// Copied from [mealPlanRepository].
@ProviderFor(mealPlanRepository)
final mealPlanRepositoryProvider =
    AutoDisposeProvider<MealPlanRepository>.internal(
      mealPlanRepository,
      name: r'mealPlanRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$mealPlanRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MealPlanRepositoryRef = AutoDisposeProviderRef<MealPlanRepository>;
String _$shoppingRepositoryHash() =>
    r'0486651621986e3e1290604d0568eb9d2e9a0607';

/// Provider for the ShoppingRepository instance.
///
/// Copied from [shoppingRepository].
@ProviderFor(shoppingRepository)
final shoppingRepositoryProvider =
    AutoDisposeProvider<ShoppingRepository>.internal(
      shoppingRepository,
      name: r'shoppingRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$shoppingRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ShoppingRepositoryRef = AutoDisposeProviderRef<ShoppingRepository>;
String _$todayMealsProviderHash() =>
    r'5562393815588465c910d1a138f7ddf831aac757';

/// StreamProvider for today's meals.
///
/// Copied from [todayMealsProvider].
@ProviderFor(todayMealsProvider)
final todayMealsProviderProvider =
    AutoDisposeStreamProvider<List<MealPlan>>.internal(
      todayMealsProvider,
      name: r'todayMealsProviderProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$todayMealsProviderHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodayMealsProviderRef = AutoDisposeStreamProviderRef<List<MealPlan>>;
String _$allMealsProviderHash() => r'549485b043c105807219951540c9a94fc8e7aa10';

/// StreamProvider for meals in a date range (e.g., for calendar view).
///
/// Copied from [allMealsProvider].
@ProviderFor(allMealsProvider)
final allMealsProviderProvider =
    AutoDisposeStreamProvider<List<MealPlan>>.internal(
      allMealsProvider,
      name: r'allMealsProviderProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$allMealsProviderHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllMealsProviderRef = AutoDisposeStreamProviderRef<List<MealPlan>>;
String _$shoppingListProviderHash() =>
    r'aaef6bb4ab940812a816a58206efb65288138da1';

/// StreamProvider for shopping list items.
///
/// Copied from [shoppingListProvider].
@ProviderFor(shoppingListProvider)
final shoppingListProviderProvider =
    AutoDisposeStreamProvider<List<ShoppingItem>>.internal(
      shoppingListProvider,
      name: r'shoppingListProviderProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$shoppingListProviderHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ShoppingListProviderRef =
    AutoDisposeStreamProviderRef<List<ShoppingItem>>;
String _$addMealHash() => r'b201cb8f5fc74ed20125e37d397920820ba9ec5e';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// FutureProvider for adding a single meal.
///
/// Copied from [addMeal].
@ProviderFor(addMeal)
const addMealProvider = AddMealFamily();

/// FutureProvider for adding a single meal.
///
/// Copied from [addMeal].
class AddMealFamily extends Family<AsyncValue<void>> {
  /// FutureProvider for adding a single meal.
  ///
  /// Copied from [addMeal].
  const AddMealFamily();

  /// FutureProvider for adding a single meal.
  ///
  /// Copied from [addMeal].
  AddMealProvider call({
    required String recipeName,
    required DateTime mealDate,
    required String mealType,
    String? notes,
    String? prepGroupId,
  }) {
    return AddMealProvider(
      recipeName: recipeName,
      mealDate: mealDate,
      mealType: mealType,
      notes: notes,
      prepGroupId: prepGroupId,
    );
  }

  @override
  AddMealProvider getProviderOverride(covariant AddMealProvider provider) {
    return call(
      recipeName: provider.recipeName,
      mealDate: provider.mealDate,
      mealType: provider.mealType,
      notes: provider.notes,
      prepGroupId: provider.prepGroupId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'addMealProvider';
}

/// FutureProvider for adding a single meal.
///
/// Copied from [addMeal].
class AddMealProvider extends AutoDisposeFutureProvider<void> {
  /// FutureProvider for adding a single meal.
  ///
  /// Copied from [addMeal].
  AddMealProvider({
    required String recipeName,
    required DateTime mealDate,
    required String mealType,
    String? notes,
    String? prepGroupId,
  }) : this._internal(
         (ref) => addMeal(
           ref as AddMealRef,
           recipeName: recipeName,
           mealDate: mealDate,
           mealType: mealType,
           notes: notes,
           prepGroupId: prepGroupId,
         ),
         from: addMealProvider,
         name: r'addMealProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$addMealHash,
         dependencies: AddMealFamily._dependencies,
         allTransitiveDependencies: AddMealFamily._allTransitiveDependencies,
         recipeName: recipeName,
         mealDate: mealDate,
         mealType: mealType,
         notes: notes,
         prepGroupId: prepGroupId,
       );

  AddMealProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.recipeName,
    required this.mealDate,
    required this.mealType,
    required this.notes,
    required this.prepGroupId,
  }) : super.internal();

  final String recipeName;
  final DateTime mealDate;
  final String mealType;
  final String? notes;
  final String? prepGroupId;

  @override
  Override overrideWith(FutureOr<void> Function(AddMealRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: AddMealProvider._internal(
        (ref) => create(ref as AddMealRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        recipeName: recipeName,
        mealDate: mealDate,
        mealType: mealType,
        notes: notes,
        prepGroupId: prepGroupId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _AddMealProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AddMealProvider &&
        other.recipeName == recipeName &&
        other.mealDate == mealDate &&
        other.mealType == mealType &&
        other.notes == notes &&
        other.prepGroupId == prepGroupId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, recipeName.hashCode);
    hash = _SystemHash.combine(hash, mealDate.hashCode);
    hash = _SystemHash.combine(hash, mealType.hashCode);
    hash = _SystemHash.combine(hash, notes.hashCode);
    hash = _SystemHash.combine(hash, prepGroupId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AddMealRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `recipeName` of this provider.
  String get recipeName;

  /// The parameter `mealDate` of this provider.
  DateTime get mealDate;

  /// The parameter `mealType` of this provider.
  String get mealType;

  /// The parameter `notes` of this provider.
  String? get notes;

  /// The parameter `prepGroupId` of this provider.
  String? get prepGroupId;
}

class _AddMealProviderElement extends AutoDisposeFutureProviderElement<void>
    with AddMealRef {
  _AddMealProviderElement(super.provider);

  @override
  String get recipeName => (origin as AddMealProvider).recipeName;
  @override
  DateTime get mealDate => (origin as AddMealProvider).mealDate;
  @override
  String get mealType => (origin as AddMealProvider).mealType;
  @override
  String? get notes => (origin as AddMealProvider).notes;
  @override
  String? get prepGroupId => (origin as AddMealProvider).prepGroupId;
}

String _$bulkInsertMealPrepHash() =>
    r'c79c35f7bcef7e2020681b0f4935dcc45b67b665';

/// FutureProvider for bulk inserting a 3-day meal prep.
///
/// Copied from [bulkInsertMealPrep].
@ProviderFor(bulkInsertMealPrep)
const bulkInsertMealPrepProvider = BulkInsertMealPrepFamily();

/// FutureProvider for bulk inserting a 3-day meal prep.
///
/// Copied from [bulkInsertMealPrep].
class BulkInsertMealPrepFamily extends Family<AsyncValue<String>> {
  /// FutureProvider for bulk inserting a 3-day meal prep.
  ///
  /// Copied from [bulkInsertMealPrep].
  const BulkInsertMealPrepFamily();

  /// FutureProvider for bulk inserting a 3-day meal prep.
  ///
  /// Copied from [bulkInsertMealPrep].
  BulkInsertMealPrepProvider call({
    required List<Map<String, dynamic>> meals,
    String? autoGeneratedPrepGroupId,
  }) {
    return BulkInsertMealPrepProvider(
      meals: meals,
      autoGeneratedPrepGroupId: autoGeneratedPrepGroupId,
    );
  }

  @override
  BulkInsertMealPrepProvider getProviderOverride(
    covariant BulkInsertMealPrepProvider provider,
  ) {
    return call(
      meals: provider.meals,
      autoGeneratedPrepGroupId: provider.autoGeneratedPrepGroupId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'bulkInsertMealPrepProvider';
}

/// FutureProvider for bulk inserting a 3-day meal prep.
///
/// Copied from [bulkInsertMealPrep].
class BulkInsertMealPrepProvider extends AutoDisposeFutureProvider<String> {
  /// FutureProvider for bulk inserting a 3-day meal prep.
  ///
  /// Copied from [bulkInsertMealPrep].
  BulkInsertMealPrepProvider({
    required List<Map<String, dynamic>> meals,
    String? autoGeneratedPrepGroupId,
  }) : this._internal(
         (ref) => bulkInsertMealPrep(
           ref as BulkInsertMealPrepRef,
           meals: meals,
           autoGeneratedPrepGroupId: autoGeneratedPrepGroupId,
         ),
         from: bulkInsertMealPrepProvider,
         name: r'bulkInsertMealPrepProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$bulkInsertMealPrepHash,
         dependencies: BulkInsertMealPrepFamily._dependencies,
         allTransitiveDependencies:
             BulkInsertMealPrepFamily._allTransitiveDependencies,
         meals: meals,
         autoGeneratedPrepGroupId: autoGeneratedPrepGroupId,
       );

  BulkInsertMealPrepProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.meals,
    required this.autoGeneratedPrepGroupId,
  }) : super.internal();

  final List<Map<String, dynamic>> meals;
  final String? autoGeneratedPrepGroupId;

  @override
  Override overrideWith(
    FutureOr<String> Function(BulkInsertMealPrepRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BulkInsertMealPrepProvider._internal(
        (ref) => create(ref as BulkInsertMealPrepRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        meals: meals,
        autoGeneratedPrepGroupId: autoGeneratedPrepGroupId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String> createElement() {
    return _BulkInsertMealPrepProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BulkInsertMealPrepProvider &&
        other.meals == meals &&
        other.autoGeneratedPrepGroupId == autoGeneratedPrepGroupId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, meals.hashCode);
    hash = _SystemHash.combine(hash, autoGeneratedPrepGroupId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BulkInsertMealPrepRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `meals` of this provider.
  List<Map<String, dynamic>> get meals;

  /// The parameter `autoGeneratedPrepGroupId` of this provider.
  String? get autoGeneratedPrepGroupId;
}

class _BulkInsertMealPrepProviderElement
    extends AutoDisposeFutureProviderElement<String>
    with BulkInsertMealPrepRef {
  _BulkInsertMealPrepProviderElement(super.provider);

  @override
  List<Map<String, dynamic>> get meals =>
      (origin as BulkInsertMealPrepProvider).meals;
  @override
  String? get autoGeneratedPrepGroupId =>
      (origin as BulkInsertMealPrepProvider).autoGeneratedPrepGroupId;
}

String _$updateMealHash() => r'6f5bf1400d9287991b58cbb2d6f18eabaf630db0';

/// FutureProvider for updating a meal.
///
/// Copied from [updateMeal].
@ProviderFor(updateMeal)
const updateMealProvider = UpdateMealFamily();

/// FutureProvider for updating a meal.
///
/// Copied from [updateMeal].
class UpdateMealFamily extends Family<AsyncValue<void>> {
  /// FutureProvider for updating a meal.
  ///
  /// Copied from [updateMeal].
  const UpdateMealFamily();

  /// FutureProvider for updating a meal.
  ///
  /// Copied from [updateMeal].
  UpdateMealProvider call(MealPlan meal) {
    return UpdateMealProvider(meal);
  }

  @override
  UpdateMealProvider getProviderOverride(
    covariant UpdateMealProvider provider,
  ) {
    return call(provider.meal);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'updateMealProvider';
}

/// FutureProvider for updating a meal.
///
/// Copied from [updateMeal].
class UpdateMealProvider extends AutoDisposeFutureProvider<void> {
  /// FutureProvider for updating a meal.
  ///
  /// Copied from [updateMeal].
  UpdateMealProvider(MealPlan meal)
    : this._internal(
        (ref) => updateMeal(ref as UpdateMealRef, meal),
        from: updateMealProvider,
        name: r'updateMealProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$updateMealHash,
        dependencies: UpdateMealFamily._dependencies,
        allTransitiveDependencies: UpdateMealFamily._allTransitiveDependencies,
        meal: meal,
      );

  UpdateMealProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.meal,
  }) : super.internal();

  final MealPlan meal;

  @override
  Override overrideWith(
    FutureOr<void> Function(UpdateMealRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdateMealProvider._internal(
        (ref) => create(ref as UpdateMealRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        meal: meal,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _UpdateMealProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateMealProvider && other.meal == meal;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, meal.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UpdateMealRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `meal` of this provider.
  MealPlan get meal;
}

class _UpdateMealProviderElement extends AutoDisposeFutureProviderElement<void>
    with UpdateMealRef {
  _UpdateMealProviderElement(super.provider);

  @override
  MealPlan get meal => (origin as UpdateMealProvider).meal;
}

String _$deleteMealHash() => r'aa1d887e77a448d9a8cfb77eca53c37a0f9e1f79';

/// FutureProvider for deleting a meal.
///
/// Copied from [deleteMeal].
@ProviderFor(deleteMeal)
const deleteMealProvider = DeleteMealFamily();

/// FutureProvider for deleting a meal.
///
/// Copied from [deleteMeal].
class DeleteMealFamily extends Family<AsyncValue<void>> {
  /// FutureProvider for deleting a meal.
  ///
  /// Copied from [deleteMeal].
  const DeleteMealFamily();

  /// FutureProvider for deleting a meal.
  ///
  /// Copied from [deleteMeal].
  DeleteMealProvider call(String mealId) {
    return DeleteMealProvider(mealId);
  }

  @override
  DeleteMealProvider getProviderOverride(
    covariant DeleteMealProvider provider,
  ) {
    return call(provider.mealId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'deleteMealProvider';
}

/// FutureProvider for deleting a meal.
///
/// Copied from [deleteMeal].
class DeleteMealProvider extends AutoDisposeFutureProvider<void> {
  /// FutureProvider for deleting a meal.
  ///
  /// Copied from [deleteMeal].
  DeleteMealProvider(String mealId)
    : this._internal(
        (ref) => deleteMeal(ref as DeleteMealRef, mealId),
        from: deleteMealProvider,
        name: r'deleteMealProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$deleteMealHash,
        dependencies: DeleteMealFamily._dependencies,
        allTransitiveDependencies: DeleteMealFamily._allTransitiveDependencies,
        mealId: mealId,
      );

  DeleteMealProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mealId,
  }) : super.internal();

  final String mealId;

  @override
  Override overrideWith(
    FutureOr<void> Function(DeleteMealRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DeleteMealProvider._internal(
        (ref) => create(ref as DeleteMealRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mealId: mealId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _DeleteMealProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteMealProvider && other.mealId == mealId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mealId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DeleteMealRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `mealId` of this provider.
  String get mealId;
}

class _DeleteMealProviderElement extends AutoDisposeFutureProviderElement<void>
    with DeleteMealRef {
  _DeleteMealProviderElement(super.provider);

  @override
  String get mealId => (origin as DeleteMealProvider).mealId;
}

String _$updateShoppingItemHash() =>
    r'ee8b5829e99ad07538e82a32fa3f7f06e0b529ff';

/// FutureProvider for updating a shopping item (e.g., toggle bought status).
///
/// Copied from [updateShoppingItem].
@ProviderFor(updateShoppingItem)
const updateShoppingItemProvider = UpdateShoppingItemFamily();

/// FutureProvider for updating a shopping item (e.g., toggle bought status).
///
/// Copied from [updateShoppingItem].
class UpdateShoppingItemFamily extends Family<AsyncValue<void>> {
  /// FutureProvider for updating a shopping item (e.g., toggle bought status).
  ///
  /// Copied from [updateShoppingItem].
  const UpdateShoppingItemFamily();

  /// FutureProvider for updating a shopping item (e.g., toggle bought status).
  ///
  /// Copied from [updateShoppingItem].
  UpdateShoppingItemProvider call(ShoppingItem item) {
    return UpdateShoppingItemProvider(item);
  }

  @override
  UpdateShoppingItemProvider getProviderOverride(
    covariant UpdateShoppingItemProvider provider,
  ) {
    return call(provider.item);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'updateShoppingItemProvider';
}

/// FutureProvider for updating a shopping item (e.g., toggle bought status).
///
/// Copied from [updateShoppingItem].
class UpdateShoppingItemProvider extends AutoDisposeFutureProvider<void> {
  /// FutureProvider for updating a shopping item (e.g., toggle bought status).
  ///
  /// Copied from [updateShoppingItem].
  UpdateShoppingItemProvider(ShoppingItem item)
    : this._internal(
        (ref) => updateShoppingItem(ref as UpdateShoppingItemRef, item),
        from: updateShoppingItemProvider,
        name: r'updateShoppingItemProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$updateShoppingItemHash,
        dependencies: UpdateShoppingItemFamily._dependencies,
        allTransitiveDependencies:
            UpdateShoppingItemFamily._allTransitiveDependencies,
        item: item,
      );

  UpdateShoppingItemProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.item,
  }) : super.internal();

  final ShoppingItem item;

  @override
  Override overrideWith(
    FutureOr<void> Function(UpdateShoppingItemRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdateShoppingItemProvider._internal(
        (ref) => create(ref as UpdateShoppingItemRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        item: item,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _UpdateShoppingItemProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateShoppingItemProvider && other.item == item;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, item.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UpdateShoppingItemRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `item` of this provider.
  ShoppingItem get item;
}

class _UpdateShoppingItemProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with UpdateShoppingItemRef {
  _UpdateShoppingItemProviderElement(super.provider);

  @override
  ShoppingItem get item => (origin as UpdateShoppingItemProvider).item;
}

String _$deleteShoppingItemHash() =>
    r'3b37afa5eb9aef348368872b90141a915d25d270';

/// FutureProvider for deleting a shopping item.
///
/// Copied from [deleteShoppingItem].
@ProviderFor(deleteShoppingItem)
const deleteShoppingItemProvider = DeleteShoppingItemFamily();

/// FutureProvider for deleting a shopping item.
///
/// Copied from [deleteShoppingItem].
class DeleteShoppingItemFamily extends Family<AsyncValue<void>> {
  /// FutureProvider for deleting a shopping item.
  ///
  /// Copied from [deleteShoppingItem].
  const DeleteShoppingItemFamily();

  /// FutureProvider for deleting a shopping item.
  ///
  /// Copied from [deleteShoppingItem].
  DeleteShoppingItemProvider call(String itemId) {
    return DeleteShoppingItemProvider(itemId);
  }

  @override
  DeleteShoppingItemProvider getProviderOverride(
    covariant DeleteShoppingItemProvider provider,
  ) {
    return call(provider.itemId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'deleteShoppingItemProvider';
}

/// FutureProvider for deleting a shopping item.
///
/// Copied from [deleteShoppingItem].
class DeleteShoppingItemProvider extends AutoDisposeFutureProvider<void> {
  /// FutureProvider for deleting a shopping item.
  ///
  /// Copied from [deleteShoppingItem].
  DeleteShoppingItemProvider(String itemId)
    : this._internal(
        (ref) => deleteShoppingItem(ref as DeleteShoppingItemRef, itemId),
        from: deleteShoppingItemProvider,
        name: r'deleteShoppingItemProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$deleteShoppingItemHash,
        dependencies: DeleteShoppingItemFamily._dependencies,
        allTransitiveDependencies:
            DeleteShoppingItemFamily._allTransitiveDependencies,
        itemId: itemId,
      );

  DeleteShoppingItemProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.itemId,
  }) : super.internal();

  final String itemId;

  @override
  Override overrideWith(
    FutureOr<void> Function(DeleteShoppingItemRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DeleteShoppingItemProvider._internal(
        (ref) => create(ref as DeleteShoppingItemRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        itemId: itemId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _DeleteShoppingItemProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteShoppingItemProvider && other.itemId == itemId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, itemId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DeleteShoppingItemRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `itemId` of this provider.
  String get itemId;
}

class _DeleteShoppingItemProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with DeleteShoppingItemRef {
  _DeleteShoppingItemProviderElement(super.provider);

  @override
  String get itemId => (origin as DeleteShoppingItemProvider).itemId;
}

String _$shoppingCyclesProviderHash() =>
    r'b13ec0d8cd01e8c9f026bb611f2a9b92886b17f1';

/// CombinedProvider for shopping cycles (grouped by prep_group_id).
///
/// Copied from [shoppingCyclesProvider].
@ProviderFor(shoppingCyclesProvider)
final shoppingCyclesProviderProvider =
    AutoDisposeStreamProvider<List<ShoppingCycle>>.internal(
      shoppingCyclesProvider,
      name: r'shoppingCyclesProviderProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$shoppingCyclesProviderHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ShoppingCyclesProviderRef =
    AutoDisposeStreamProviderRef<List<ShoppingCycle>>;
String _$selectedCycleIndexHash() =>
    r'528aa51710905c334f50815d5a84fde2d879e1ee';

/// StateProvider to track the selected shopping cycle index.
///
/// Copied from [SelectedCycleIndex].
@ProviderFor(SelectedCycleIndex)
final selectedCycleIndexProvider =
    AutoDisposeNotifierProvider<SelectedCycleIndex, int>.internal(
      SelectedCycleIndex.new,
      name: r'selectedCycleIndexProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedCycleIndexHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedCycleIndex = AutoDisposeNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
