import 'dart:convert';

import 'package:http/http.dart';
import 'package:test/test.dart';
import 'package:test_process/test_process.dart';

void main() {
  final port = '8081';
  final host = 'http://0.0.0.0:$port';

  setUp(() async {
    await TestProcess.start(
      'dart',
      ['run', 'bin/server.dart'],
      environment: {'PORT': port},
    );
  });

  test('Run: Get request success', () async {
    final response = await get(
        Uri.parse(host + '/'),
        headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    expect(response.statusCode, 200);
  });

  test('Run: Post request success', () async {

    // Send some test data to the developed service
    Map<String, dynamic> body = {
      'name': 'Peter',
      'age': '42',      
      'height': '180.5',
    };

    final response = await post(
        Uri.parse(host + '/'),
        headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );
    expect(response.statusCode, 200);

    dynamic responseBody = jsonDecode(response.body);

    // Expect a response containing the data given in a POST request, but 
    // reorganized by type and provided in individual Maps in a List
    expect(responseBody, [
        {'string_field': 'Peter'},
        {'int_field': 42},
        {'double_field': 180.5},
    ]);
  });
}
