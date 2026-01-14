import 'package:flutter_tech_task/data/injection.dart';
import 'package:flutter_tech_task/presentation/injection.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupInjection() async {
  await createPresentationDependencies(getIt);
  await createDataDependencies(getIt);
}
