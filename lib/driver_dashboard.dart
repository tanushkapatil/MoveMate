import 'package:flutter/material.dart';
import 'dummy_data.dart';

class DriverDashboard extends StatelessWidget {
  final String busCode;

  const DriverDashboard({Key? key, required this.busCode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final busData = busRoutes.firstWhere((bus) => bus['busCode'] == busCode);

    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Dashboard - $busCode'),
        backgroundColor: Color(0xFF7F56D9), // Purple highlight
      ),
      backgroundColor: Color(0xFF1E1E2E), // Dark theme consistency
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Route Details:',
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              busData['route'].join(' ➔ '),
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            SizedBox(height: 20),

            Text(
              'Seats Available: ${busData['seatsAvailable']}',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            SizedBox(height: 20),

            ElevatedButton.icon(
              icon: Icon(Icons.location_on),
              label: Text('Start Location Sharing'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7F56D9), 
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                // Implement GPS location sharing logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Location Sharing Started!')),
                );
              },
            ),

            SizedBox(height: 10),

            ElevatedButton.icon(
              icon: Icon(Icons.event_seat),
              label: Text('Update Seat Count'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7F56D9),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                // Seat update logic
              },
            ),

            SizedBox(height: 10),

            ElevatedButton.icon(
              icon: Icon(Icons.error),
              label: Text('Report Breakdown'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                // Breakdown status update logic
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Breakdown Reported!')),
                );
              },
            ),

            Spacer(),

            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                ),
                child: Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}