import "package:postgres/postgres.dart";

void main() async {
  final conn = await Connection.open(Endpoint(
    host: 'localhost',
    database: 'postgres',
    username: 'user',
    password: 'pass',
  ));
}
