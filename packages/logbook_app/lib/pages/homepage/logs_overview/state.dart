import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class LogsOverviewBloc extends Bloc<HomepageEvent, ShowingLogsOverviewState> {
  LogsOverviewBloc() : super(HomepageInitial()) {
    on<HomepageEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

abstract class ShowingLogsOverviewState extends Equatable {
  const ShowingLogsOverviewState();
}

class HomepageInitial extends ShowingLogsOverviewState {
  final String id = const Uuid().v4();

  @override
  List<Object> get props => [id];
}

abstract class HomepageEvent extends Equatable {
  const HomepageEvent();
}
