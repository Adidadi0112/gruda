// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$taskRepositoryHash() => r'43eab89cb177c75fbcf3e781a00c0cf070097d90';

/// Provider for the TaskRepository instance.
///
/// Copied from [taskRepository].
@ProviderFor(taskRepository)
final taskRepositoryProvider = AutoDisposeProvider<TaskRepository>.internal(
  taskRepository,
  name: r'taskRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$taskRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TaskRepositoryRef = AutoDisposeProviderRef<TaskRepository>;
String _$todayTasksProviderHash() =>
    r'61ab2eb5d5981a5fb1af7c4498d9ee10af10a92f';

/// StreamProvider for today's tasks.
///
/// Copied from [todayTasksProvider].
@ProviderFor(todayTasksProvider)
final todayTasksProviderProvider =
    AutoDisposeStreamProvider<List<TaskItem>>.internal(
      todayTasksProvider,
      name: r'todayTasksProviderProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$todayTasksProviderHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodayTasksProviderRef = AutoDisposeStreamProviderRef<List<TaskItem>>;
String _$filteredTasksHash() => r'7833b17238b581bb672245723cdf355a0a9de2a9';

/// Filtered tasks provider based on global filter and hideCompleted setting.
/// If 'Wszystkie': return all tasks.
/// If 'Wspólne': return only household tasks.
/// If 'Prywatne': return only personal (non-household) tasks.
/// Else: return tasks matching the selected category.
/// Additionally, hides completed tasks if hideCompleted is true, or sorts them to bottom.
///
/// Copied from [filteredTasks].
@ProviderFor(filteredTasks)
final filteredTasksProvider =
    AutoDisposeStreamProvider<List<TaskItem>>.internal(
      filteredTasks,
      name: r'filteredTasksProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$filteredTasksHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredTasksRef = AutoDisposeStreamProviderRef<List<TaskItem>>;
String _$addTaskHash() => r'e112052e749eb4a7e4cce98cef867c4d8ca2d0e3';

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

/// FutureProvider for adding a new task.
///
/// Copied from [addTask].
@ProviderFor(addTask)
const addTaskProvider = AddTaskFamily();

/// FutureProvider for adding a new task.
///
/// Copied from [addTask].
class AddTaskFamily extends Family<AsyncValue<void>> {
  /// FutureProvider for adding a new task.
  ///
  /// Copied from [addTask].
  const AddTaskFamily();

  /// FutureProvider for adding a new task.
  ///
  /// Copied from [addTask].
  AddTaskProvider call({
    required String title,
    String? category,
    required DateTime dueDate,
    required bool isHousehold,
  }) {
    return AddTaskProvider(
      title: title,
      category: category,
      dueDate: dueDate,
      isHousehold: isHousehold,
    );
  }

  @override
  AddTaskProvider getProviderOverride(covariant AddTaskProvider provider) {
    return call(
      title: provider.title,
      category: provider.category,
      dueDate: provider.dueDate,
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
  String? get name => r'addTaskProvider';
}

/// FutureProvider for adding a new task.
///
/// Copied from [addTask].
class AddTaskProvider extends AutoDisposeFutureProvider<void> {
  /// FutureProvider for adding a new task.
  ///
  /// Copied from [addTask].
  AddTaskProvider({
    required String title,
    String? category,
    required DateTime dueDate,
    required bool isHousehold,
  }) : this._internal(
         (ref) => addTask(
           ref as AddTaskRef,
           title: title,
           category: category,
           dueDate: dueDate,
           isHousehold: isHousehold,
         ),
         from: addTaskProvider,
         name: r'addTaskProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$addTaskHash,
         dependencies: AddTaskFamily._dependencies,
         allTransitiveDependencies: AddTaskFamily._allTransitiveDependencies,
         title: title,
         category: category,
         dueDate: dueDate,
         isHousehold: isHousehold,
       );

  AddTaskProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.title,
    required this.category,
    required this.dueDate,
    required this.isHousehold,
  }) : super.internal();

  final String title;
  final String? category;
  final DateTime dueDate;
  final bool isHousehold;

  @override
  Override overrideWith(FutureOr<void> Function(AddTaskRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: AddTaskProvider._internal(
        (ref) => create(ref as AddTaskRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        title: title,
        category: category,
        dueDate: dueDate,
        isHousehold: isHousehold,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _AddTaskProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AddTaskProvider &&
        other.title == title &&
        other.category == category &&
        other.dueDate == dueDate &&
        other.isHousehold == isHousehold;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, title.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);
    hash = _SystemHash.combine(hash, dueDate.hashCode);
    hash = _SystemHash.combine(hash, isHousehold.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AddTaskRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `title` of this provider.
  String get title;

  /// The parameter `category` of this provider.
  String? get category;

  /// The parameter `dueDate` of this provider.
  DateTime get dueDate;

  /// The parameter `isHousehold` of this provider.
  bool get isHousehold;
}

class _AddTaskProviderElement extends AutoDisposeFutureProviderElement<void>
    with AddTaskRef {
  _AddTaskProviderElement(super.provider);

  @override
  String get title => (origin as AddTaskProvider).title;
  @override
  String? get category => (origin as AddTaskProvider).category;
  @override
  DateTime get dueDate => (origin as AddTaskProvider).dueDate;
  @override
  bool get isHousehold => (origin as AddTaskProvider).isHousehold;
}

String _$toggleTaskHash() => r'fe1d040427a7a0ce67f8d441665d29f756c7f6b3';

/// FutureProvider for toggling a task's completion status.
///
/// Copied from [toggleTask].
@ProviderFor(toggleTask)
const toggleTaskProvider = ToggleTaskFamily();

/// FutureProvider for toggling a task's completion status.
///
/// Copied from [toggleTask].
class ToggleTaskFamily extends Family<AsyncValue<void>> {
  /// FutureProvider for toggling a task's completion status.
  ///
  /// Copied from [toggleTask].
  const ToggleTaskFamily();

  /// FutureProvider for toggling a task's completion status.
  ///
  /// Copied from [toggleTask].
  ToggleTaskProvider call(String taskId, bool isCompleted) {
    return ToggleTaskProvider(taskId, isCompleted);
  }

  @override
  ToggleTaskProvider getProviderOverride(
    covariant ToggleTaskProvider provider,
  ) {
    return call(provider.taskId, provider.isCompleted);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'toggleTaskProvider';
}

/// FutureProvider for toggling a task's completion status.
///
/// Copied from [toggleTask].
class ToggleTaskProvider extends AutoDisposeFutureProvider<void> {
  /// FutureProvider for toggling a task's completion status.
  ///
  /// Copied from [toggleTask].
  ToggleTaskProvider(String taskId, bool isCompleted)
    : this._internal(
        (ref) => toggleTask(ref as ToggleTaskRef, taskId, isCompleted),
        from: toggleTaskProvider,
        name: r'toggleTaskProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$toggleTaskHash,
        dependencies: ToggleTaskFamily._dependencies,
        allTransitiveDependencies: ToggleTaskFamily._allTransitiveDependencies,
        taskId: taskId,
        isCompleted: isCompleted,
      );

  ToggleTaskProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.taskId,
    required this.isCompleted,
  }) : super.internal();

  final String taskId;
  final bool isCompleted;

  @override
  Override overrideWith(
    FutureOr<void> Function(ToggleTaskRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ToggleTaskProvider._internal(
        (ref) => create(ref as ToggleTaskRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        taskId: taskId,
        isCompleted: isCompleted,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _ToggleTaskProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ToggleTaskProvider &&
        other.taskId == taskId &&
        other.isCompleted == isCompleted;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, taskId.hashCode);
    hash = _SystemHash.combine(hash, isCompleted.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ToggleTaskRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `taskId` of this provider.
  String get taskId;

  /// The parameter `isCompleted` of this provider.
  bool get isCompleted;
}

class _ToggleTaskProviderElement extends AutoDisposeFutureProviderElement<void>
    with ToggleTaskRef {
  _ToggleTaskProviderElement(super.provider);

  @override
  String get taskId => (origin as ToggleTaskProvider).taskId;
  @override
  bool get isCompleted => (origin as ToggleTaskProvider).isCompleted;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
