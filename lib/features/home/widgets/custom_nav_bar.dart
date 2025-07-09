import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import Bloc
import '../../auth/bloc/auth_bloc.dart';

class CustomNavBar extends StatefulWidget {
  // Add a callback to notify the parent when an item is selected
  final int selectedIndex;
  final Function(int) onItemSelected;

  const CustomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  _CustomNavBarState createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  // _selectedIndex is now managed by the parent via widget.selectedIndex

  void _onItemTapped(int index) {
    if (index == 2) { // Assuming 'Account' is at index 2
      _showAccountOptions(context);
    } else {
      widget.onItemSelected(index); // Notify the parent to change the screen
    }
  }

  void _showAccountOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('My Profile'),
                onTap: () {
                  Navigator.pop(bc); // Close bottom sheet
                  // Navigate using the root navigator for screens that are not part of the main tab content
                  Navigator.of(context).pushNamed('/profile');
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(bc); // Close bottom sheet
                  Navigator.of(context).pushNamed('/settings');
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Logout', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(bc); // Close bottom sheet
                  context.read<AuthBloc>().add(AuthLogoutEvent());
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.selectedIndex, // Use the selectedIndex from the parent
      onTap: _onItemTapped,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed, // Ensures all labels are shown
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