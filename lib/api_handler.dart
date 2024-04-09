import 'dart:convert';

import 'package:postgres_crud/Models/model.dart';
import 'package:http/http.dart' as http;

class ApiHandler {
  // Your API URL here
  final String baseUrl = "http://192.168.1.228:8082/api/patients";

  // Get data from API
  Future<List<Patient>> getPatients() async {
    List<Patient> data = [];

    final uri = Uri.parse(baseUrl);
    try {
      final response = await http.get(uri, headers: <String, String>{
        "Content-type": "application/json; charset=UTF-8"
      });
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final List<dynamic> jsonData = json.decode(response.body);
        data = jsonData.map((json) => Patient.fromJson(json)).toList();

        print("Data get from API: $data");
      }
    } catch (e) {
      print("Error call API: $e");
    }
    return data;
  }

  // Add data to API
  Future<void> addPatient(Patient patient) async {
    final uri = Uri.parse('$baseUrl');
    // print(uri);
    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(patient.toJson()),
      );
      if (response.statusCode == 200) {
        // Patient added successfully
        print('Patient added successfully');
      } else {
        // Failed to add patient
        throw Exception('Failed to add patient: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to add patient: $e');
    }
  }

  // Delete data from API
  Future<void> deletePatient(String id) async {
    try {
      final Uri uri = Uri.parse('$baseUrl/$id');
      final response = await http.delete(uri);
      if (response.statusCode == 200) {
        // Patient deleted successfully
        print('Patient deleted successfully');
      } else {
        // Failed to delete patient
        throw Exception('Failed to delete patient: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to delete patient: $e');
    }
  }

  // Update data in API
  Future<void> updatePatient(Patient patient) async {
    final uri = Uri.parse('$baseUrl');
    try {
      final response = await http.put(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(patient.toJson()),
      );
      if (response.statusCode == 200) {
        // Patient updated successfully
        print('Patient updated successfully');
      } else {
        // Failed to update patient
        throw Exception('Failed to update patient: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to update patient: $e');
    }
  }
}
