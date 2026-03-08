import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Utility class for mapping icon string keys to LucideIcons.
/// Icons are suitable for home management and habit tracking.
class IconMapping {
  /// Map of icon names to their LucideIcons data.
  static const Map<String, IconData> iconMap = {
    'gym': LucideIcons.dumbbell,
    'book': LucideIcons.bookOpen,
    'water': LucideIcons.droplets,
    'meds': LucideIcons.pill,
    'clean': LucideIcons.sparkles,
    'cook': LucideIcons.utensils,
    'dog': LucideIcons.dog,
    'plant': LucideIcons.leaf,
    'sleep': LucideIcons.moon,
    'finance': LucideIcons.wallet,
  };

  /// List of all available icon keys for UI selection.
  static const List<String> availableIcons = [
    'gym',
    'book',
    'water',
    'meds',
    'clean',
    'cook',
    'dog',
    'plant',
    'sleep',
    'finance',
  ];

  /// Get the LucideIcon for a given icon name.
  /// Returns the requested icon, or defaults to checkCircle if not found.
  static IconData getIcon(String? iconName) {
    if (iconName == null || iconName.isEmpty) {
      return LucideIcons.checkCircle;
    }
    return iconMap[iconName] ?? LucideIcons.checkCircle;
  }

  /// Get a friendly display name for an icon key.
  static String getDisplayName(String iconKey) {
    final displayNames = {
      'gym': 'Gym',
      'book': 'Reading',
      'water': 'Hydration',
      'meds': 'Medication',
      'clean': 'Cleaning',
      'cook': 'Cooking',
      'dog': 'Pet Care',
      'plant': 'Plants',
      'sleep': 'Sleep',
      'finance': 'Finance',
    };
    return displayNames[iconKey] ?? 'Unknown';
  }
}
