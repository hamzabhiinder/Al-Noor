// import 'package:flutter/material.dart';

// import '../../services/api_service.dart';
// import '../../utils/validators.dart';
// import '../../widgets/Input_Field.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({Key? key}) : super(key: key);

//   @override
//   _RegisterScreenState createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final _formKey = GlobalKey<FormState>();

//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _cityController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();

//   final ApiService _apiService = ApiService();

//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _cityController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   void _register() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//       });

//       bool isRegistered = await _apiService.registerUser(
//         _nameController.text,
//         _emailController.text,
//         _phoneController.text,
//         _cityController.text,
//         _passwordController.text,
//       );

//       setState(() {
//         _isLoading = false;
//       });

//       if (isRegistered) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Registration Successful')),
//         );
//         // Navigate to another screen or reset the form
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Registration Failed')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background Image
//           Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/images/background.png'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           // Content
//           Center(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 40.0),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       // Logo
//                       Image.asset(
//                         'assets/images/Logo.png',
//                         height: 100,
//                         fit: BoxFit.contain,
//                       ),
//                       const SizedBox(height: 20),
//                       // Input Fields
//                       CustomInputField(
//                         hintText: 'Your Name',
//                         iconAssetPath: 'assets/images/user.png',
//                         controller: _nameController,
//                         validator: Validators.validateName,
//                       ),
//                       CustomInputField(
//                         hintText: 'Your Email Address',
//                         iconAssetPath: 'assets/images/email.png',
//                         controller: _emailController,
//                         validator: Validators.validateEmail,
//                       ),
//                       CustomInputField(
//                         hintText: 'Phone Number',
//                         iconAssetPath: 'assets/images/PhoneNumber.png',
//                         controller: _phoneController,
//                         validator: Validators.validatePhone,
//                       ),
//                       CustomInputField(
//                         hintText: 'City',
//                         iconAssetPath: 'assets/images/City.png',
//                         controller: _cityController,
//                         validator: Validators.validateCity,
//                       ),
//                       CustomInputField(
//                         hintText: 'Password',
//                         iconAssetPath: 'assets/images/Password.png',
//                         controller: _passwordController,
//                         obscureText: true,
//                         validator: Validators.validatePassword,
//                       ),
//                       CustomInputField(
//                         hintText: 'Confirm Password',
//                         iconAssetPath: 'assets/images/Password.png',
//                         controller: _confirmPasswordController,
//                         obscureText: true,
//                         validator: (value) => Validators.validateConfirmPassword(
//                             value, _passwordController.text),
//                       ),
//                       const SizedBox(height: 20),
//                       // Create Button
//                       _isLoading
//                           ? const CircularProgressIndicator()
//                           : ElevatedButton(
//                               onPressed: _register,
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.black87, // Button color
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10.0),
//                                 ),
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 50, vertical: 15),
//                               ),
//                               child: const Text('Create'),
//                             ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// import 'package:alnoor/blocs/register_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../utils/validators.dart';
// import '../../widgets/Input_Field.dart';
// import '../Home/home.dart';  // Import the HomeScreen

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({Key? key}) : super(key: key);

//   @override
//   _RegisterScreenState createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final _formKey = GlobalKey<FormState>();

