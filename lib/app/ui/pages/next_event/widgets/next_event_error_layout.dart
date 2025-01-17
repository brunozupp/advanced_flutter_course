import 'package:flutter/material.dart';

class NextEventErrorLayout extends StatelessWidget {
  const NextEventErrorLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Algo errado aconteceu, tente novamente"),
        ElevatedButton(
          onPressed: () {},
          child: const Text("Recarregar"),
        ),
      ],
    );
  }
}