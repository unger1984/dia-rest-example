import 'dart:io';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dia/dia.dart';
import 'package:dia_rest_example/models/server_context.dart';
import 'package:dia_rest_example/routers/TaskRouter.dart';
import 'package:dia_rest_example/services/database_provider.dart';
import 'package:dia_rest_example/services/user_repository.dart';
import 'package:dia_router/dia_router.dart';

import 'AuthRouter.dart';

class ApiRouter {
  final dbProvider = DatabaseProvider.instance;
  final router = Router<ServerContext>('/api');
  Middleware<ServerContext> get middleware => router.middleware;

  ApiRouter() {
    router.use((ctx, next) async {
      ctx.contentType = ContentType.json;
      await next();
    });

    // Add Auth router
    router.use(AuthRouter().middleware);

    // Check auth state
    router.use((ctx, next) async {
      var auth = ctx.request.headers.value('Authorization');
      if (auth != null &&
          RegExp(r'^bearer\s([A-z\.0-9]+)', caseSensitive: false)
              .hasMatch(auth)) {
        var token = auth
            .replaceFirst(RegExp(r'^bearer\s', caseSensitive: false), '')
            .trim();
        try {
          final jwt = JWT.verify(token, SecretKey('secret'));
          final user = await UserRepositiry.byId(jwt.payload['id']);
          if (user != null) {
            ctx.currentUser = user;
          } else {
            ctx.throwError(401);
          }
        } catch (_) {
          ctx.throwError(401);
        }
      } else {
        ctx.throwError(401);
      }
      await next();
    });

    // Add Task router
    router.use(TaskRouter().middleware);
  }
}
