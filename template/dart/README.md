# Running the code locally

The app is built using [Shelf](https://pub.dev/packages/shelf). The app handles HTTP GET and POST requests to `/`.

You can test the code locally with the [Dart SDK](https://dart.dev/get-dart) like this:

```bash
dart test

# ... or run the webserver locally with
dart run bin/server.dart
```

Then from a second terminal run:

```bash
### Example GET request
curl -k \
    http://localhost:8000/ \
    echo

# If nothing was changed in the 'test-function/function' directory before
# deployment then we should just see the default response:
>> Hello from Dart & Openfaas!

### Example POST request:
    curl -k \
    -d "{\"name\": \"Peter\", \"age\": \"42\", \"height\": \"180.5\"}" \
    -H "Content-Type: application/json" \
    -X POST http://localhost:8000/ \
    echo

# If nothing was changed in the 'test-function/function' directory before
# deployment then we should just see the default response:
>> [{"string_field":"Peter"}, {"int_field":42}, {"double_field":180.5}]
```