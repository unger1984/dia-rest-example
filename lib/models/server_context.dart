import 'dart:io';

import 'package:dia/dia.dart';
import 'package:dia_body/dia_body.dart';
import 'package:dia_rest_example/models/user.dart';
import 'package:dia_router/dia_router.dart';

class ServerContext extends Context with Routing, ParsedBody {
  User? currentUser;
  ServerContext(HttpRequest request) : super(request);
}
