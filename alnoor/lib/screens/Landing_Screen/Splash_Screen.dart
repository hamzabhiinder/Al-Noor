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
import 'package:alnoor/utils/globals.dart' as globals;

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
          // Black overlay
          Container(
            color: Colors.black.withOpacity(0.5), // Adjust opacity as needed
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
                SizedBox(height: screenSize.height * 0.035),
                // Buttons
                SizedBox(
                  width: screenSize.width * 0.5,
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
                      backgroundColor: Color(0xFFFFFFFF),
                      padding: EdgeInsets.symmetric(
                        vertical: screenSize.height * 0.02,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: FittedBox(
                      child: Text(
                        'LOG IN AS ALNOOR USER',
                        style: TextStyle(
                          fontSize: screenSize.width * 0.035,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.02),
                SizedBox(
                  width: screenSize.width * 0.5,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _onGuestButtonPressed(context);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(
                        vertical: screenSize.height * 0.02,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: Colors.white),
                      ),
                    ),
                    child: FittedBox(
                      child: Text(
                        'LOG IN AS GUEST USER',
                        style: TextStyle(
                          fontSize: screenSize.width * 0.035,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.01),
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
                            fontSize: screenSize.width * 0.03,
                          ),
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.005),
                      Container(
                        height: 1,
                        width: screenSize.width * 0.35,
                        color: Colors.white,
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
    globals.freshLogin = 'true';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
  }
}
