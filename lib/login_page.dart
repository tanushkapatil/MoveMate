import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'driver_dashboard.dart';

class LoginPage extends StatefulWidget {
  final String busCode;

  LoginPage({required this.busCode});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _driverIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isDriverIdError = false;
  bool _isPasswordError = false;
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  void _validateAndLogin() async {
    setState(() {
      _isDriverIdError = _driverIdController.text.isEmpty;
      _isPasswordError = _passwordController.text.isEmpty;
    });

    if (_isDriverIdError || _isPasswordError) return;

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('https://movemate-server-pearl.vercel.app/auth/login'), // Change if not using emulator
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': _driverIdController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final token = jsonResponse['token'];
        final userId = jsonResponse['user_id'];

        // Store token locally
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('user_id', userId);

        print('Login success, token stored');

        // Navigate to dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DriverDashboard(busCode: widget.busCode),
          ),
        );
      } else {
        final msg = json.decode(response.body)['detail'] ?? 'Invalid credentials';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.red),
        );
        setState(() => _isPasswordError = true);
      }
    } catch (e) {
      print('Login error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to connect to the server.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          AnimatedContainer(
            duration: Duration(seconds: 5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[900]!, Colors.indigo[900]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                color: Color(0xFF1E1E2E),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Driver Login',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'Bus Code: ${widget.busCode.toUpperCase()}',
                        style: TextStyle(fontSize: 20.0, color: Colors.white70),
                      ),
                      SizedBox(height: 20.0),
                      TextField(
                        controller: _driverIdController,
                        decoration: InputDecoration(
                          hintText: 'Driver ID',
                          filled: true,
                          fillColor: Color(0xFF2A2A3E),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: Icon(Icons.person, color: Colors.white),
                        ),
                        style: TextStyle(color: Colors.white),
                        onChanged: (_) => setState(() {
                          if (_driverIdController.text.isNotEmpty) {
                            _isDriverIdError = false;
                          }
                        }),
                      ),
                      if (_isDriverIdError)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Text(
                            'Please enter your Driver ID.',
                            style: TextStyle(color: Colors.red, fontSize: 16.0),
                          ),
                        ),
                      SizedBox(height: 16.0),
                      TextField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          filled: true,
                          fillColor: Color(0xFF2A2A3E),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: Icon(Icons.lock, color: Colors.white),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                        onChanged: (_) => setState(() {
                          if (_passwordController.text.isNotEmpty) {
                            _isPasswordError = false;
                          }
                        }),
                      ),
                      if (_isPasswordError)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Text(
                            'Please enter your password.',
                            style: TextStyle(color: Colors.red, fontSize: 16.0),
                          ),
                        ),
                      SizedBox(height: 20.0),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _validateAndLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF7F56D9),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: _isLoading
                              ? CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.white),
                                )
                              : Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
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
    );
  }
}
