import 'package:dia/dia.dart';
import 'package:dia_rest_example/models/api_response.dart';
import 'package:dia_rest_example/models/server_context.dart';
import 'package:dia_rest_example/models/task.dart';
import 'package:dia_rest_example/services/database_provider.dart';
import 'package:dia_rest_example/services/task_repository.dart';
import 'package:dia_router/dia_router.dart';

class TaskRouter {
  final dbProvider = DatabaseProvider.instance;
  final router = Router<ServerContext>('/task');
  Middleware<ServerContext> get middleware => router.middleware;

  TaskRouter() {
    router.get('/', (ctx, next) async {
      final data = await TaskRepositiry.my(ctx.currentUser!.id);
      ctx.body = ApiResponse(true, data: data).toBody();
    });

    // Create new Task
    router.post('/', (ctx, next) async {
      if (!ctx.parsed.containsKey('task')) {
        ctx.throwError(404);
        return;
      }
      var task = Task.fromJson(ctx.parsed['task']);
      await TaskRepositiry.create(task);
      ctx.body = ApiResponse(true).toBody();
    });

    // Update old Task
    router.put('/', (ctx, next) async {
      if (!ctx.parsed.containsKey('task')) {
        ctx.throwError(404);
        return;
      }
      var task = Task.fromJson(ctx.parsed['task']);
      await TaskRepositiry.update(task);
      ctx.body = ApiResponse(true).toBody();
    });

    router.del('/:id', (ctx, next) async {
      var id = int.tryParse(ctx.params['id']!);
      if (id == null) {
        ctx.throwError(404);
        return;
      }
      await TaskRepositiry.delete(id);
      ctx.body = ApiResponse(true).toBody();
    });
  }
}
