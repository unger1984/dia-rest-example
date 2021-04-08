import 'dart:io';

import 'package:dia/dia.dart';
import 'package:dia_body/dia_body.dart';
import 'package:dia_rest_example/models/api_response.dart';

import 'models/server_context.dart';
import 'routers/ApiRouter.dart';
import 'services/config_provider.dart';

void serverInstance(List args) {
  final app = App((req) => ServerContext(req));

  app.use((ctx, next) async {
    var start = DateTime.now();
    await next();
    final time = DateTime.now().difference(start).inMilliseconds;
    print(
        '[${args[0]}] ${ctx.request.method} ${ctx.request.uri.path} ${time}ms');
  });

  app.use((ctx, next) async {
    await next();
    if (ctx.statusCode != 200 && ctx.error != null) {
      ctx.statusCode = 200;
      ctx.contentType = ContentType.json;
      ctx.body = ApiResponse(false, data: {
        'code': ctx.error!.status,
        'message': ctx.error!.message,
        'exception': ctx.error!.exception,
        'stackTrace': ctx.error!.stackTrace
      }).toBody();
    }
  });

  app.use(body());
  app.use(ApiRouter().middleware);

  app
      .listen(ConfigProvider.instance.host, ConfigProvider.instance.port,
          shared: true)
      .then((_) {
    print('Serving ${args[0]} at '
        'http://${ConfigProvider.instance.host}:${ConfigProvider.instance.port}');
  });
}
