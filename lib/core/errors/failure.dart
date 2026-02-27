import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class ApiFailure extends Failure {
  final String code;
  const ApiFailure(super.message, this.code);

  @override
  List<Object> get props => [message, code];
}
