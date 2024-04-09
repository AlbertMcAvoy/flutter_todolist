part of 'todo.dart';

Todo _$TodoFromJson(Map<String, dynamic> json) {
  return Todo(
    name: json['name'] as String,
    isCompleted: json['isCompleted'] as bool
  );
}

Map<String, dynamic> _$TodoToJson(Todo instance) => <String, dynamic> {
    'name': instance.name,
    'isCompleted': instance.isCompleted
};