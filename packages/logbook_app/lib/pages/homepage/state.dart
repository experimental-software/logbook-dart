import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:logbook_core/logbook_core.dart';
import 'package:uuid/uuid.dart';

class HomepageBloc extends Bloc<HomepageEvent, HomepageState> {
  final SearchService _searchService = GetIt.I.get();

  HomepageBloc() : super(Empty()) {
    on<SearchSubmitted>((event, emit) {
      if (event.searchTerm.isEmpty) {
        if (event.negateSearch) {
          add(SearchSubmitted('.*', useRegexSearch: true));
        } else {
          emit(Empty());
        }
        return;
      }

      emit(SearchingLogs());
      _searchService
          .search(
        System.baseDir,
        event.searchTerm,
        isRegularExpression: event.useRegexSearch,
        negateSearch: event.negateSearch,
      )
          .then((logs) {
        add(SearchFinished(logs));
      });
      // TODO Handle timeout
    });

    on<SearchFinished>((event, emit) {
      final logs = event.logs;
      if (logs.isEmpty) {
        emit(NoSearchResults());
      } else {
        emit(ShowingLogs(logs));
      }
    });

    //init();
  }

  void init() {
    add(SearchSubmitted(''));
  }
}

// -----------------------------------------------------------------------------

abstract class HomepageState extends Equatable {
  const HomepageState();
}

class Empty extends HomepageState {
  final String id = const Uuid().v4();

  @override
  List<Object> get props => [id];
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

class NoSearchResults extends HomepageState {
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
  final bool useRegexSearch;
  final bool negateSearch;

  SearchSubmitted(
    this.searchTerm, {
    this.useRegexSearch = false,
    this.negateSearch = false,
  });

  @override
  List<Object?> get props => [id];
}

class SearchFinished extends HomepageEvent {
  final String id = const Uuid().v4();
  final List<LogEntry> logs;

  SearchFinished(this.logs);

  @override
  List<Object?> get props => [id];
}
