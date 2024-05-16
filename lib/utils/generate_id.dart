import 'package:uuid/uuid.dart';

String generateId() {
  const uuid = Uuid();
  final randomNumbers = uuid.v4().replaceAll('-', '').substring(0, 8);
  print(randomNumbers);
  return randomNumbers;
}
