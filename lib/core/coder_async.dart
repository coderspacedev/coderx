import '../coderx.dart';

/// CoderAsync is a wrapper for managing the async state of any asynchronous operation.
/// It provides a [CoderState] of [CoderAsyncState] which holds loading, data, and error information.
class CoderAsync<T> {
  /// Holds the current state of the async operation (loading, data, error).
  final CoderState<CoderAsyncState<T>> state =
  CoderState(CoderAsyncState<T>.idle());

  /// Runs the asynchronous task and updates the [state] accordingly.
  ///
  /// - Sets loading state before execution.
  /// - If successful, sets the data.
  /// - If error occurs, captures and stores the error.
  Future<void> run(Future<T> Function() task) async {
    state.value = CoderAsyncState<T>.loading();
    try {
      final result = await task();
      state.value = CoderAsyncState<T>.data(result);
    } catch (e) {
      state.value = CoderAsyncState<T>.error(e.toString());
    }
  }

  /// Resets the async state back to idle.
  void reset() {
    state.value = CoderAsyncState<T>.idle();
  }

  /// Whether the current state is loading.
  bool get isLoading => state.value.isLoading;

  /// Whether the async task has successfully returned data.
  bool get hasData => state.value.hasData;

  /// Whether an error occurred during the async task.
  bool get hasError => state.value.hasError;

  /// Accessor for the data.
  T? get data => state.value.data;

  /// Accessor for the error message.
  String? get error => state.value.error;
}

/// A container for async operation state, including loading, data, and error.
class CoderAsyncState<T> {
  /// Indicates whether the async operation is in loading state.
  final bool isLoading;

  /// Holds the result data if the operation is successful.
  final T? data;

  /// Holds the error message if the operation failed.
  final String? error;

  /// Returns true if data is present.
  bool get hasData => data != null;

  /// Returns true if error is present.
  bool get hasError => error != null;

  /// Private constructor to restrict instance creation via named factories.
  const CoderAsyncState._({this.isLoading = false, this.data, this.error});

  /// Factory to create an idle state (no loading, no data, no error).
  factory CoderAsyncState.idle() => const CoderAsyncState._();

  /// Factory to create a loading state.
  factory CoderAsyncState.loading() =>
      const CoderAsyncState._(isLoading: true);

  /// Factory to create a state containing [data].
  factory CoderAsyncState.data(T data) =>
      CoderAsyncState._(data: data, isLoading: false);

  /// Factory to create a state containing [error] message.
  factory CoderAsyncState.error(String error) =>
      CoderAsyncState._(error: error, isLoading: false);
}

