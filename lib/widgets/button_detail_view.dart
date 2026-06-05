import 'package:flutter/material.dart';
import 'glassmorphism_container.dart';
import '../models/button_info.dart';

class ButtonDetailView extends StatelessWidget {
  final ButtonDefinition buttonDefinition;
  
  const ButtonDetailView({
    super.key,
    required this.buttonDefinition,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphismContainer(
      width: 250,
      height: 120,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              buttonDefinition.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              buttonDefinition.functionDescription,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
