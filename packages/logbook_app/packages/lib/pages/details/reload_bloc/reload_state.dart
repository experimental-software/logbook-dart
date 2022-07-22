part of 'reload_bloc.dart';

abstract class ReloadState extends Equatable {
  const ReloadState();
}

class Loading extends ReloadState {
  final String id = const Uuid().v4();

  @override
  List<Object> get props => [id];
}
