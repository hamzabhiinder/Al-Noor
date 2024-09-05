import 'package:alnoor/classes/image_manager.dart';
import 'package:alnoor/screens/Authentication/Login_Screen.dart';
import 'package:alnoor/blocs/login_bloc.dart';
import 'package:alnoor/repositories/login_repository.dart';
import 'package:alnoor/screens/Home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../blocs/register_bloc.dart';
import '../../repositories/register_repository.dart';
import '../Authentication/Register_Screen.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/BGg.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          // Overlay content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Logo
                Container(
                  width: screenSize.width * 0.5, // Responsive width
                  height: screenSize.height * 0.2, // Responsive height
                  child: Image.asset('assets/images/Logo.png'),
                ),
                SizedBox(
                    height: screenSize.height * 0.035), // Responsive spacing
                // Buttons
                SizedBox(
                  width: screenSize.width * 0.5, // Responsive button width
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => LoginBloc(
                              loginRepository: LoginRepository(),
                            ),
                            child: LoginScreen(),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Color(0xFFFFFFFF), // Text color
                      padding: EdgeInsets.symmetric(
                        vertical: screenSize.height * 0.02,
                      ), // Responsive padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: FittedBox(
                      child: Text(
                        'LOG IN AS ALNOOR USER',
                        style: TextStyle(fontSize: screenSize.width * 0.035,),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                    height: screenSize.height * 0.02), // Responsive spacing
                SizedBox(
                  width: screenSize.width * 0.5, // Responsive button width
                  child: ElevatedButton(
                    onPressed: () async {
                      await _onGuestButtonPressed(context);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, // Text color
                      backgroundColor:
                          Colors.transparent, // Button background color
                      padding: EdgeInsets.symmetric(
                        vertical: screenSize.height * 0.02,
                      ), // Responsive padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: Colors.white), // Border color
                      ),
                    ),
                    child: FittedBox(
                      child: Text(
                        'LOG IN AS GUEST USER',
                        style: TextStyle(fontSize: screenSize.width * 0.035),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                    height: screenSize.height * 0.01), // Responsive spacing
                // Create new account link
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => RegisterBloc(
                            registerRepository: RegisterRepository(),
                          ),
                          child: RegisterScreen(),
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      FittedBox(
                        child: Text(
                          'CREATE NEW ACCOUNT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenSize.width *
                                0.03, // Responsive font size
                          ),
                        ),
                      ),
                      SizedBox(
                          height: screenSize.height *
                              0.005), // Space between text and underline
                      Container(
                        height: 1, // Height of the underline
                        width: screenSize.width *
                            0.35, // Responsive underline width
                        color: Colors.white, // Color of the underline
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onGuestButtonPressed(BuildContext context) async {
    ImageManager().setImage(1, null);
    ImageManager().setImage(2, null);
    ImageManager().setImage(3, null);
    ImageManager().setImage(4, null);
    ImageManager().setImage(5, null);
    ImageManager().setImage(6, null);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isGuestUser', true);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
  }
}
