part of 'reload_bloc.dart';

abstract class ReloadState extends Equatable {
  const ReloadState();
}

class Loading extends ReloadState {
  final String id = const Uuid().v4();

  final Directory? noteDirectory;

  Loading([this.noteDirectory]);

  @override
  List<Object> get props => [id];
}
