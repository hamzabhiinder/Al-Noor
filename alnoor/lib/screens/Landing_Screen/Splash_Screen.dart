import 'package:alnoor/Screens/Authentication/Login_Screen.dart';
import 'package:alnoor/blocs/category_bloc.dart';
import 'package:alnoor/blocs/product_bloc.dart';
import 'package:alnoor/repositories/category_repository.dart';
import 'package:alnoor/repositories/product_repository.dart';
import 'package:alnoor/screens/Home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/register_bloc.dart';
import '../../repositories/register_repository.dart';
import '../Authentication/Register_Screen.dart';

// void main() {
//   runApp(
//     MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (context) => CategoryBloc(CategoryRepository()),
//         ),
//         BlocProvider(
//           create: (context) => ProductBloc(ProductRepository()),
//         ),
//       ],
//       child: MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: StartScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class StartScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: <Widget>[
//           // Background Image
//           Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/images/background.png'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           // Overlay content
//           Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 // Logo
//                 Image.asset('assets/images/Logo.png'),
//                 SizedBox(height: 30),
//                 // Buttons
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) => LoginScreen()));
//                   },
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: Colors.black,
//                     backgroundColor: Color(0xFFFFFFFF), // Text color
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(5.0),
//                     ),
//                   ),
//                   child: Text('LOG IN AS ALNOOR USER'),
//                 ),
//                 SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) => HomeScreen()));
//                   },
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: Colors.white, // Text color
//                     backgroundColor:
//                         Colors.transparent, // Button background color
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(5.0),
//                       side: BorderSide(color: Colors.white), // Border color
//                     ),
//                   ),
//                   child: Text('LOG IN AS GUEST USER'),
//                 ),
//                 SizedBox(height: 10),
//                 // Create new account link
//                 TextButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => RegisterScreen()),
//                     ); // Add functionality for creating a new account
//                   },
//                   child: Column(
//                     children: [
//                       Text(
//                         'CREATE NEW ACCOUNT',
//                         style: TextStyle(
//                           color: Colors.white,
//                         ),
//                       ),
//                       SizedBox(height: 2), // Space between text and underline
//                       Container(
//                         height: 1, // Height of the underline
//                         width: 170, // Full width underline
//                         color: Colors.white, // Color of the underline
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }




class StartScreen extends StatelessWidget {
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Color(0xFFFFFFFF), // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  child: Text('LOG IN AS ALNOOR USER'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, // Text color
                    backgroundColor:
                        Colors.transparent, // Button background color
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
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => BlocProvider(
                    //       create: (context) => RegisterBloc(
                    //         registerRepository: RegisterRepository(),
                    //       ),
                    //       child: RegisterScreen(),
                    //     ),
                    //   ),
                    // );
                    // // Navigate to RegisterScreen with RegisterBloc
                  Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => BlocProvider(
      create: (context) => RegisterBloc(registerRepository: RegisterRepository()),
      child: RegisterScreen(),
    ),
  ),
);
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}