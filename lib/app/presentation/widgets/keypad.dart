import 'package:flutter/material.dart';

class KeypadWidget extends StatelessWidget {
  const KeypadWidget({
    super.key,
    required this.value,
    required this.callback,
  });
  final String value;
  final GestureTapCallback? callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: callback,
      child: Container(
        margin: const EdgeInsets.all(8),
        child: IconButton(
          onPressed: callback,
          icon: value == 'x'
              ? const Icon(Icons.backspace)
              : value == '>'
                  ? const Icon(Icons.check)
                  : Text(
                      value,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
        ),
      ),
    );
  }
}
