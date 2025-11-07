/// V2Board API 异常
class V2BoardException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;
  
  V2BoardException({
    required this.message,
    this.statusCode,
    this.data,
  });
  
  @override
  String toString() {
    if (statusCode != null) {
      return 'V2BoardException([$statusCode] $message)';
    }
    return 'V2BoardException($message)';
  }
}

