import 'package:flutter_bloc/flutter_bloc.dart';

class SafeEmissionCubit<T> extends Cubit<T> {
  SafeEmissionCubit(super.initialState);

  @override
  void emit(T state) {
    throw UnimplementedError('Use maybeEmit to emit new states conditionally.');
  }

  void maybeEmit(T state) {
    if (isClosed) return;
    super.emit(state);
  }
}
