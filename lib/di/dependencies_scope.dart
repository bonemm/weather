import 'package:flutter/widgets.dart';
import 'package:weather/di/di_container.dart';

class DependenciesScope extends InheritedWidget {
  final DIContainer dependencies;

  const DependenciesScope({required super.child, required this.dependencies, super.key});

  static DIContainer of(BuildContext context, {bool listen = false}) {
    final dependencies = listen
        ? context.dependOnInheritedWidgetOfExactType<DependenciesScope>()?.dependencies
        : context.getInheritedWidgetOfExactType<DependenciesScope>()?.dependencies;
    if (dependencies == null) {
      (throw ArgumentError('Out of scope, not found inherited widget '));
    } else {
      return dependencies;
    }
  }

  @override
  bool updateShouldNotify(DependenciesScope oldWidget) {
    return !identical(dependencies, oldWidget.dependencies);
  }
}
