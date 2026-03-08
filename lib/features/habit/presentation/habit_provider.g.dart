// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$habitsListHash() => r'bf3683c709b64d4eb02fd16fcaea29f4f2feca6a';

/// StreamProvider for all habits of the current user.
///
/// Copied from [habitsList].
@ProviderFor(habitsList)
final habitsListProvider = AutoDisposeStreamProvider<List<Habit>>.internal(
  habitsList,
  name: r'habitsListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$habitsListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HabitsListRef = AutoDisposeStreamProviderRef<List<Habit>>;
String _$todayHabitLogsHash() => r'5dc0d2f911a3aedc5f9e0fcba5765ad462e57fca';

/// StreamProvider for today's completed habit IDs.
///
/// Copied from [todayHabitLogs].
@ProviderFor(todayHabitLogs)
final todayHabitLogsProvider = AutoDisposeStreamProvider<List<String>>.internal(
  todayHabitLogs,
  name: r'todayHabitLogsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todayHabitLogsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodayHabitLogsRef = AutoDisposeStreamProviderRef<List<String>>;
String _$habitItemStatesHash() => r'13ed4a07f0221b373725af69665c5acd428c870b';

/// Computed provider that combines habits with their completion status.
///
/// Copied from [habitItemStates].
@ProviderFor(habitItemStates)
final habitItemStatesProvider =
    AutoDisposeStreamProvider<List<HabitItemState>>.internal(
      habitItemStates,
      name: r'habitItemStatesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$habitItemStatesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HabitItemStatesRef = AutoDisposeStreamProviderRef<List<HabitItemState>>;
String _$uniqueCategoriesHash() => r'35d704476322fffae4bca6f91ad003eaec868c36';

/// StreamProvider for unique categories from user's habits.
///
/// Copied from [uniqueCategories].
@ProviderFor(uniqueCategories)
final uniqueCategoriesProvider =
    AutoDisposeStreamProvider<List<String>>.internal(
      uniqueCategories,
      name: r'uniqueCategoriesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$uniqueCategoriesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UniqueCategoriesRef = AutoDisposeStreamProviderRef<List<String>>;
String _$availableHabitFiltersHash() =>
    r'95c7fcb75191368546d61834f303d7bbd88c7b4c';

/// Computed provider that returns all available filter options.
/// Combines 'Wszystkie', 'Wspólne', 'Prywatne' + unique categories.
///
/// Copied from [availableHabitFilters].
@ProviderFor(availableHabitFilters)
final availableHabitFiltersProvider =
    AutoDisposeStreamProvider<List<String>>.internal(
      availableHabitFilters,
      name: r'availableHabitFiltersProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$availableHabitFiltersHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AvailableHabitFiltersRef = AutoDisposeStreamProviderRef<List<String>>;
String _$filteredHabitsHash() => r'550188526f794eb9f5b94a2636a2596809a997fe';

/// Filtered habits provider based on global filter and hideCompleted setting.
/// If 'Wszystkie': return all habits.
/// If 'Wspólne': return only household habits.
/// If 'Prywatne': return only personal (non-household) habits.
/// Else: return habits matching the selected category.
/// Additionally, sorts habits to show active ones first and completed at bottom.
///
/// Copied from [filteredHabits].
@ProviderFor(filteredHabits)
final filteredHabitsProvider =
    AutoDisposeStreamProvider<List<HabitItemState>>.internal(
      filteredHabits,
      name: r'filteredHabitsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$filteredHabitsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredHabitsRef = AutoDisposeStreamProviderRef<List<HabitItemState>>;
String _$createHabitHash() => r'735b88b3eaf2b692a78f088f846b9d5d4284851d';

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

/// FutureProvider for creating a new habit.
///
/// Copied from [createHabit].
@ProviderFor(createHabit)
const createHabitProvider = CreateHabitFamily();

/// FutureProvider for creating a new habit.
///
/// Copied from [createHabit].
class CreateHabitFamily extends Family<AsyncValue<Habit>> {
  /// FutureProvider for creating a new habit.
  ///
  /// Copied from [createHabit].
  const CreateHabitFamily();

  /// FutureProvider for creating a new habit.
  ///
  /// Copied from [createHabit].
  CreateHabitProvider call({
    required String title,
    String? description,
    String? category,
    String? iconName,
    bool isHousehold = false,
  }) {
    return CreateHabitProvider(
      title: title,
      description: description,
      category: category,
      iconName: iconName,
      isHousehold: isHousehold,
    );
  }

  @override
  CreateHabitProvider getProviderOverride(
    covariant CreateHabitProvider provider,
  ) {
    return call(
      title: provider.title,
      description: provider.description,
      category: provider.category,
      iconName: provider.iconName,
      isHousehold: provider.isHousehold,
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
  String? get name => r'createHabitProvider';
}

/// FutureProvider for creating a new habit.
///
/// Copied from [createHabit].
class CreateHabitProvider extends AutoDisposeFutureProvider<Habit> {
  /// FutureProvider for creating a new habit.
  ///
  /// Copied from [createHabit].
  CreateHabitProvider({
    required String title,
    String? description,
    String? category,
    String? iconName,
    bool isHousehold = false,
  }) : this._internal(
         (ref) => createHabit(
           ref as CreateHabitRef,
           title: title,
           description: description,
           category: category,
           iconName: iconName,
           isHousehold: isHousehold,
         ),
         from: createHabitProvider,
         name: r'createHabitProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$createHabitHash,
         dependencies: CreateHabitFamily._dependencies,
         allTransitiveDependencies:
             CreateHabitFamily._allTransitiveDependencies,
         title: title,
         description: description,
         category: category,
         iconName: iconName,
         isHousehold: isHousehold,
       );

  CreateHabitProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.title,
    required this.description,
    required this.category,
    required this.iconName,
    required this.isHousehold,
  }) : super.internal();

  final String title;
  final String? description;
  final String? category;
  final String? iconName;
  final bool isHousehold;

  @override
  Override overrideWith(
    FutureOr<Habit> Function(CreateHabitRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CreateHabitProvider._internal(
        (ref) => create(ref as CreateHabitRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        title: title,
        description: description,
        category: category,
        iconName: iconName,
        isHousehold: isHousehold,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Habit> createElement() {
    return _CreateHabitProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateHabitProvider &&
        other.title == title &&
        other.description == description &&
        other.category == category &&
        other.iconName == iconName &&
        other.isHousehold == isHousehold;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, title.hashCode);
    hash = _SystemHash.combine(hash, description.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);
    hash = _SystemHash.combine(hash, iconName.hashCode);
    hash = _SystemHash.combine(hash, isHousehold.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CreateHabitRef on AutoDisposeFutureProviderRef<Habit> {
  /// The parameter `title` of this provider.
  String get title;

  /// The parameter `description` of this provider.
  String? get description;

  /// The parameter `category` of this provider.
  String? get category;

  /// The parameter `iconName` of this provider.
  String? get iconName;

  /// The parameter `isHousehold` of this provider.
  bool get isHousehold;
}

class _CreateHabitProviderElement
    extends AutoDisposeFutureProviderElement<Habit>
    with CreateHabitRef {
  _CreateHabitProviderElement(super.provider);

  @override
  String get title => (origin as CreateHabitProvider).title;
  @override
  String? get description => (origin as CreateHabitProvider).description;
  @override
  String? get category => (origin as CreateHabitProvider).category;
  @override
  String? get iconName => (origin as CreateHabitProvider).iconName;
  @override
  bool get isHousehold => (origin as CreateHabitProvider).isHousehold;
}

String _$deleteHabitHash() => r'04949a1afea7246b8460a2cf511560388d0c257a';

/// FutureProvider for deleting a habit.
///
/// Copied from [deleteHabit].
@ProviderFor(deleteHabit)
const deleteHabitProvider = DeleteHabitFamily();

/// FutureProvider for deleting a habit.
///
/// Copied from [deleteHabit].
class DeleteHabitFamily extends Family<AsyncValue<void>> {
  /// FutureProvider for deleting a habit.
  ///
  /// Copied from [deleteHabit].
  const DeleteHabitFamily();

  /// FutureProvider for deleting a habit.
  ///
  /// Copied from [deleteHabit].
  DeleteHabitProvider call(String habitId) {
    return DeleteHabitProvider(habitId);
  }

  @override
  DeleteHabitProvider getProviderOverride(
    covariant DeleteHabitProvider provider,
  ) {
    return call(provider.habitId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'deleteHabitProvider';
}

/// FutureProvider for deleting a habit.
///
/// Copied from [deleteHabit].
class DeleteHabitProvider extends AutoDisposeFutureProvider<void> {
  /// FutureProvider for deleting a habit.
  ///
  /// Copied from [deleteHabit].
  DeleteHabitProvider(String habitId)
    : this._internal(
        (ref) => deleteHabit(ref as DeleteHabitRef, habitId),
        from: deleteHabitProvider,
        name: r'deleteHabitProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$deleteHabitHash,
        dependencies: DeleteHabitFamily._dependencies,
        allTransitiveDependencies: DeleteHabitFamily._allTransitiveDependencies,
        habitId: habitId,
      );

  DeleteHabitProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.habitId,
  }) : super.internal();

  final String habitId;

  @override
  Override overrideWith(
    FutureOr<void> Function(DeleteHabitRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DeleteHabitProvider._internal(
        (ref) => create(ref as DeleteHabitRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        habitId: habitId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _DeleteHabitProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteHabitProvider && other.habitId == habitId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, habitId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DeleteHabitRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `habitId` of this provider.
  String get habitId;
}

class _DeleteHabitProviderElement extends AutoDisposeFutureProviderElement<void>
    with DeleteHabitRef {
  _DeleteHabitProviderElement(super.provider);

  @override
  String get habitId => (origin as DeleteHabitProvider).habitId;
}

String _$completeHabitHash() => r'e7d3cc4b30e263207e14f7c808e19953e6fffc14';

/// FutureProvider for completing a habit.
///
/// Copied from [completeHabit].
@ProviderFor(completeHabit)
const completeHabitProvider = CompleteHabitFamily();

/// FutureProvider for completing a habit.
///
/// Copied from [completeHabit].
class CompleteHabitFamily extends Family<AsyncValue<void>> {
  /// FutureProvider for completing a habit.
  ///
  /// Copied from [completeHabit].
  const CompleteHabitFamily();

  /// FutureProvider for completing a habit.
  ///
  /// Copied from [completeHabit].
  CompleteHabitProvider call(String habitId) {
    return CompleteHabitProvider(habitId);
  }

  @override
  CompleteHabitProvider getProviderOverride(
    covariant CompleteHabitProvider provider,
  ) {
    return call(provider.habitId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'completeHabitProvider';
}

/// FutureProvider for completing a habit.
///
/// Copied from [completeHabit].
class CompleteHabitProvider extends AutoDisposeFutureProvider<void> {
  /// FutureProvider for completing a habit.
  ///
  /// Copied from [completeHabit].
  CompleteHabitProvider(String habitId)
    : this._internal(
        (ref) => completeHabit(ref as CompleteHabitRef, habitId),
        from: completeHabitProvider,
        name: r'completeHabitProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$completeHabitHash,
        dependencies: CompleteHabitFamily._dependencies,
        allTransitiveDependencies:
            CompleteHabitFamily._allTransitiveDependencies,
        habitId: habitId,
      );

  CompleteHabitProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.habitId,
  }) : super.internal();

  final String habitId;

  @override
  Override overrideWith(
    FutureOr<void> Function(CompleteHabitRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CompleteHabitProvider._internal(
        (ref) => create(ref as CompleteHabitRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        habitId: habitId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _CompleteHabitProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CompleteHabitProvider && other.habitId == habitId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, habitId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CompleteHabitRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `habitId` of this provider.
  String get habitId;
}

class _CompleteHabitProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with CompleteHabitRef {
  _CompleteHabitProviderElement(super.provider);

  @override
  String get habitId => (origin as CompleteHabitProvider).habitId;
}

String _$weeklyStreaksHash() => r'6e13fc7ec0974a20adfd65e5321cb63ae17f0a76';

/// StreamProvider for fetching weekly habit streaks from the habit_progress_7_days view.
///
/// Copied from [weeklyStreaks].
@ProviderFor(weeklyStreaks)
final weeklyStreaksProvider =
    AutoDisposeStreamProvider<Map<String, WeeklyStreak>>.internal(
      weeklyStreaks,
      name: r'weeklyStreaksProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$weeklyStreaksHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WeeklyStreaksRef =
    AutoDisposeStreamProviderRef<Map<String, WeeklyStreak>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
