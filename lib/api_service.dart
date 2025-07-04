import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/';

  // Fetch employee list
  static Future<List<dynamic>> fetchEmployees() async {
    final response = await http.get(Uri.parse('${baseUrl}employees'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load employees');
    }
  }

  // Submit inquiry to inquiry_table
  static Future<void> submitInquiry({required String inquiryType}) async {
  final url = Uri.parse('${baseUrl}inquiries');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'inquiry_type': inquiryType}),
    );

    if (response.statusCode == 200) {
      print('Inquiry recorded!');
    } else {
      print('Failed to record inquiry: ${response.body}');
      throw Exception('Failed to record inquiry');
    }
  } catch (e) {
    print('Error submitting inquiry: $e');
    rethrow;
  }
}

  // Submit appointment to appointment_table
  static Future<void> submitAppointment({required int employeeId}) async {
    final url = Uri.parse('${baseUrl}appointments');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'employee_id': employeeId}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Appointment recorded!');
      } else {
        throw Exception('Failed to record appointment: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
