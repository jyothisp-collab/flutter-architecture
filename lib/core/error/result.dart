import 'app_error.dart';

/// A discriminated union (sealed class) representing the outcome of an operation.
///
/// - [Success] carries the successful [data].
/// - [Failure] carries an [AppError] describing what went wrong.
///
/// Consumers must handle both cases via [map] to get exhaustive
/// pattern-matching at compile time.
@immutable
sealed class Result<T> {
  const Result();

  R map<R>({
    required R Function(T data) onSuccess,
    required R Function(AppError error) onFailure,
  });
}

@immutable
class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);

  @override
  R map<R>({
    required R Function(T data) onSuccess,
    required R Function(AppError error) onFailure,
  }) =>
      onSuccess(data);
}

@immutable
class Failure<T> extends Result<T> {
  final AppError error;
  const Failure(this.error);

  @override
  R map<R>({
    required R Function(T data) onSuccess,
    required R Function(AppError error) onFailure,
  }) =>
      onFailure(error);
}
