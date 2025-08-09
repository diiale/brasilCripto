class AppFailure implements Exception {
  final String message;
  final int? statusCode;
  const AppFailure(this.message, {this.statusCode});

  @override
  String toString() => 'AppFailure($message, statusCode: $statusCode)';
}