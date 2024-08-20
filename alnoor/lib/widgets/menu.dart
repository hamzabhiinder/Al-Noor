import 'package:flutter/material.dart';
import 'package:alnoor/utils/globals.dart' as globals;
import '../screens/Home/favourites.dart';
import '../screens/Home/home.dart';
import '../screens/Landing_Screen/Splash_Screen.dart';

class HamburgerMenu extends StatelessWidget {
  final bool isGuestUser;

  HamburgerMenu({required this.isGuestUser});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1.0,
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4, // Adjust the width to fit your needs
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isGuestUser)  // Only show if not a guest user
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Hello, ${globals.userName}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (!isGuestUser) Divider(),  // Show divider only if userName is shown
            _buildMenuItem(
              icon: Icons.home,
              title: 'Home',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen(isGuestUser: isGuestUser)),
                );
              },
            ),
            if (!isGuestUser)
              _buildMenuItem(
                icon: Icons.favorite,
                title: 'Favorites',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Favourites(index: 0)),
                  );
                },
              ),
            _buildMenuItem(
              icon: Icons.logout,
              title: 'Logout',
              onTap: () {
                _logout(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({required IconData icon, required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          children: [
            Icon(icon, size: 20),
            SizedBox(width: 10),
            Text(title),
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext context) {
    // Add your logout logic here, for example:
    // 1. Clear user session
    // 2. Navigate to login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => StartScreen()),
    );
  }
}
