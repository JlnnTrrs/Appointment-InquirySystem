import 'dart:convert';
import 'package:http/http.dart' as http;


class ApiService {
  static final String baseUrl = 'http://10.60.22.134:8000/api/';

  static Future<List<dynamic>> fetchEmployees() async {
    final response = await http.get(Uri.parse('${baseUrl}employees'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load employees');
    }
  }

  static Future<void> submitInquiry({required String inquiryType}) async {
    final url = Uri.parse('${baseUrl}inquiries');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'inquiry_type': inquiryType}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to record inquiry: ${response.body}');
    }
  }

  static Future<void> submitAppointment({required int employeeId}) async {
    final url = Uri.parse('${baseUrl}appointments');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'employee_id': employeeId}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to record appointment: ${response.body}');
    }
  }
}
