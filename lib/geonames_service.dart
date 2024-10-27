import 'dart:convert';
import 'package:http/http.dart' as http;

class GeoNamesService {
  final String username = 'sj2kg1'; // Ваш логин GeoNames

  // Получение списка стран
  Future<List<dynamic>> fetchCountries() async {
    final url = Uri.parse(
        'https://api.geonames.org/countryInfoJSON?username=$username'); // Используем username
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['geonames'];
    } else {
      throw Exception('Failed to load countries');
    }
  }

  // Получение списка регионов
  Future<List<dynamic>> fetchRegions(String countryCode) async {
    final url = Uri.parse(
        'https://api.geonames.org/childrenJSON?geonameId=$countryCode&username=$username'); // Используем username
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['geonames'];
    } else {
      throw Exception('Failed to load regions');
    }
  }

  // Получение списка городов
  Future<List<dynamic>> fetchCities(int regionId) async {
    final url = Uri.parse(
        'https://api.geonames.org/searchJSON?adminCode1=$regionId&username=$username&featureClass=P'); // Используем username
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['geonames'];
    } else {
      throw Exception('Failed to load cities');
    }
  }
}
