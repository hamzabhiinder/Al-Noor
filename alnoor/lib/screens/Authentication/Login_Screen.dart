import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../repositories/login_repository.dart';
import '../../utils/validators.dart';
import '../Home/home.dart';
import 'register_screen.dart';

import '../../blocs/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc(loginRepository: LoginRepository());
    print('Initialized LoginBloc');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _loginBloc.close();
    print('Disposed LoginBloc');
    super.dispose();
  }

  void _onLoginButtonPressed() {
    if (_formKey.currentState!.validate()) {
      print('Form is valid, dispatching LoginButtonPressed');
      _loginBloc.add(
        LoginButtonPressed(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    } else {
      print('Form is invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: BlocProvider(
        create: (context) => _loginBloc,
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess || state is LoginOfflineSuccess) {
              print('Login successful, navigating to HomeScreen');
              _setUserLoggedIn();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            } else if (state is LoginFailure) {
              print('Login failed: ${state.error}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Login Failed: ${state.error}')),
              );
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                // Background Image
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/BGg.png',
                    fit: BoxFit.cover,
                  ),
                ),
                // Black overlay
                Container(
                  color: Colors.black.withOpacity(0.5),
                ),
                // Content
                Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.1,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Logo
                            Image.asset(
                              'assets/images/Logo.png',
                              height: screenSize.height * 0.2,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(height: screenSize.height * 0.03),
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
                            SizedBox(height: screenSize.height * 0.03),
                            // Login Button
                            state is LoginLoading
                                ? CircularProgressIndicator()
                                : ElevatedButton(
                                    onPressed: _onLoginButtonPressed,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xff464444),
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
                                      'Login',
                                      style: TextStyle(
                                        fontSize: screenSize.width * 0.05,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                            SizedBox(height: screenSize.height * 0.02),
                            // Navigate to Register Screen
                            TextButton(
                              onPressed: () {
                                print('Navigating to RegisterScreen');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterScreen()),
                                );
                              },
                              child: Text(
                                "Don't have an account? Register here",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenSize.width * 0.045,
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
            );
          },
        ),
      ),
    );
  }

  Future<void> _setUserLoggedIn() async {
    print('Setting user as logged in');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isGuestUser', false);
  }
}
