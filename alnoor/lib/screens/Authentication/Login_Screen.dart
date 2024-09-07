import 'package:alnoor/classes/image_manager.dart';
import 'package:alnoor/screens/Home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../blocs/login_bloc.dart';
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

  void _onLoginButtonPressed() async {
    setState(() {
      print("one");
      ImageManager().setImage(1, null);
      ImageManager().setImage(2, null);
      ImageManager().setImage(3, null);
      ImageManager().setImage(4, null);
      ImageManager().setImage(5, null);
      ImageManager().setImage(6, null);
    });

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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Logging in...')),
            );
          } else if (state is LoginSuccess) {
            _setUserLoggedIn();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Login Failed: ${state.error}')),
            );
          }
        },
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.1,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/Logo.png',
                              height: screenSize.height * 0.1,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(height: screenSize.height * 0.03),
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
                            SizedBox(height: screenSize.height * 0.03),
                            ElevatedButton(
                              onPressed: _onLoginButtonPressed,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black87,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      screenSize.width * 0.03),
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
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Separate padding for TextButton
                    SizedBox(height: screenSize.height * 0.02),
                    Padding(
                      padding: EdgeInsets.only(top: screenSize.height * 0.01),
                      child: Align(
                        alignment: Alignment.center, // Centers the TextButton horizontally
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterScreen()),
                            );
                          },
                          child: Text(
                            "Don't have an account? Register here",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: screenSize.width * 0.045,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _setUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isGuestUser', false);
  }
}
