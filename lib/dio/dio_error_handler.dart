import 'package:dio/dio.dart';

String dioErrorHandler(Response response) {
  final statusCode = response.statusCode;
  final statusMsg = response.statusMessage;

  final String errorMsg =
      'Request failed\nStatus Code: $statusCode\nStatus Message: $statusMsg';

  return errorMsg;
}
