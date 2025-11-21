import 'dart:convert';
import 'package:http/http.dart' as http;

class CityService {
  Future<String> getCityName(double lat, double lon) async {
    try {
      final url = Uri.parse(
        "https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon&accept-language=en"
      );

      final response = await http.get(url, headers: {
        "User-Agent": "FlutterWeatherApp" // Nominatim requires a User-Agent
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final address = data['address'];
        final city = address['city'] ??
            address['town'] ??
            address["state"] ??
            address['village'] ??
            address['municipality'] ??
            "Unknown city";
        final country = address['country'] ?? "Unknown country";
        return "$city, $country";
      }
    } catch (e) {
      // silently fail
    }
    return "Unknown Location";
  }
}
