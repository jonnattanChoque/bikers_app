class InvalidCredentialsException implements Exception {
  final String message;
  InvalidCredentialsException([this.message = 'Credenciales inválidas']);

  @override
  String toString() => message;
}
