import 'package:central_heating_control/app/presentation/screens/lock/pin.dart';
import 'package:central_heating_control/app/presentation/screens/lock/user_list.dart';

import 'package:flutter/material.dart';

class Nav {
  static Future<void> toUserList({
    required BuildContext context,
  }) async {
    Future.delayed(Duration.zero, () {
      if (context.mounted) {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
            barrierColor: Colors.black.withOpacity(0.3),
            barrierDismissible: true,
            opaque: false,
            pageBuilder: (_, __, ___) => UserListScreen(),
          ),
        );
      }
    });
  }

  static Future<String?> toPin({
    required BuildContext context,
    required String username,
  }) async {
    if (context.mounted) {
      final result = await Navigator.of(context).push(
        PageRouteBuilder(
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
          barrierColor: Colors.black.withOpacity(0.3),
          barrierDismissible: true,
          opaque: false,
          pageBuilder: (_, __, ___) => PinScreen(
            username: username,
          ),
        ),
      );
      return result;
    }
    return null;
  }
}
