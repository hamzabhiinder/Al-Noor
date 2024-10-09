// screens/register_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/register_bloc.dart';
import '../../repositories/register_repository.dart';
import '../../utils/validators.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for input fields
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late RegisterBloc _registerBloc;

  @override
  void initState() {
    super.initState();
    _registerBloc = RegisterBloc(registerRepository: RegisterRepository());
    print('Initialized RegisterBloc');
  }

  // Dispose controllers when the widget is disposed
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _registerBloc.close();
    print('Disposed RegisterBloc');
    super.dispose();
  }

  // Method to handle registration
  void _register() {
    if (_formKey.currentState!.validate()) {
      print('Form is valid, dispatching RegisterButtonPressed');
      // Dispatch the RegisterButtonPressed event with the input data
      _registerBloc.add(RegisterButtonPressed(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        city: _cityController.text.trim(),
        password: _passwordController.text,
        confirm_password: _confirmPasswordController.text,
      ));
    } else {
      print('Form is invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive design
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: BlocProvider(
        create: (context) => _registerBloc,
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                'assets/images/BGg.png',
                fit: BoxFit.cover,
              ),
            ),
            // Black overlay with opacity
            Container(
              color: Colors.black.withOpacity(0.5),
            ),
            // Main content
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width * 0.13,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // App Logo
                        Image.asset(
                          'assets/images/Logo.png',
                          height: screenSize.height * 0.2,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: screenSize.height * 0.01),
                        // Name Input Field
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: 'Your Name',
                            prefixIcon: Icon(Icons.person, color: Colors.white),
                            hintStyle: TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.transparent,
                            border: UnderlineInputBorder(),
                          ),
                          style: TextStyle(color: Colors.white),
                          validator: Validators.validateName,
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        // Email Input Field
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'Your Email Address',
                            prefixIcon: Icon(Icons.email, color: Colors.white),
                            hintStyle: TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.transparent,
                            border: UnderlineInputBorder(),
                          ),
                          style: TextStyle(color: Colors.white),
                          validator: Validators.validateEmail,
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        // Phone Input Field
                        TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            hintText: 'Phone Number',
                            prefixIcon: Icon(Icons.phone, color: Colors.white),
                            hintStyle: TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.transparent,
                            border: UnderlineInputBorder(),
                          ),
                          style: TextStyle(color: Colors.white),
                          validator: Validators.validatePhone,
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        // City Input Field
                        TextFormField(
                          controller: _cityController,
                          decoration: InputDecoration(
                            hintText: 'City',
                            prefixIcon:
                                Icon(Icons.location_city, color: Colors.white),
                            hintStyle: TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.transparent,
                            border: UnderlineInputBorder(),
                          ),
                          style: TextStyle(color: Colors.white),
                          validator: Validators.validateCity,
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        // Password Input Field
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            prefixIcon: Icon(Icons.lock, color: Colors.white),
                            hintStyle: TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.transparent,
                            border: UnderlineInputBorder(),
                          ),
                          style: TextStyle(color: Colors.white),
                          obscureText: true,
                          validator: Validators.validatePassword,
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        // Confirm Password Input Field
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            hintText: 'Confirm Password',
                            prefixIcon: Icon(Icons.lock, color: Colors.white),
                            hintStyle: TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.transparent,
                            border: UnderlineInputBorder(),
                          ),
                          style: TextStyle(color: Colors.white),
                          obscureText: true,
                          validator: (value) => Validators.validateConfirmPassword(
                              value, _passwordController.text),
                        ),
                        SizedBox(height: screenSize.height * 0.05),
                        // Register Button with BlocConsumer
                        BlocConsumer<RegisterBloc, RegisterState>(
                          bloc: _registerBloc,
                          listener: (context, state) {
                            print('Current state: $state');
                            if (state is RegisterSuccess) {
                              print('Registration successful');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Registration Successful')),
                              );
                              // Navigate to LoginScreen
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                              );
                            } else if (state is RegisterFailure) {
                              print('Registration failed: ${state.error}');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Registration Failed: ${state.error}')),
                              );
                            } else if (state is RegisterPending) {
                              print('Registration pending: ${state.message}');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.message)),
                              );
                              // Optionally navigate or stay on the same screen
                            }
                          },
                          builder: (context, state) {
                            if (state is RegisterLoading) {
                              print('Registration loading...');
                              return const CircularProgressIndicator();
                            }
                            return ElevatedButton(
                              onPressed: _register,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff464444),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      screenSize.width * 0.01),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenSize.width * 0.2,
                                  vertical: screenSize.height * 0.01,
                                ),
                              ),
                              child: Text(
                                'Create',
                                style: TextStyle(
                                  fontSize: screenSize.width * 0.05,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        // Navigate to Login Screen
                        TextButton(
                          onPressed: () {
                            print('Navigating to LoginScreen');
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                            );
                          },
                          child: Text(
                            'Already have an account? Log in',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenSize.width * 0.04,
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
