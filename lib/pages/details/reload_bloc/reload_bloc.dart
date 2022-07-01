import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

part 'reload_event.dart';
part 'reload_state.dart';

class ReloadBloc extends Bloc<ReloadEvent, ReloadState> {
  ReloadBloc() : super(Loading()) {
    on<ReloadEvent>((event, emit) {
      emit(Loading());
    });
  }
}
