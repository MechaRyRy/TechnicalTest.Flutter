import 'package:equatable/equatable.dart';

sealed class Result<T> extends Equatable {
  final T? value;

  const Result(this.value);

  const factory Result.success(T value) = Success<T>;

  factory Result.failureFromException({required Exception error, T? value}) {
    return Failure.fromException(error: error, value: value);
  }

  factory Result.failureFromError({required Error error, T? value}) {
    return Failure.fromError(error: error, value: value);
  }

  const factory Result.loading({T? value}) = Loading<T>;
}

final class Success<T> extends Result<T> {
  const Success(super.value);

  @override
  T get value => super.value as T;

  @override
  List<Object?> get props => [value];
}

final class Loading<T> extends Result<T> {
  const Loading({T? value}) : super(value);

  @override
  List<Object?> get props => [value];
}

sealed class Failure<T> extends Result<T> {
  const Failure({T? value}) : super(value);

  const factory Failure.fromException({required Exception error, T? value}) =
      ExceptionFailure<T>;

  const factory Failure.fromError({required Error error, T? value}) =
      ErrorFailure<T>;

  Failure<T> copyWithValue(T? newValue);

  Failure<T> copyWith({T? value}) {
    switch (this) {
      case ExceptionFailure<T>():
        return ExceptionFailure<T>(
          error: (this as ExceptionFailure<T>).error,
          value: value ?? this.value,
        );
      case ErrorFailure<T>():
        return ErrorFailure<T>(
          error: (this as ErrorFailure<T>).error,
          value: value ?? this.value,
        );
    }
  }
}

class ExceptionFailure<T> extends Failure<T> {
  final Exception error;

  const ExceptionFailure({required this.error, super.value});

  @override
  ExceptionFailure<T> copyWithValue(T? newValue) =>
      ExceptionFailure(error: error, value: newValue);

  @override
  List<Object?> get props => [error, value];
}

class ErrorFailure<T> extends Failure<T> {
  final Error error;

  const ErrorFailure({required this.error, super.value});

  @override
  ErrorFailure<T> copyWithValue(T? newValue) =>
      ErrorFailure(error: error, value: newValue);

  @override
  List<Object?> get props => [error, value];
}

extension ResultMapping<T> on Result<T> {
  Result<T> map(T Function(T value) transformer) {
    final state = this;
    if (state is Success<T>) {
      return Success(transformer(state.value));
    } else if (state is Loading<T>) {
      return Loading(
        value: state.value != null ? transformer(state.value as T) : null,
      );
    } else if (state is Failure<T>) {
      return state.copyWithValue(
        state.value != null ? transformer(state.value as T) : null,
      );
    }
    return this;
  }
}
