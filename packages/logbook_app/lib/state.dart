import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class LogbookBloc extends Bloc<LogbookEvent, LogbookState> {
  LogbookBloc() : super(LogbookState()) {
    on<LogbookEvent>((event, emit) {
      emit(LogbookState());
    });
  }
}

// -----------------------------------------------------------------------------

class LogbookState extends Equatable {
  final String id = const Uuid().v4();

  @override
  List<Object> get props => [id];
}

// -----------------------------------------------------------------------------

abstract class LogbookEvent extends Equatable {
  const LogbookEvent();
}

class LogUpdated extends LogbookEvent {
  final String id = const Uuid().v4();

  @override
  List<Object> get props => [id];
}

class LogAdded extends LogbookEvent {
  final String id = const Uuid().v4();

  @override
  List<Object> get props => [id];
}
