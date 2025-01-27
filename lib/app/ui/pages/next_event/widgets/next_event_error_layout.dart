import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:flutter/material.dart';

class NextEventErrorLayout extends StatelessWidget {

  final VoidCallback onRetry;

  const NextEventErrorLayout({
    super.key,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Algo errado aconteceu, tente novamente",
            style: context.textStyles.bodyLarge,
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            onPressed: onRetry,
            child: Text(
              "RECARREGAR",
              style: context.textStyles.labelLarge,
            ),
          ),
        ],
      ),
    );
  }
}