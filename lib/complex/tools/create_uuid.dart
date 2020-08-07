import 'package:uuid/uuid.dart';

String newUUID(){
  var uuid = new Uuid();
  return uuid.v4();
}