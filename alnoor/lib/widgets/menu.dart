import 'package:flutter/material.dart';
import 'package:alnoor/utils/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../screens/Home/favourites.dart';
import '../screens/Home/home.dart';
import '../screens/Landing_Screen/Splash_Screen.dart';

class HamburgerMenu extends StatelessWidget {
  final bool isGuestUser;
  final bool isMenuVisible;  // Add this line to accept the state
  final VoidCallback onMenuToggle;  // Add this to toggle the menu

  HamburgerMenu({
    required this.isGuestUser,
    required this.isMenuVisible,
    required this.onMenuToggle,
  });

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
              if (isGuestUser)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Guest',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
            if (!isGuestUser)
            _buildMenuItem(
              icon: Icons.home,
              title: 'Home',
              onTap: () {
                onMenuToggle();  // Close the menu when a menu item is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
            if (!isGuestUser)
              _buildMenuItem(
                icon: Icons.favorite,
                title: 'Favorites',
                onTap: () {
                  onMenuToggle();  // Close the menu when a menu item is tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Favourites(index: 0)),
                  );
                },
              ),
            if(!isGuestUser)
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

  void _logout(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('https://alnoormdf.com/alnoor/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${globals.token}', // Assuming the token is stored globally
        },
        body: jsonEncode({}), // Add any required body parameters if needed
      );
      print('API Response Status Code: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Successfully logged out, clear user session and navigate to StartScreen
        globals.token = '';  // Clear the user token or any other session data
        globals.userName = '';  // Clear the user name or any other session data

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => StartScreen()),
        );
      } else {
        // Handle errors here
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout failed. Please try again.')),
        );
      }
    } catch (e) {
      // Handle any exceptions here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }
}
