import 'package:dio/dio.dart';

Response buildResponse(dynamic data, {int status = 200, String path = '/'}) {
  return Response(
    data: data,
    statusCode: status,
    requestOptions: RequestOptions(path: path),
  );
}
