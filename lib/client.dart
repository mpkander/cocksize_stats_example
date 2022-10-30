import 'dart:convert';

import 'package:http/http.dart' as http;

class CockUserDto {
  final String username;
  final int cocksize;

  CockUserDto({required this.username, required this.cocksize});

  factory CockUserDto.fromJson(Map<String, dynamic> json) {
    return CockUserDto(
      username: json['Username'] as String,
      cocksize: json['CockSize'] as int,
    );
  }
}

class RefreshTokenException implements Exception {}

class StatsApi {
  Future<List<CockUserDto>> getStats(String token) async {
    final response = await http.get(
      Uri.parse('http://95.216.195.202:1488/api/stats'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final parsed = jsonDecode(response.body) as Map;

    if (response.statusCode == 401) {
      throw RefreshTokenException();
    }

    print(parsed);
    print(response.statusCode);

    return (parsed['data'] as List).map((e) => CockUserDto.fromJson(e)).toList()
      ..sort(((a, b) => b.cocksize.compareTo(a.cocksize)));
  }
}
