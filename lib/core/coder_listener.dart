import 'package:flutter/widgets.dart';
import 'coder_state.dart';

/// [CoderListener] is used for performing side effects in response to state changes.
///
/// It does not rebuild UI like [CoderConsumer], but instead runs a callback
/// (e.g., show a Snackbar, navigate to another page, log data, etc.)
///
/// Example usage:
/// ```dart
/// CoderListener<String?>(
///   state: errorState,
///   listener: (context, error) {
///     if (error != null) {
///       ScaffoldMessenger.of(context).showSnackBar(
///         SnackBar(content: Text(error)),
///       );
///     }
///   },
///   child: YourWidgetTree(),
/// )
/// ```
class CoderListener<T> extends StatefulWidget {
  /// The state to listen for changes.
  final CoderState<T> state;

  /// Callback function to be invoked whenever the state changes.
  final void Function(BuildContext context, T value) listener;

  /// The child widget to render. This widget will not rebuild on state changes.
  final Widget child;

  const CoderListener({
    super.key,
    required this.state,
    required this.listener,
    required this.child,
  });

  @override
  State<CoderListener<T>> createState() => _CoderListenerState<T>();
}

class _CoderListenerState<T> extends State<CoderListener<T>> {
  @override
  void initState() {
    super.initState();
    // Attach the listener when widget is initialized.
    widget.state.addListener(_onChange);
  }

  @override
  void dispose() {
    // Clean up the listener to prevent memory leaks.
    widget.state.removeListener(_onChange);
    super.dispose();
  }

  /// Callback that gets called when the state changes.
  void _onChange() {
    widget.listener(context, widget.state.value);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
