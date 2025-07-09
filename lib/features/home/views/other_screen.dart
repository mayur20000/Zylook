import 'package:flutter/material.dart';
// Removed: import '../widgets/custom_nav_bar.dart'; // No longer needed here

class OtherScreen extends StatelessWidget {
  const OtherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Removed Scaffold, only provide the body content
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF8F4F0), Color(0xFFDDD0C8), Color(0xFFB0A98F)],
        ),
      ),
      child: const SafeArea(
        child: Center(
          child: Text(
            'Other Screen (Coming Soon)',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}