import 'package:flutter_tech_task/objectbox.g.dart';
// ignore: unnecessary_import
import 'package:objectbox/objectbox.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ObjectBoxPersistence {
  late final Store store;

  ObjectBoxPersistence._create(this.store);

  static Future<ObjectBoxPersistence> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(
      directory: p.join(docsDir.path, "object-box-store"),
    );
    return ObjectBoxPersistence._create(store);
  }

  Box<PersistentPostSummary> persistentSummariesBox() =>
      store.box<PersistentPostSummary>();

  void close() => store.close();
}

@Entity()
class PersistentPostSummary {
  int id;
  @Index()
  int postId;
  String title;
  String body;

  PersistentPostSummary({
    this.id = 0,
    required this.postId,
    required this.title,
    required this.body,
  });
}
