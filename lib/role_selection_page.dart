import 'package:flutter/material.dart';
import 'home_page_for_driver.dart'; // Driver page
import 'user_portal.dart'; // User Portal page

class SelectRolePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Removes the top bar
      backgroundColor: Colors.transparent, // Transparent background
      body: Stack(
        children: [
          // Animated tech background (same as login page)
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
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Select Your Role',
                        style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomePageForDriver()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF7F56D9), // Purple
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 48.0, vertical: 12.0),
                        ),
                        child: Text('I am a Bus Driver'),
                      ),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UserPortal()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF9A6AFF), // Light Purple
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 48.0, vertical: 12.0),
                        ),
                        child: Text('I am a User'),
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