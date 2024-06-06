import 'package:flutter/widgets.dart';

class ComIndicatorLedWidget extends StatelessWidget {
  const ComIndicatorLedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Center(
        child: Text(
          'Rx: ooxo\nTx: xoxo',
          style: TextStyle(fontSize: 10),
        ),
      ),
    );
  }
}
