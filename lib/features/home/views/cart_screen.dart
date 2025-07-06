import 'package:flutter/material.dart';
import '../widgets/custom_nav_bar.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
              'Cart Screen (Coming Soon)',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CustomNavBar(),
    );
  }
}