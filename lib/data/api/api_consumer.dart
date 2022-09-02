// ignore_for_file: missing_return

abstract class ApiConsumer {
  Future<dynamic> get(String path,
      {Map<String, dynamic> queryParams, Map<String, dynamic> headers}) {}

  Future<dynamic> post(String path,
      {Map<String, dynamic> queryParams,
      Map<String, dynamic> body,
      Map<String, dynamic> headers}) {}

  Future<dynamic> put(String path,
      {Map<String, dynamic> queryParams,
      Map<String, dynamic> body,
      Map<String, dynamic> headers}) {}

  Future<dynamic> delete(String path,
      {Map<String, dynamic> queryParams, Map<String, dynamic> headers}) {}
}
