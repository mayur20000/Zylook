import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class CustomNavBar extends StatefulWidget {
  const CustomNavBar({super.key});

  @override
  _CustomNavBarState createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  int _selectedIndex = 0;

  static const List<String> _routes = [
    '/home',
    '/category',
    '/account',
    '/cart',
    '/other',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    print('Navigating to ${_routes[index]}');
    Navigator.pushReplacementNamed(context, _routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(HugeIcons.strokeRoundedHome01),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(HugeIcons.strokeRoundedCatalogue),
          label: 'Category',
        ),
        BottomNavigationBarItem(
          icon: Icon(HugeIcons.strokeRoundedUser02),
          label: 'Account',
        ),
        BottomNavigationBarItem(
          icon: Icon(HugeIcons.strokeRoundedShoppingCart01),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(HugeIcons.strokeRoundedMoreHorizontal),
          label: 'Other',
        ),
      ],
    );
  }
}