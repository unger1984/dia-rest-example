import 'dart:isolate';

import 'package:args/args.dart';
import 'package:dia_rest_example/server_instance.dart';
import 'package:dia_rest_example/services/database_provider.dart';

void main(List<String> args) async {
  final argParser = ArgParser()
    ..addOption('cluster', abbr: 'c', defaultsTo: '1')
    ..addFlag('help', abbr: 'h');
  final arguments = argParser.parse(args);

  if (arguments['help']) {
    print('Usage:\r\n'
        '-c, --cluster - thread count (default: 1)\r\n'
        '-h, --help - print this help');
    return;
  }

  final conn = await DatabaseProvider.instance.conn;
  await DatabaseProvider.migrationUp(conn);

  // Start [cluster] count instance of server
  final cluster = int.tryParse(arguments['cluster']) ?? 1;
  var isolates = <Future>[];
  for (var i = 0; i < cluster; i++) {
    isolates.add(Isolate.spawn(serverInstance, [i]));
  }
  await Future.wait(isolates);
}
