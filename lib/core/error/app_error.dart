import 'package:equatable/equatable.dart';

/// Base sealed class representing all application-level errors.
@immutable
sealed class AppError implements Exception {
  final String message;
  const AppError(this.message);
}

/// Error representing a network or remote data-fetch failure.
@immutable
class NetworkError extends AppError {
  const NetworkError(super.message);
}

/// Error representing an unknown or unexpected failure.
@immutable
class UnknownError extends AppError {
  const UnknownError(super.message);
}
