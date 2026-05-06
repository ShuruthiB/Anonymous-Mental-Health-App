import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  Future<String> fetchMotivationalQuote() async {
    try {
      final response =
          await http.get(Uri.parse("https://zenquotes.io/api/random"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data[0]['q'];
      } else {
        throw Exception("Failed to fetch quote");
      }
    } catch (e) {
      return "Stay strong. This moment will pass 💙";
    }
  }
}