//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _cityController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _cityController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   void _register() {
//     if (_formKey.currentState!.validate()) {
//       BlocProvider.of<RegisterBloc>(context).add(RegisterButtonPressed(
//         name: _nameController.text,
//         email: _emailController.text,
//         password: _passwordController.text,
//       ));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background Image
//           Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/images/background.png'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           // Content
//           Center(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 40.0),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       // Logo
//                       Image.asset(
//                         'assets/images/Logo.png',
//                         height: 100,
//                         fit: BoxFit.contain,
//                       ),
//                       const SizedBox(height: 20),
//                       // Input Fields
//                       CustomInputField(
//                         hintText: 'Your Name',
//                         iconAssetPath: 'assets/images/user.png',
//                         controller: _nameController,
//                         validator: Validators.validateName,
//                       ),
//                       CustomInputField(
//                         hintText: 'Your Email Address',
//                         iconAssetPath: 'assets/images/email.png',
//                         controller: _emailController,
//                         validator: Validators.validateEmail,
//                       ),
//                       CustomInputField(
//                         hintText: 'Phone Number',
//                         iconAssetPath: 'assets/images/PhoneNumber.png',
//                         controller: _phoneController,
//                         validator: Validators.validatePhone,
//                       ),
//                       CustomInputField(
//                         hintText: 'City',
//                         iconAssetPath: 'assets/images/City.png',
//                         controller: _cityController,
//                         validator: Validators.validateCity,
//                       ),
//                       CustomInputField(
//                         hintText: 'Password',
//                         iconAssetPath: 'assets/images/Password.png',
//                         controller: _passwordController,
//                         obscureText: true,
//                         validator: Validators.validatePassword,
//                       ),
//                       CustomInputField(
//                         hintText: 'Confirm Password',
//                         iconAssetPath: 'assets/images/Password.png',
//                         controller: _confirmPasswordController,
//                         obscureText: true,
//                         validator: (value) => Validators.validateConfirmPassword(
//                             value, _passwordController.text),
//                       ),
//                       const SizedBox(height: 20),
//                       // Create Button
//                       BlocConsumer<RegisterBloc, RegisterState>(
//                         listener: (context, state) {
//                           if (state is RegisterSuccess) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(content: Text('Registration Successful')),
//                             );

//                             // Navigate to HomeScreen
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => HomeScreen(),
//                               ),
//                             );
//                           } else if (state is RegisterFailure) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(content: Text('Registration Failed: ${state.error}')),
//                             );
//                           }
//                         },
//                         builder: (context, state) {
//                           if (state is RegisterLoading) {
//                             return const CircularProgressIndicator();
//                           }
//                           return ElevatedButton(
//                             onPressed: _register,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.black87, // Button color
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10.0),
//                               ),
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 50, vertical: 15),
//                             ),
//                             child: const Text('Create'),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



















import 'package:alnoor/blocs/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/validators.dart';
import '../../widgets/Input_Field.dart';
import '../Home/home.dart';  // Import the HomeScreen

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<RegisterBloc>(context).add(RegisterButtonPressed(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
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
                        hintText: 'Your Name',
                        iconAssetPath: 'assets/images/user.png',
                        controller: _nameController,
                        validator: Validators.validateName,
                      ),
                      CustomInputField(
                        hintText: 'Your Email Address',
                        iconAssetPath: 'assets/images/email.png',
                        controller: _emailController,
                        validator: Validators.validateEmail,
                      ),
                      CustomInputField(
                        hintText: 'Phone Number',
                        iconAssetPath: 'assets/images/PhoneNumber.png',
                        controller: _phoneController,
                        validator: Validators.validatePhone,
                      ),
                      CustomInputField(
                        hintText: 'City',
                        iconAssetPath: 'assets/images/City.png',
                        controller: _cityController,
                        validator: Validators.validateCity,
                      ),
                      CustomInputField(
                        hintText: 'Password',
                        iconAssetPath: 'assets/images/Password.png',
                        controller: _passwordController,
                        obscureText: true,
                        validator: Validators.validatePassword,
                      ),
                      CustomInputField(
                        hintText: 'Confirm Password',
                        iconAssetPath: 'assets/images/Password.png',
                        controller: _confirmPasswordController,
                        obscureText: true,
                        validator: (value) => Validators.validateConfirmPassword(
                            value, _passwordController.text),
                      ),
                      SizedBox(height: screenSize.height * 0.03), // Responsive spacing
                      // Create Button
                      BlocConsumer<RegisterBloc, RegisterState>(
                        listener: (context, state) {
                          if (state is RegisterSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Registration Successful')),
                            );

                            // Navigate to HomeScreen
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen( isGuestUser: false,),
                              ),
                            );
                          } else if (state is RegisterFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Registration Failed: ${state.error}')),
                            );
                          }
                        },
                        builder: (context, state) {
                          if (state is RegisterLoading) {
                            return const CircularProgressIndicator();
                          }
                          return ElevatedButton(
                            onPressed: _register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black87, // Button color
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
                              'Create',
                              style: TextStyle(
                                fontSize: screenSize.width * 0.05, // Responsive text size
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
