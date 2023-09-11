// ignore_for_file: prefer_function_declarations_over_variables, unused_local_variable

import 'package:dartz/dartz.dart';
import 'package:datasourcetesting/core/injector/modules/sqflite_module.dart';
import 'package:datasourcetesting/core/injector/services.dart';
import 'package:datasourcetesting/src/data/datasource/local/local_post_datasource.dart';
import 'package:datasourcetesting/src/data/models/post_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../core/injector/services.dart';
import '../../core/tools/call_or_return_null.dart';

Future<void> main() async {
  await initTestServices();

  group('LocalPostDatasource', () {
    test('Save & Get test', () async {
      // act
      final SqfliteModule sqfliteModule = services<SqfliteModule>();
      await sqfliteModule.database?.delete('Posts', where: 'id = 1');

      final PostModel postModel = PostModel(
        id: 1,
        ownerId: 1,
        title: 'title',
        data: 'data',
        publishedAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final LocalPostDatasource localPostDatasource = services<LocalPostDatasource>();

      // arrange
      final saveTest = await callOrReturnNull(() async => await localPostDatasource.savePost(postModel));
      // final Future<Unit?> Function() saveTest = () async {
      //   try {
      //     return await ;
      //   } catch (_) {
      //     return null;
      //   }
      // };

      final getTest = await callOrReturnNull(() async => await localPostDatasource.getPostById(postModel.id));
      // final Future<PostModel?> Function() getTest = () async {
      //   try {
      //     return await localPostDatasource.getPostById(postModel.id);
      //   } catch (_) {
      //     return null;
      //   }
      // };

      // assert
      expect(saveTest, unit, reason: 'Save does`t work correct');
      expect(getTest, postModel, reason: 'Get does`t match correct model');
    });
    test('Get All test', () async {
      // act
      final SqfliteModule sqfliteModule = services<SqfliteModule>();
      await sqfliteModule.database?.delete('Posts');

      final List<PostModel> listPostModels = [
        PostModel(
          id: 1,
          ownerId: 1,
          title: 'title1',
          data: 'data1',
          publishedAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        PostModel(
          id: 2,
          ownerId: 2,
          title: 'title2',
          data: 'data2',
          publishedAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        PostModel(
          id: 3,
          ownerId: 3,
          title: 'title3',
          data: 'data3',
          publishedAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      final LocalPostDatasource localPostDatasource = services<LocalPostDatasource>();

      // arrange
      listPostModels.forEach((element) async {
        await localPostDatasource.savePost(element);
      });

      Future<List<PostModel>?> Function() getAllPosts = () async {
        try {
          return await localPostDatasource.getAllPosts();
        } catch (_) {
          return null;
        }
      };

      final getAllPostTest = await getAllPosts();

      // assert
      expect(getAllPostTest, listPostModels, reason: 'Get doesn`t match correct list of post models');
    });

    test('Delete test', () async {
      // act
      final SqfliteModule sqfliteModule = services<SqfliteModule>();
      await sqfliteModule.database?.delete('Posts');

      final PostModel postModel = PostModel(
        id: 1,
        ownerId: 1,
        title: 'title1',
        data: 'data1',
        publishedAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final LocalPostDatasource localPostDatasource = services<LocalPostDatasource>();
      await localPostDatasource.savePost(postModel);

      // arrange

      Future<Unit?> Function() deletePost = () async {
        try {
          return await localPostDatasource.deletePost(id: postModel.id);
        } catch (_) {
          return null;
        }
      };

      final deletePostTest = await deletePost();

      // assert
      expect(deletePostTest, unit, reason: 'Delete doesn`t work correct');
    });
  });
}
