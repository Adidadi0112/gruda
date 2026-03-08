// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'household_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$createHouseholdHash() => r'a17954b8c97dcbaf5da20534c7fff86f4b8490f1';

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

/// FutureProvider for creating a new household.
/// Usage: ref.read(createHouseholdProvider('My Household').future);
///
/// Copied from [createHousehold].
@ProviderFor(createHousehold)
const createHouseholdProvider = CreateHouseholdFamily();

/// FutureProvider for creating a new household.
/// Usage: ref.read(createHouseholdProvider('My Household').future);
///
/// Copied from [createHousehold].
class CreateHouseholdFamily extends Family<AsyncValue<Household>> {
  /// FutureProvider for creating a new household.
  /// Usage: ref.read(createHouseholdProvider('My Household').future);
  ///
  /// Copied from [createHousehold].
  const CreateHouseholdFamily();

  /// FutureProvider for creating a new household.
  /// Usage: ref.read(createHouseholdProvider('My Household').future);
  ///
  /// Copied from [createHousehold].
  CreateHouseholdProvider call(String householdName) {
    return CreateHouseholdProvider(householdName);
  }

  @override
  CreateHouseholdProvider getProviderOverride(
    covariant CreateHouseholdProvider provider,
  ) {
    return call(provider.householdName);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'createHouseholdProvider';
}

/// FutureProvider for creating a new household.
/// Usage: ref.read(createHouseholdProvider('My Household').future);
///
/// Copied from [createHousehold].
class CreateHouseholdProvider extends AutoDisposeFutureProvider<Household> {
  /// FutureProvider for creating a new household.
  /// Usage: ref.read(createHouseholdProvider('My Household').future);
  ///
  /// Copied from [createHousehold].
  CreateHouseholdProvider(String householdName)
    : this._internal(
        (ref) => createHousehold(ref as CreateHouseholdRef, householdName),
        from: createHouseholdProvider,
        name: r'createHouseholdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$createHouseholdHash,
        dependencies: CreateHouseholdFamily._dependencies,
        allTransitiveDependencies:
            CreateHouseholdFamily._allTransitiveDependencies,
        householdName: householdName,
      );

  CreateHouseholdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.householdName,
  }) : super.internal();

  final String householdName;

  @override
  Override overrideWith(
    FutureOr<Household> Function(CreateHouseholdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CreateHouseholdProvider._internal(
        (ref) => create(ref as CreateHouseholdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        householdName: householdName,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Household> createElement() {
    return _CreateHouseholdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateHouseholdProvider &&
        other.householdName == householdName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, householdName.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CreateHouseholdRef on AutoDisposeFutureProviderRef<Household> {
  /// The parameter `householdName` of this provider.
  String get householdName;
}

class _CreateHouseholdProviderElement
    extends AutoDisposeFutureProviderElement<Household>
    with CreateHouseholdRef {
  _CreateHouseholdProviderElement(super.provider);

  @override
  String get householdName => (origin as CreateHouseholdProvider).householdName;
}

String _$joinHouseholdHash() => r'80d1b726e33e0c7588145f6c075795e2903e00ce';

/// FutureProvider for joining an existing household.
/// Usage: ref.read(joinHouseholdProvider('ABC123').future);
///
/// Copied from [joinHousehold].
@ProviderFor(joinHousehold)
const joinHouseholdProvider = JoinHouseholdFamily();

/// FutureProvider for joining an existing household.
/// Usage: ref.read(joinHouseholdProvider('ABC123').future);
///
/// Copied from [joinHousehold].
class JoinHouseholdFamily extends Family<AsyncValue<Household>> {
  /// FutureProvider for joining an existing household.
  /// Usage: ref.read(joinHouseholdProvider('ABC123').future);
  ///
  /// Copied from [joinHousehold].
  const JoinHouseholdFamily();

  /// FutureProvider for joining an existing household.
  /// Usage: ref.read(joinHouseholdProvider('ABC123').future);
  ///
  /// Copied from [joinHousehold].
  JoinHouseholdProvider call(String inviteCode) {
    return JoinHouseholdProvider(inviteCode);
  }

  @override
  JoinHouseholdProvider getProviderOverride(
    covariant JoinHouseholdProvider provider,
  ) {
    return call(provider.inviteCode);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'joinHouseholdProvider';
}

/// FutureProvider for joining an existing household.
/// Usage: ref.read(joinHouseholdProvider('ABC123').future);
///
/// Copied from [joinHousehold].
class JoinHouseholdProvider extends AutoDisposeFutureProvider<Household> {
  /// FutureProvider for joining an existing household.
  /// Usage: ref.read(joinHouseholdProvider('ABC123').future);
  ///
  /// Copied from [joinHousehold].
  JoinHouseholdProvider(String inviteCode)
    : this._internal(
        (ref) => joinHousehold(ref as JoinHouseholdRef, inviteCode),
        from: joinHouseholdProvider,
        name: r'joinHouseholdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$joinHouseholdHash,
        dependencies: JoinHouseholdFamily._dependencies,
        allTransitiveDependencies:
            JoinHouseholdFamily._allTransitiveDependencies,
        inviteCode: inviteCode,
      );

  JoinHouseholdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.inviteCode,
  }) : super.internal();

  final String inviteCode;

  @override
  Override overrideWith(
    FutureOr<Household> Function(JoinHouseholdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: JoinHouseholdProvider._internal(
        (ref) => create(ref as JoinHouseholdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        inviteCode: inviteCode,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Household> createElement() {
    return _JoinHouseholdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JoinHouseholdProvider && other.inviteCode == inviteCode;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, inviteCode.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin JoinHouseholdRef on AutoDisposeFutureProviderRef<Household> {
  /// The parameter `inviteCode` of this provider.
  String get inviteCode;
}

class _JoinHouseholdProviderElement
    extends AutoDisposeFutureProviderElement<Household>
    with JoinHouseholdRef {
  _JoinHouseholdProviderElement(super.provider);

  @override
  String get inviteCode => (origin as JoinHouseholdProvider).inviteCode;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
