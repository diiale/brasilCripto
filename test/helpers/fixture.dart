import 'dart:io';

String fixture(String name) {
  final path = 'test/fixtures/$name';
  return File(path).readAsStringSync();
}
