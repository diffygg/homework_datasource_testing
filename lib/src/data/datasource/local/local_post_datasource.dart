import 'package:dartz/dartz.dart';
import 'package:datasourcetesting/core/injector/modules/sqflite_module.dart';
import 'package:datasourcetesting/src/data/errors/local_database_errors.dart';
import 'package:datasourcetesting/src/data/models/post_model.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class LocalPostDatasource {
  final SqfliteModule sqfliteModule;

  static const String postsTable = 'Posts';

  LocalPostDatasource({
    required this.sqfliteModule,
  });

  Future<Unit> savePost(PostModel postModel) async {
    final int? id = await sqfliteModule.database?.insert(postsTable, {
      'id': postModel.id,
      'title': postModel.title,
      'data': postModel.data,
      'ownerId': postModel.ownerId,
      'publishedAt': postModel.publishedAt.toIso8601String(),
      'updatedAt': postModel.updatedAt.toIso8601String(),
    });

    if (id == null) {
      throw BadInsertError();
    }

    return unit;
  }

  Future<PostModel> getPostById(int id) async {
    final List<Map<String, Object?>>? findResult = await sqfliteModule.database?.query(postsTable, where: 'id = $id');

    if (findResult == null && findResult?.length != 1) {
      throw NoDataError();
    }

    final Map<String, Object?> data = findResult!.first;

    return PostModel(
      id: data['id'] as int,
      ownerId: data['ownerId'] as int,
      title: data['title'] as String,
      data: data['data'] as String,
      publishedAt: DateTime.parse(data['publishedAt'] as String),
      updatedAt: DateTime.parse(data['updatedAt'] as String),
    );
  }

  Future<List<PostModel>> getAllPosts() async {
    final List<Map<String, Object?>>? data = await sqfliteModule.database?.query(postsTable);

    if (data == null && data?.length == 0) {
      throw NoDataError();
    }

    final List<PostModel> result = [];

    data!.forEach((element) {
      result.add(PostModel.fromMap(element));
    });

    return result;
  }

  Future<Unit> deletePost({required int id}) async {
    final int? result = await sqfliteModule.database?.delete(postsTable, where: 'id == $id');

    if (result == null) {
      throw NoDataError();
    }

    return unit;
  }
}
