import 'package:untitled/helper/helpers.dart';

class Category{
  int? id, count;
  String? name;

  Category.fromJson(json){
    name = json['name'];
    id = Helpers.toInt(json['id']);
    count = Helpers.toInt(json['count']);
  }

  Category.createDefault() {
    name = 'Escolha uma categoria';
    id = 0;
    count = 0;
  }

}