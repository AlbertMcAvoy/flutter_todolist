part of 'todo.dart';

Todo _$TodoFromJson(Map<String, dynamic> json) {
  return Todo(
    id: json['id'] as int,
    name: json['name'] as String,
    description: json['description'] as String,
    isCompleted: json['isCompleted'] as bool
  );
}

Map<String, dynamic> _$TodoToJson(Todo instance) => <String, dynamic> {
    'id': instance.id,
    'name': instance.name,
    'description': instance.description,
    'isCompleted': instance.isCompleted
};