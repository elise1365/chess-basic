import 'package:hive/hive.dart';
part 'p1pieces.g.dart';

@HiveType(typeId: 1)
class p1{

  @HiveField(0)
  late String idname;
  @HiveField(1)
  late String location;
  @HiveField(2)
  late String firstMove;

  p1(this.idname, this.location, this.firstMove);
}