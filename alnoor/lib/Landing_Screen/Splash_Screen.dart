import 'package:flutter/material.dart';

import '../Authentication/Register_Screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Logo
                Image.asset('assets/images/Logo.png'),
                SizedBox(height: 30),
                // Buttons
                ElevatedButton(
                  onPressed: () {
                    // Add functionality for login
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Color(0xFFFFFFFF), // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  child: Text('LOG IN AS ALNOOR USER'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Add functionality for guest login
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, // Text color
                    backgroundColor: Colors.transparent, // Button background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(color: Colors.white), // Border color
                    ),
                  ),
                  child: Text('LOG IN AS GUEST USER'),
                ),
                SizedBox(height: 10),
                // Create new account link
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );// Add functionality for creating a new account
                  },
                    
                  child: Column(
                    children: [
                      Text(
                        'CREATE NEW ACCOUNT',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 2), // Space between text and underline
                      Container(
                        height: 1, // Height of the underline
                        width: 170, // Full width underline
                        color: Colors.white, // Color of the underline
                      ),
                    ],
                  ),
                ),
              ],),
          ),
        ],
      ),
    );
  }
}
