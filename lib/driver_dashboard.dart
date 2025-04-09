import 'package:flutter/material.dart';
import 'dummy_data.dart';

class DriverDashboard extends StatefulWidget {
  final String busCode;

  const DriverDashboard({Key? key, required this.busCode}) : super(key: key);

  @override
  State<DriverDashboard> createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
  List<bool> seatStatus = List.generate(40, (index) => false);
  bool isSharingLocation = false;
  int availableSeats = 40;

  @override
  Widget build(BuildContext context) {
    final bus = busRoutes.firstWhere((bus) => bus['busCode'] == widget.busCode);
    List<String> route = List<String>.from(bus['route']);

    return Scaffold(
      backgroundColor: Color(0xFF1E1E2E),
      appBar: AppBar(
        title: Text('${widget.busCode} - Driver Dashboard'),
        backgroundColor: Color(0xFF7F56D9),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRouteCard(route),
              SizedBox(height: 24),
              _buildControlButtons(),
              SizedBox(height: 24),
              Text(
                'Seat Availability ($availableSeats available)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 12),
              _buildSeatLayout(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRouteCard(List<String> route) {
    return Card(
      color: Color(0xFF2A2A3D),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Route Details',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 16),
            Column(
              children: List.generate(route.length, (index) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Icon(Icons.circle, size: 12, color: Colors.white),
                        if (index != route.length - 1)
                          Container(
                            height: 30,
                            width: 2,
                            color: Colors.white54,
                          ),
                      ],
                    ),
                    SizedBox(width: 10),
                    Text(
                      route[index],
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          icon: Icon(isSharingLocation ? Icons.location_off : Icons.location_on),
          label: Text(isSharingLocation ? 'Stop Sharing' : 'Share Location'),
          style: ElevatedButton.styleFrom(
            backgroundColor: isSharingLocation ? Colors.red : Color(0xFF7F56D9),
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            setState(() {
              isSharingLocation = !isSharingLocation;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(isSharingLocation 
                  ? 'Location sharing started' 
                  : 'Location sharing stopped'),
              ),
            );
          },
        ),
        ElevatedButton.icon(
          icon: Icon(Icons.report),
          label: Text('Report Issue'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Issue reported to admin')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSeatLayout() {
    return Column(
      children: [
        Text(
          'Tap on seats to mark them as occupied',
          style: TextStyle(color: Colors.white70),
        ),
        SizedBox(height: 16),
        // Driver's seat at the top
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Driver',
            style: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(height: 20),
        // Seats layout
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Left side seats (columns 1 and 2)
            Column(
              children: List.generate(10, (row) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      // Column 1 seat
                      _buildSeat(row),
                      SizedBox(width: 16),
                      // Column 2 seat
                      _buildSeat(row + 10),
                    ],
                  ),
                );
              }),
            ),
            // Gap between left and right sides (aisle)
            SizedBox(width: 40),
            // Right side seats (columns 3 and 4)
            Column(
              children: List.generate(10, (row) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      // Column 3 seat
                      _buildSeat(row + 20),
                      SizedBox(width: 16),
                      // Column 4 seat
                      _buildSeat(row + 30),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSeat(int seatNumber) {
    return GestureDetector(
      onTap: () {
        setState(() {
          seatStatus[seatNumber] = !seatStatus[seatNumber];
          availableSeats = seatStatus.where((status) => !status).length;
        });
      },
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: seatStatus[seatNumber] ? Colors.red : Colors.green,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.white54, width: 1),
        ),
        child: Center(
          child: Text(
            '${seatNumber + 1}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}