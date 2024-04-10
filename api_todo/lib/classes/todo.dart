
import 'package:json_annotation/json_annotation.dart';

part 'todo.g.dart';

@JsonSerializable(explicitToJson: true)
class Todo {
  int id;
  String name;
  String description;
  bool isCompleted;

  Todo (
    {
      this.id = 0,
      this.name = '',
      this.description = '',
      this.isCompleted = false
    }
  );


  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  Map<String, dynamic> toJson() => _$TodoToJson(this);

  Todo fromJson(Map<String, dynamic> json) => Todo.fromJson(json);
}