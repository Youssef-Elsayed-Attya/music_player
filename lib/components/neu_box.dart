import 'package:flutter/material.dart';

class NeuBox extends StatelessWidget {
  final Widget? child;
  final bool circle;
  final double size;

  const NeuBox(
      {super.key,
      required this.child,
      required this.circle,
      required this.size});

  @override
  Widget build(BuildContext context) {
    return circle
        ? Container(
            height: size,
            width: size,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:size>50?Theme.of(context).colorScheme.error:   Theme.of(context).colorScheme.surface,
                boxShadow: [
                  //darker shadow on bottom right

                  BoxShadow(
                      color: Colors.grey.shade800,
                      blurRadius: 10,
                      spreadRadius: 0.0001,
                      offset: const Offset(4, 4)),
                  BoxShadow(
                      color: size>50?Theme.of(context).colorScheme.primary: Theme.of(context).colorScheme.error,
                      blurRadius: 1,
                      spreadRadius: -3,
                      offset: const Offset(-4, -4))
                ]),
            child: child,
          )
        : Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  //darker shadow on bottom right
                  BoxShadow(
                      color: Colors.grey.shade800,
                      blurRadius: 20,
                      offset: const Offset(4, 4)),
                  BoxShadow(
                      color: Theme.of(context).colorScheme.primary,
                      blurRadius: 1,
                      offset: const Offset(-4, -4))
                ]),
            child: child,
          );
  }
}
