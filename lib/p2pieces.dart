import 'package:hive/hive.dart';
part 'p2pieces.g.dart';

@HiveType(typeId: 0)
class p2{
  @HiveField(0)
  late String idname;
  @HiveField(1)
  late String location;
  @HiveField(2)
  late String firstMove;

  p2(this.idname, this.location, this.firstMove);
}