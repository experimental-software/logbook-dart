import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logbook_core/logbook_core.dart';
import 'package:uuid/uuid.dart';

/// The [HomepageBloc] contains the code related to the Homepage state.
///
/// ![hompage state](https://experimental-software.github.io/logbook/06_runtime-view/img/pages/homepage/state.png)
class HomepageBloc extends Bloc<HomepageEvent, HomepageState> {
  HomepageBloc() : super(Empty()) {
    on<HomepageEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

// -----------------------------------------------------------------------------

abstract class HomepageState extends Equatable {
  const HomepageState();
}

class SearchingLogs extends HomepageState {
  final String id = const Uuid().v4();

  @override
  List<Object> get props => [id];
}

class ShowingLogs extends HomepageState {
  final String id = const Uuid().v4();
  final List<LogEntry> logs;

  ShowingLogs(this.logs);

  @override
  List<Object> get props => [id];
}

class Empty extends HomepageState {
  final String id = const Uuid().v4();

  @override
  List<Object> get props => [id];
}

// -----------------------------------------------------------------------------

abstract class HomepageEvent extends Equatable {
  const HomepageEvent();
}

class SearchSubmitted extends HomepageEvent {
  final String id = const Uuid().v4();
  final String searchTerm;

  SearchSubmitted(this.searchTerm);

  @override
  List<Object?> get props => [id, searchTerm];
}

class SearchFinished extends HomepageEvent {
  final String id = const Uuid().v4();
  final List<LogEntry> logs;

  SearchFinished(this.logs);

  @override
  List<Object?> get props => [id];
}
