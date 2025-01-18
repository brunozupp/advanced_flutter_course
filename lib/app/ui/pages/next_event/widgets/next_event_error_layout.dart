import 'package:flutter/material.dart';

class NextEventErrorLayout extends StatelessWidget {

  final VoidCallback onRetry;

  const NextEventErrorLayout({
    super.key,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Algo errado aconteceu, tente novamente"),
        ElevatedButton(
          onPressed: onRetry,
          child: const Text("Recarregar"),
        ),
      ],
    );
  }
}