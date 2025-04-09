import 'package:flutter/material.dart';

class PassengerPortal extends StatelessWidget {
  const PassengerPortal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Passenger Portal'),
        backgroundColor: const Color(0xFF7F56D9),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(
                hintText: 'Enter Current Location',
                prefixIcon: Icon(Icons.my_location),
              ),
            ),
            const SizedBox(height: 10.0),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Enter Destination Location',
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Dummy data functionality for finding nearest bus stop
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Nearest Bus Stop: ABC Plaza'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7F56D9),
                foregroundColor: Colors.white,
              ),
              child: const Text('Find Bus Stops'),
            ),
          ],
        ),
      ),
    );
  }
}
