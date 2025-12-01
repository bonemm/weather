// // theme_provider.dart
// import 'package:flutter/material.dart';
// import 'package:weather/ui/theme/theme_service.dart';

// class ThemeInherited extends InheritedWidget {
//   final ThemeService themeService;
//   final Widget child;

//   const ThemeInherited({
//     super.key,
//     required this.themeService,
//     required this.child,
//   }) : super(child: child);

//   static ThemeService of(BuildContext context) {
//     final ThemeInherited? result = context.dependOnInheritedWidgetOfExactType<ThemeInherited>();
//     assert(result != null, 'No ThemeInherited found in context');
//     return result!.themeService;
//   }

//   @override
//   bool updateShouldNotify(ThemeInherited oldWidget) {
//     return themeService != oldWidget.themeService;
//   }
// }

// class ThemeProvider extends StatefulWidget {
//   final Widget child;
//   final ThemeService? themeModel;

//   const ThemeProvider({
//     super.key,
//     required this.child,
//     this.themeModel,
//   });

//   @override
//   State<ThemeProvider> createState() => _ThemeProviderState();

//   static ThemeService of(BuildContext context) {
//     return ThemeInherited.of(context);
//   }
// }

// class _ThemeProviderState extends State<ThemeProvider> {
//   late ThemeService _themeModel;

//   @override
//   void initState() {
//     super.initState();
//     _themeModel = widget.themeModel ?? ThemeService();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ThemeInherited(
//       themeService: _themeModel,
//       child: widget.child,
//     );
//   }
// }
