import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class SlideRightRoute extends PageRouteBuilder {
  final Widget Function(BuildContext, Animation<double>, Animation<double>)
      pageBuilder;
  @override
  final RouteSettings settings;
  SlideRightRoute({required this.pageBuilder, required this.settings})
      : super(
          pageBuilder: pageBuilder,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            final tween = Tween(begin: begin, end: end);
            final offsetAnimation = animation.drive(tween);
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              fillColor: Colors.white,
              child: child,
            );
          },
          settings: settings,
          reverseTransitionDuration: const Duration(milliseconds: 500),
          transitionDuration: const Duration(milliseconds: 500),
        );
}
