import 'package:flutter/foundation.dart';
import 'coder_state.dart';

/// `CoderComputed<T>` is a reactive computed value based on one or more [CoderState]s.
///
/// Whenever any of the dependent states change, the `compute` function is re-evaluated.
/// If the result is different from the previous value, listeners are notified.
class CoderComputed<T> extends ChangeNotifier {
  /// Function that computes the derived value.
  final T Function() compute;

  /// List of dependent states that this computed value listens to.
  final List<CoderState> dependencies;

  /// Internal storage of the current computed value.
  late T _value;

  /// Creates a computed state based on given dependencies.
  CoderComputed({required this.compute, required this.dependencies}) {
    // Initial computation
    _value = compute();

    // Listen to changes in dependencies
    for (var dep in dependencies) {
      dep.addListener(_update);
    }
  }

  /// Gets the current computed value.
  T get value => _value;

  /// Called when any dependency changes.
  /// Recomputes the value and notifies listeners if it has changed.
  void _update() {
    final newValue = compute();
    if (newValue != _value) {
      _value = newValue;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    // Remove listeners from dependencies when this computed is disposed.
    for (var dep in dependencies) {
      dep.removeListener(_update);
    }
    super.dispose();
  }
}
