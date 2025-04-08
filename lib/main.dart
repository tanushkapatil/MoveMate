import 'package:flutter/material.dart';
import 'role_selection_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bus Tracking App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF090909),
        cardColor: Color(0xFF1E1E2E),
        primaryColor: Color(0xFF7F56D9),
        colorScheme: ColorScheme.dark().copyWith(
          primary: Color(0xFF7F56D9),
          secondary: Color(0xFF9A6AFF),
        ),
      ),
      home: StartPage(),
    );
  }
}

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * 0.85; // Card width similar to Role Selection Page

    return Scaffold(
      backgroundColor: Color(0xFF090909), // Dark Background
      body: Center(
        child: Card(
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          color: Color(0xFF1E1E2E), // Dark Purple Card
          child: Container(
            width: cardWidth,
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Welcome!',
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12.0),
                Text(
                  'Get started by selecting your role.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SelectRolePage()),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1E1E2E), // Dark Button Background
                    foregroundColor: Color(0xFF7F56D9), // Purple Text
                    side: BorderSide(color: Color(0xFF7F56D9), width: 2), // Purple Border
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 48.0, vertical: 12.0),
                  ),
                  child: Text('Login', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}