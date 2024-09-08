import 'package:alnoor/blocs/register_bloc.dart';
import 'package:alnoor/classes/image_manager.dart';
import 'package:alnoor/screens/Authentication/Login_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/validators.dart';
import '../../widgets/Input_Field.dart';

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

  void _register() async {
    setState(() {
      ImageManager().setImage(1, null);
      ImageManager().setImage(2, null);
      ImageManager().setImage(3, null);
      ImageManager().setImage(4, null);
      ImageManager().setImage(5, null);
      ImageManager().setImage(6, null);
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isGuestUser', false);
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<RegisterBloc>(context).add(RegisterButtonPressed(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        city: _cityController.text,
        password: _passwordController.text,
        confirm_password: _confirmPasswordController.text,
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
          Positioned.fill(
            child: Image.asset(
              'assets/images/registerBG.png',
              fit: BoxFit.cover,
            ),
          ),
          // Content
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.13, // Adjusted padding
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Logo

                      SvgPicture.asset(
                        'assets/images/Logo_Black.svg',
                        height: screenSize.height * 0.2, // Adjusted logo height
                        fit: BoxFit.contain,
                      ),
                      SizedBox(
                          height:
                              screenSize.height * 0.01), // Spacing below logo
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
                        validator: (value) =>
                            Validators.validateConfirmPassword(
                                value, _passwordController.text),
                      ),
                      SizedBox(
                          height: screenSize.height *
                              0.05), // Spacing before button
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
                                builder: (context) => LoginScreen(),
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
                              backgroundColor: Color(0xff464444), // Button color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    screenSize.width *
                                        0.01), // Button border radius
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    screenSize.width * 0.2, // Button padding
                                vertical: screenSize.height * 0.01,
                              ),
                            ),
                            child: Text(
                              'Create',
                              style: TextStyle(
                                fontSize: screenSize.width * 0.05,
                                color: Colors.white, // Button text color
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
