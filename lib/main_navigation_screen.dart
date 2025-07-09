import 'package:flutter/material.dart';

// Import your different tab screens (these should NOT have their own Scaffold/NavBar)
import 'package:zylook/features/home/views/home_screen.dart';
import 'package:zylook/features/cart/views/cart_screen.dart';
import 'package:zylook/features/home/views/category_screen.dart';
import 'package:zylook/features/home/views/account_screen.dart';
import 'package:zylook/features/home/views/other_screen.dart';

import 'features/home/widgets/custom_nav_bar.dart';

// GlobalKeys for each tab's Navigator
final GlobalKey<NavigatorState> homeTabNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> categoryTabNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> accountTabNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> cartTabNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> otherTabNavigatorKey = GlobalKey<NavigatorState>();


class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  // List of GlobalKeys for easier access
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    homeTabNavigatorKey,
    categoryTabNavigatorKey,
    accountTabNavigatorKey,
    cartTabNavigatorKey,
    otherTabNavigatorKey,
  ];

  // This will handle the system back button
  Future<bool> _onWillPop() async {
    // Check if the current tab's navigator can pop
    if (_navigatorKeys[_selectedIndex].currentState?.canPop() == true) {
      _navigatorKeys[_selectedIndex].currentState?.pop();
      return false; // Prevent the app from closing, handle pop within the tab
    } else {
      // If the current tab's navigator cannot pop, and it's the home tab
      // or if you're on the very first screen of the app, then allow the app to close.
      // Or, you can show an exit confirmation dialog.
      return true; // Allow the app to close
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope( // Use PopScope for back button control
      canPop: false, // Prevents default back behavior
      onPopInvoked: (didPop) async {
        if (didPop) { // This means the pop was handled by a child widget
          return;
        }
        await _onWillPop();
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            // Wrap each screen with its own Navigator
            _buildTabNavigator(
              key: homeTabNavigatorKey,
              initialRoute: '/', // Or whatever route your HomeScreen should be initially
              screen: const HomeScreen(),
            ),
            _buildTabNavigator(
              key: categoryTabNavigatorKey,
              initialRoute: '/',
              screen: const CategoryScreen(),
            ),
            _buildTabNavigator(
              key: accountTabNavigatorKey,
              initialRoute: '/',
              screen: const AccountScreen(),
            ),
            _buildTabNavigator(
              key: cartTabNavigatorKey,
              initialRoute: '/',
              screen: const CartScreen(),
            ),
            _buildTabNavigator(
              key: otherTabNavigatorKey,
              initialRoute: '/',
              screen: const OtherScreen(),
            ),
          ],
        ),
        bottomNavigationBar: CustomNavBar(
          selectedIndex: _selectedIndex,
          onItemSelected: (index) {
            // If the same tab is tapped again, pop to the root of that tab's stack
            if (_selectedIndex == index) {
              _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
            }
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }

  // Helper method to create a Navigator for each tab
  Widget _buildTabNavigator({
    required GlobalKey<NavigatorState> key,
    required String initialRoute,
    required Widget screen, // The actual content widget for the tab
  }) {
    return Navigator(
      key: key,
      initialRoute: initialRoute,
      onGenerateRoute: (routeSettings) {
        // Define routes for each tab's internal navigation
        // For simplicity, we'll start with just the main screen for each tab
        // You would add more routes here for screens accessible *within* this tab
        switch (routeSettings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => screen);
        // Example of a nested route within the home tab:
        // case '/outfit_detail_nested':
        //   final args = routeSettings.arguments as Outfit;
        //   return MaterialPageRoute(builder: (_) => OutfitDetailScreen(outfit: args));
          default:
            return MaterialPageRoute(builder: (_) => Text('Unknown route: ${routeSettings.name}'));
        }
      },
    );
  }
}