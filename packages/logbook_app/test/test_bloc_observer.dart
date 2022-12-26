import 'package:flutter_bloc/flutter_bloc.dart';

class TestBlocObserver extends BlocObserver {
  List<Change> changes = [];

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    changes.add(change);
  }
}
