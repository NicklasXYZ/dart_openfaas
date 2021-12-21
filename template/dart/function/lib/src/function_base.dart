import 'dart:async' show Future;
import 'dart:convert';

import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';


getPipeline() {
  // Note: Database connections and whatnot should be initialized here and
  // passed to whatever service that needs it

  // Create a service to handle incoming requests
  final service = Service();

  // Configure a pipeline that logs incoming requests
  final pipeline =
      Pipeline().addMiddleware(logRequests()).addHandler(service.handler);
    return pipeline;
}

class Service {
  Handler get handler {
    // Create a 'Router' object for handling URL routing
    final router = Router();

    // NOTE: THE FUNCTIONS CALLED BELOW THIS POINT ARE FOR ILLUSTRATIONAL AND 
    // TESTING PURPOSES ONLY. YOU SHOULD ADD/IMPLEMENT YOUR OWN FUNCTION LOGIC 
    // AND CALL THE FUNCTIONS HERE BELOW!

    // Handle a GET request sent by a client
    router.get('/', (Request request) async {
      return Response.ok('Hello from Dart & Openfaas!');
    });

    // Handle a POST request sent by a client
    router.post('/', (Request request) async {

      // Decode the received JSON data 
      dynamic data = jsonDecode(await request.readAsString());

      // For illustrational purposes simply reorganize the received data     
      List<Map<String, dynamic>> returnData = [
        {'string_field': data['name'] ?? ""},
        {'int_field': int.tryParse(data['age'] ?? "-1")},
        {'double_field': double.tryParse(data['height'] ?? "-1.0")}
      ];

      // Encode the reorganized JSON data and return it
      var jsonText = jsonEncode(returnData);
      return Response.ok(jsonText);
    });

   return router;
  }
}