import 'package:flutter/foundation.dart';

/// [CoderState] is a lightweight reactive state holder class.
///
/// It holds a single value of type `T` and notifies listeners when the value changes.
/// This can be used to manage simple reactive states without any external dependencies.
///
/// Example:
/// ```dart
/// final counter = CoderState<int>(0);
///
/// counter.addListener(() {
///   print("Counter changed: ${counter.value}");
/// });
///
/// counter.value++; // Triggers notification
/// ```
class CoderState<T> extends ChangeNotifier {
  /// Internal value holder.
  T _value;

  /// Constructor initializes the state with an initial value.
  CoderState(this._value);

  /// Returns the current value of the state.
  T get value => _value;

  /// Updates the value and notifies listeners if the value is different.
  set value(T newValue) {
    if (_value != newValue) {
      _value = newValue;
      notifyListeners();
    }
  }
}
