import 'coder_state.dart';

/// Type definition for the callback used in [CoderObserver].
///
/// It receives the updated value whenever the observed state changes.
typedef CoderObserverCallback<T> = void Function(T value);

/// [CoderObserver] is a utility class that allows non-widget listeners (e.g., services,
/// background workers, etc.) to respond to state changes without rebuilding widgets.
///
/// It attaches to a [CoderState] and notifies all registered callbacks when the value changes.
///
/// Example usage:
/// ```dart
/// final observer = CoderObserver(counterState);
///
/// observer.add((value) {
///   print("Counter updated: $value");
/// });
///
/// // When no longer needed:
/// observer.dispose();
/// ```
class CoderObserver<T> {
  /// The state being observed.
  final CoderState<T> state;

  /// Internal list of registered callbacks.
  final List<CoderObserverCallback<T>> _callbacks = [];

  /// Constructor: starts listening to the state immediately.
  CoderObserver(this.state) {
    state.addListener(_notify); // Attach observer to state
  }

  /// Add a callback to be notified when the state changes.
  void add(CoderObserverCallback<T> callback) => _callbacks.add(callback);

  /// Remove a previously added callback.
  void remove(CoderObserverCallback<T> callback) => _callbacks.remove(callback);

  /// Internal method that notifies all registered callbacks.
  void _notify() {
    for (var cb in _callbacks) {
      cb(state.value);
    }
  }

  /// Dispose the observer to prevent memory leaks.
  /// Should be called when the observer is no longer needed.
  void dispose() => state.removeListener(_notify);
}
