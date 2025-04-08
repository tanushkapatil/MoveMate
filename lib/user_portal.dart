import 'package:flutter/material.dart';
import 'maps_page.dart';
import 'seat_availability_page.dart';
import 'breakdown_status_page.dart';
import 'eta_page.dart';
import 'stop_map_page.dart';

class UserPortal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ListTile(
            title: Text('Live Map Tracking'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MapsPage()),
            ),
          ),
          ListTile(
            title: Text('Seat Availability'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SeatAvailabilityPage()),
            ),
          ),
          ListTile(
            title: Text('Breakdown Status'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BreakdownStatusPage()),
            ),
          ),
          ListTile(
            title: Text('Check ETA'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ETAPage()),
            ),
          ),
          ListTile(
            title: Text('Stop Map'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StopMapPage()),
            ),
          ),
        ],
      ),
    );
  }
}