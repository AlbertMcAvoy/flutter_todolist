
import 'package:json_annotation/json_annotation.dart';

part 'todo.g.dart';

@JsonSerializable(explicitToJson: true)
class Todo {
  String name;
  bool isCompleted;

  Todo (
    {
      this.name = '',
      this.isCompleted = false
    }
  );


  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  Map<String, dynamic> toJson() => _$TodoToJson(this);

  Todo fromJson(Map<String, dynamic> json) => Todo.fromJson(json);
}