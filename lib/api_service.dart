import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://your-backend-url.com/api'; // Replace with your actual backend URL

  static Future<void> updateBusLocation({
    required String busCode,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/bus/location'),
        body: {
          'busCode': busCode,
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update location');
      }
    } catch (e) {
      print('Error updating location: $e');
    }
  }
}