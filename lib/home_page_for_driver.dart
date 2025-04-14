import 'package:flutter/material.dart';
import 'login_page.dart'; // Import the LoginPage
import 'dummy_data.dart'; // Import your dummy data file
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

class HomePageForDriver extends StatefulWidget {
  @override
  _HomePageForDriverState createState() => _HomePageForDriverState();
}

class _HomePageForDriverState extends State<HomePageForDriver> {
  final TextEditingController _busCodeController = TextEditingController();
  bool _isBusCodeError = false;

  // Extract valid bus codes from dummy data
  late final List<String> _dummyBusCodes = busRoutes
      .map((bus) => bus['busCode'].toString())
      .toList();

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * 0.85;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Animated tech background
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
                color: Color(0xFF1E1E2E), // Dark Purple
                child: Container(
                  width: cardWidth,
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Enter Bus Code',
                        style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      TextField(
                        controller: _busCodeController,
                        decoration: InputDecoration(
                          hintText: 'Enter Bus Code',
                          hintStyle: TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Color(0xFF2A2A3E),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: Icon(
                            Icons.directions_bus,
                            color: Colors.white,
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                      if (_isBusCodeError)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Text(
                            'Invalid bus code. Please try again.',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () async {
                          String enteredCode = _busCodeController.text.trim();
                          if (_dummyBusCodes.contains(enteredCode)) {
                            setState(() {
                              _isBusCodeError = false;
                            });

                            // Store bus code in SharedPreferences
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.setString('bus_code', enteredCode);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    LoginPage(busCode: enteredCode),
                              ),
                            );
                          } else {
                            setState(() {
                              _isBusCodeError = true;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF7F56D9),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 48.0, vertical: 12.0),
                        ),
                        child: Text('Go to Login'),
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
