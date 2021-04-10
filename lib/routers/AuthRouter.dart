import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dia/dia.dart';
import 'package:dia_rest_example/models/api_response.dart';
import 'package:dia_rest_example/models/server_context.dart';
import 'package:dia_rest_example/services/user_repository.dart';
import 'package:dia_router/dia_router.dart';

class AuthRouter {
  final router = Router<ServerContext>('/auth');
  Middleware<ServerContext> get middleware => router.middleware;

  AuthRouter() {
    router.post('/', (ctx, next) async {
      if (!ctx.parsed.containsKey('login') ||
          !ctx.parsed.containsKey('password')) {
        ctx.throwError(400);
        return;
      }
      var user = await UserRepositiry.login(
          ctx.parsed['login'], ctx.parsed['password']);
      if (user == null) {
        ctx.throwError(401, message: 'Wrong login:password');
        return;
      }
      var token = JWT(user).sign(SecretKey('secret'));
      print(token);
      ctx.body = ApiResponse(true, data: token).toBody();
    });
  }
}
