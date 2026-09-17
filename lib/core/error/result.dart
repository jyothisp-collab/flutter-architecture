import 'package:flutter_architecture_showcase/core/error/app_error.dart';

sealed class Result<T> {
  const Result();

  R match<R>({
    required R Function(T data) onSuccess,
    required R Function(AppError error) onFailure,
  });
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);

  @override
  R match<R>({
    required R Function(T data) onSuccess,
    required R Function(AppError error) onFailure,
  }) =>
      onSuccess(data);
}

class Failure<T> extends Result<T> {
  final AppError error;
  const Failure(this.error);

  @override
  R match<R>({
    required R Function(T data) onSuccess,
    required R Function(AppError error) onFailure,
  }) =>
      onFailure(error);
}
