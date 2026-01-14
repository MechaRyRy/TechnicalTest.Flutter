import 'package:flutter/services.dart';
import 'package:http/http.dart';

extension ResponseExtensions on String {
  Future<Response> toResponse() async =>
      Response(await rootBundle.loadString('assets/$this'), 200);
}
