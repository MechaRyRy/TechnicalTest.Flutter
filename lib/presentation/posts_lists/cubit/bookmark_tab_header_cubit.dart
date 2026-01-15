import 'dart:async';

import 'package:flutter_tech_task/domain/usecases/number_of_offline_posts_use_case.dart';
import 'package:flutter_tech_task/utils/safe_emission_cubit.dart';

class BookmarkTabHeaderCubit extends SafeEmissionCubit<int> {
  final NumberOfOfflinePostsUseCase _numberOfOfflinePostsUseCase;
  StreamSubscription<int?>? _subscription;

  BookmarkTabHeaderCubit({
    required NumberOfOfflinePostsUseCase numberOfOfflinePostsUseCase,
  }) : _numberOfOfflinePostsUseCase = numberOfOfflinePostsUseCase,
       super(0) {
    _subscription ??= _numberOfOfflinePostsUseCase.watch().listen((count) {
      maybeEmit(count);
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _subscription = null;
    return super.close();
  }
}
