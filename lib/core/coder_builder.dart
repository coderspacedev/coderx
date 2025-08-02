import 'package:flutter/widgets.dart';
import 'coder_state.dart';

/// CoderBuilder is a reactive widget that rebuilds whenever [CoderState] changes.
///
/// This is similar to a combination of ValueListenableBuilder and StatefulWidget.
/// You can use this for precise control over how a single state affects your widget tree.
class CoderBuilder<T> extends StatefulWidget {
  /// The reactive state to listen to.
  final CoderState<T> state;

  /// Builder function which provides the latest value of the state.
  final Widget Function(BuildContext, T) builder;

  const CoderBuilder({
    required this.state,
    required this.builder,
    super.key,
  });

  @override
  State<CoderBuilder<T>> createState() => _CoderBuilderState<T>();
}

class _CoderBuilderState<T> extends State<CoderBuilder<T>> {
  @override
  void initState() {
    super.initState();

    // Start listening to the state changes.
    widget.state.addListener(_onStateChanged);
  }

  /// Called whenever the state changes to trigger a rebuild.
  void _onStateChanged() => setState(() {});

  @override
  void dispose() {
    // Clean up the listener when the widget is removed from the tree.
    widget.state.removeListener(_onStateChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Call the builder with the latest state value.
    return widget.builder(context, widget.state.value);
  }
}
