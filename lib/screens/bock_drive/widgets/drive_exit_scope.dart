import 'package:flutter/widgets.dart';

class DriveExitScope extends InheritedWidget {
  const DriveExitScope({
    super.key,
    required super.child,
    this.onExit,
  });

  final VoidCallback? onExit;

  static DriveExitScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DriveExitScope>();
  }

  @override
  bool updateShouldNotify(DriveExitScope oldWidget) {
    return oldWidget.onExit != onExit;
  }
}
