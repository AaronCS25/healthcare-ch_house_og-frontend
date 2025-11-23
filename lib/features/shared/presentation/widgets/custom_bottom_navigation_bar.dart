import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const CustomBottomNavigationBar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: navigationShell.currentIndex,
      onDestinationSelected: navigationShell.goBranch,
      destinations: [
        const NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Inicio',
        ),
        const NavigationDestination(
          icon: Icon(Icons.health_and_safety_outlined),
          selectedIcon: Icon(Icons.health_and_safety),
          label: 'Seguros',
        ),
        const NavigationDestination(
          icon: Icon(Icons.chat_bubble_outline),
          selectedIcon: Icon(Icons.chat_bubble),
          label: 'AI Chat',
        ),
        const NavigationDestination(
          icon: Icon(Icons.shopping_bag_outlined),
          selectedIcon: Icon(Icons.shopping_bag),
          label: 'Para mí',
        ),
        const NavigationDestination(
          icon: Icon(Icons.wallet_giftcard_outlined),
          selectedIcon: Icon(Icons.wallet_giftcard),
          label: 'Bienestar',
        ),
      ],
    );
  }
}
