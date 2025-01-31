import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data_layer/models/Form_Model.dart'; // Ensure this path points to the correct model file

class ModifierGroupProvider {
  static const String baseUrl = "https://megameal.twilightparadox.com/pos/setting/modifier_group/";

  // Create Modifier Group (POST) with PLU validation
  Future<String> createModifierGroup(Map<String, dynamic> data) async {
    // Check if PLU is unique before calling the API
    if (!await _isPLUUnique(data['PLU'])) {
      return "PLU must be unique!";
    }

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 201) {
      return "201: Created";
    } else if (response.statusCode == 400) {
      return "400: Bad Request";
    } else if (response.statusCode == 404) {
      return "404: Wrong URL";
    } else if (response.statusCode == 500) {
      return "500: Internal Server Error";
    } else {
      return "Error: ${response.statusCode}";
    }
  }

  // Check if the PLU is unique (GET)
  Future<bool> _isPLUUnique(String plu) async {
    final response = await http.get(Uri.parse('$baseUrl?vendorId=1&page=1&page_size=10'));

    if (response.statusCode == 200) {
      final model = Model.fromJson(json.decode(response.body));
      // Check if the PLU already exists in the results
      return !model.results.any((result) => result.plu == plu);
    } else {
      return false;
    }
  }

  // Fetch Modifier Groups (GET)
  Future<Model> fetchModifierGroups(int vendorId, int page, int pageSize) async {
    final response = await http.get(Uri.parse('$baseUrl?vendorId=$vendorId&page=$page&page_size=$pageSize'));

    if (response.statusCode == 200) {
      return Model.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load modifier groups');
    }
  }

  // UPDATE Modifier Group (PATCH)
  Future<String> updateModifierGroup(int id, int vendorId, Map<String, dynamic> data) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl$id/?vendorId=$vendorId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        return "Success: Modifier group updated.";
      } else {
        return "Error ${response.statusCode}: ${response.reasonPhrase}";
      }
    } catch (error) {
      return "Error: $error";
    }
  }

  // DELETE Modifier Group (DELETE)
  Future<String> deleteModifierGroup(int id, int vendorId) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl$id/?vendorId=$vendorId'));

      if (response.statusCode == 200) {
        return "Success: Modifier group deleted.";
      } else {
        return "Error ${response.statusCode}: ${response.reasonPhrase}";
      }
    } catch (error) {
      return "Error: $error";
    }
  }
}
