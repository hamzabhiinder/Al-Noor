import 'package:alnoor/screens/Home/dealors.dart';
import 'package:alnoor/screens/Home/uploads.dart';
import 'package:alnoor/screens/Home/view_moodboards.dart';
import 'package:alnoor/screens/Landing_Screen/About_Us.dart';
import 'package:flutter/material.dart';
import 'package:alnoor/utils/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../screens/Home/favourites.dart';
import '../screens/Home/home.dart';
import '../screens/Landing_Screen/Splash_Screen.dart';

class HamburgerMenu extends StatelessWidget {
  final bool isGuestUser;
  final bool isMenuVisible;
  final VoidCallback onMenuToggle;
  final num variant;

  HamburgerMenu({
    required this.isGuestUser,
    required this.isMenuVisible,
    required this.onMenuToggle,
    required this.variant,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Transform.translate(
          offset: Offset(variant == 1 ? -5 : 5, variant == 1 ? -41 : -37),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 15.0),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(0.0),
                bottomRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
                topLeft: Radius.circular(20.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildMenuItem(
                  icon: Icons.home,
                  title: 'Home',
                  onTap: () {
                    onMenuToggle();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.favorite,
                  title: 'Favorites',
                  onTap: () {
                    onMenuToggle();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Favourites(index: 0)),
                    );
                  },
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.upload,
                  title: 'Uploads',
                  onTap: () {
                    onMenuToggle();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Uploads(index: 3)),
                    );
                  },
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.menu_book,
                  title: 'About',
                  onTap: () {
                    onMenuToggle();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AboutUsPage(isGuestUser: isGuestUser)),
                    );
                  },
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.color_lens,
                  title: 'Moodboard',
                  onTap: () {
                    onMenuToggle();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Moodboards(index: 0)),
                    );
                  },
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.store,
                  title: 'Dealers',
                  onTap: () {
                    onMenuToggle();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DealersPage(isGuestUser: isGuestUser)),
                    );
                  },
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () {
                    _logout(context);
                  },
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildMenuItem(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.white,
      thickness: 2,
      height: 10,
    );
  }

  void _logout(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('https://alnoormdf.com/alnoor/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${globals.token}',
        },
        body: jsonEncode({}),
      );

      if (response.statusCode == 200) {
        globals.token = '';
        globals.userName = '';

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => StartScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout failed. Please try again.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }
}
