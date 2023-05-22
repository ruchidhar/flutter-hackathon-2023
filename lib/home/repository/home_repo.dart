import 'dart:convert';

import '../../shared/models/quote_model.dart';
import 'package:http/http.dart' as http;

abstract class HomeRepository {
  Future<QuoteResponse?> getQuote();
}

class HomeRepositoryImpl implements HomeRepository {
  @override
  Future<QuoteResponse?> getQuote() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.quotable.io/random?tags=happiness'),
      );
      if (response.statusCode == 200) {
        return QuoteResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load quote');
      }
    } catch (err) {
      return null;
    }
  }
}
