import 'package:flutter/widgets.dart';
import 'coder_state.dart';

/// [CoderConsumer] is a widget that listens to a single [CoderState] and rebuilds
/// whenever the state changes.
///
/// This is useful when you want to reactively rebuild part of the UI based on one state.
///
/// Example usage:
/// ```dart
/// CoderConsumer<int>(
///   state: counterState,
///   builder: (context, value) => Text('Counter: $value'),
/// )
/// ```
class CoderConsumer<T> extends StatelessWidget {
  final CoderState<T> state;
  final Widget Function(BuildContext, T) builder;

  const CoderConsumer({
    required this.state,
    required this.builder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: state, // Listen to CoderState changes
      builder: (context, _) => builder(context, state.value), // Rebuild with current value
    );
  }
}

/// [CoderMultiConsumer] is a widget that listens to multiple [Listenable]s (e.g., CoderStates,
/// CoderComputed, or other Listenable objects) and rebuilds when any of them change.
///
/// This is useful when you need to reactively rebuild a widget that depends on multiple states.
///
/// Example usage:
/// ```dart
/// CoderMultiConsumer(
///   states: [themeState, localeState],
///   builder: (context) {
///     return MaterialApp(...);
///   },
/// )
/// ```
class CoderMultiConsumer extends StatelessWidget {
  final List<Listenable> states;
  final WidgetBuilder builder;

  const CoderMultiConsumer({
    required this.states,
    required this.builder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge(states), // Merge multiple listenables into one
      builder: (context, _) => builder(context), // Rebuild when any state changes
    );
  }
}
