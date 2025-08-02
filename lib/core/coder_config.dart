import 'package:flutter/material.dart';
import 'coder_state.dart';

/// CoderConfig provides global reactive states for common app-level settings.
///
/// This class holds static instances of `CoderState` that can be accessed
/// anywhere in the app to reactively manage things like theme and locale.
///
/// Example:
/// ```dart
/// CoderConfig.themeMode.value = ThemeMode.dark;
/// CoderConfig.locale.value = Locale('en');
/// ```
class CoderConfig {
  /// Global reactive state for [ThemeMode] (light, dark, or system).
  /// Can be used with MaterialApp's themeMode:
  /// ```dart
  /// themeMode: CoderConfig.themeMode.value,
  /// ```
  static final themeMode = CoderState<ThemeMode>(ThemeMode.system);

  /// Global reactive state for [Locale].
  /// Can be used to change app language:
  /// ```dart
  /// locale: CoderConfig.locale.value,
  /// ```
  static final locale = CoderState<Locale?>(null);
}
