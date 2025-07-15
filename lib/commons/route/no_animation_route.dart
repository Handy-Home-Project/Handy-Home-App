import 'package:flutter/cupertino.dart';

class NoAnimationRoute extends PageRouteBuilder {
  NoAnimationRoute({
    required Widget Function(BuildContext context) builder
  }) : super(
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
    transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
  );
}