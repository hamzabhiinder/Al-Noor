// import 'package:alnoor/screens/Home/home.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../blocs/login_bloc.dart';
// import '../../repositories/login_repository.dart';
// import '../../utils/validators.dart';
// import '../../widgets/Input_Field.dart';
// import 'Register_Screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();

//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   void _onLoginButtonPressed() {
//     if (_formKey.currentState!.validate()) {
//       context.read<LoginBloc>().add(
//             LoginButtonPressed(
//               email: _emailController.text,
//               password: _passwordController.text,
//             ),
//           );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocListener<LoginBloc, LoginState>(
//         listener: (context, state) {
//           if (state is LoginLoading) {
//             // Show loading indicator
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Logging in...')),
//             );
//           } else if (state is LoginSuccess) {
//             // Navigate to HomeScreen on successful login
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => HomeScreen()),
//             );
//           } else if (state is LoginFailure) {
//             // Show error message on login failure
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('Login Failed: ${state.error}')),
//             );
//           }
//         },
//         child: Stack(
//           children: [
//             // Background Image
//             Container(
//               decoration: const BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage('assets/images/background.png'),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             // Content
//             Center(
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 40.0),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       children: [
//                         // Logo
//                         Image.asset(
//                           'assets/images/Logo.png',
//                           height: 100,
//                           fit: BoxFit.contain,
//                         ),
//                         const SizedBox(height: 20),
//                         // Input Fields
//                         CustomInputField(
//                           hintText: 'Your Email Address',
//                           iconAssetPath: 'assets/images/email.png',
//                           controller: _emailController,
//                           validator: Validators.validateEmail,
//                         ),
//                         CustomInputField(
//                           hintText: 'Password',
//                           iconAssetPath: 'assets/images/Password.png',
//                           controller: _passwordController,
//                           obscureText: true,
//                           validator: Validators.validatePassword,
//                         ),
//                         const SizedBox(height: 20),
//                         // Login Button
//                         ElevatedButton(
//                           onPressed: _onLoginButtonPressed,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.black87,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10.0),
//                             ),
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 50, vertical: 15),
//                           ),
//                           child: const Text('Login'),
//                         ),
//                         const SizedBox(height: 20),
//                         // Register Redirect
//                         TextButton(
//                           onPressed: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => RegisterScreen()));
//                           },
//                           child: const Text(
//                             "Don't have an account? Register here",
//                             style: TextStyle(color: Colors.black87),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }





import 'package:alnoor/screens/Home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/login_bloc.dart';
import '../../repositories/login_repository.dart';
import '../../utils/validators.dart';
import '../../widgets/Input_Field.dart';
import 'Register_Screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginButtonPressed() {
    if (_formKey.currentState!.validate()) {
      context.read<LoginBloc>().add(
            LoginButtonPressed(
              email: _emailController.text,
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginLoading) {
            // Show loading indicator
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Logging in...')),
            );
          } else if (state is LoginSuccess) {
            // Navigate to HomeScreen on successful login
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen( isGuestUser:false )),
            );
          } else if (state is LoginFailure) {
            // Show error message on login failure
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Login Failed: ${state.error}')),
            );
          }
        },
        child: Stack(
          children: [
            // Background Image
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Content
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width * 0.1, // Responsive padding
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Logo
                        Image.asset(
                          'assets/images/Logo.png',
                          height: screenSize.height * 0.1, // Responsive logo height
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: screenSize.height * 0.03), // Responsive spacing
                        // Input Fields
                        CustomInputField(
                          hintText: 'Your Email Address',
                          iconAssetPath: 'assets/images/email.png',
                          controller: _emailController,
                          validator: Validators.validateEmail,
                        ),
                        CustomInputField(
                          hintText: 'Password',
                          iconAssetPath: 'assets/images/Password.png',
                          controller: _passwordController,
                          obscureText: true,
                          validator: Validators.validatePassword,
                        ),
                        SizedBox(height: screenSize.height * 0.03), // Responsive spacing
                        // Login Button
                        ElevatedButton(
                          onPressed: _onLoginButtonPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black87,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  screenSize.width * 0.03), // Responsive border radius
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.2, // Responsive padding
                              vertical: screenSize.height * 0.02,
                            ),
                          ),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: screenSize.width * 0.05, // Responsive text size
                            ),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.02), // Responsive spacing
                        // Register Redirect
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterScreen()));
                          },
                          child: Text(
                            "Don't have an account? Register here",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: screenSize.width * 0.045, // Responsive text size
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
