part of 'default_request_bloc.dart';

abstract class DefaultRequestEvent {}

class DefaultRequestSendEvent extends DefaultRequestEvent {
  final Future<Object?> requestMethod;
  DefaultRequestSendEvent({
    required this.requestMethod,
  });
}

