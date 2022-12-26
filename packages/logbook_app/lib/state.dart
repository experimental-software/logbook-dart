import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class LogbookBloc extends Bloc<LogbookEvent, LogbookState> {
  LogbookBloc() : super(LogbookInitial()) {
    on<LogbookEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

abstract class LogbookState extends Equatable {
  const LogbookState();
}

class LogbookInitial extends LogbookState {
  final String id = const Uuid().v4();

  @override
  List<Object> get props => [id];
}

abstract class LogbookEvent extends Equatable {
  const LogbookEvent();
}
