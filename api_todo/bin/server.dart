import 'package:api_todo/server.dart';
import 'package:api_todo/services/services.dart';
import 'package:api_todo/services/in_memory.dart';
import 'package:get_it/get_it.dart';

void main() async {

  GetIt.instance.registerSingleton(InMemory());
  GetIt.instance.registerSingleton<Services>(Services());
  
  await inMemory.initialize();

  final server = Server();
  await server.start(port: 3000);
}
