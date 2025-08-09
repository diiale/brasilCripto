import '../core/errors/app_failure.dart';

sealed class Result<T> {
  const Result();
  R when<R>({required R Function(T) ok, required R Function(AppFailure) err}) {
    final self = this;
    if (self is Ok<T>) return ok(self.value);
    return err((self as Err<T>).failure);
  }
}

class Ok<T> extends Result<T> {
  final T value;
  const Ok(this.value);
}

class Err<T> extends Result<T> {
  final AppFailure failure;
  const Err(this.failure);
}