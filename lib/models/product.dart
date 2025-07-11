import 'package:flutter_best_practices/mixins/copy_with.dart';

class Product with CopyWith {
  final int? id;
  final String name;
  final String description;
  final double? avgRating;

  Product({
    required this.id,
    required this.name,
    required this.description,
    this.avgRating,
  });

  Product.fromMap(Map map)
    : id = map['id'],
      name = map['name'],
      description = map['description'],
      avgRating = map['avg_rating'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'avg_rating': avgRating,
    };
  }

  @override
  Product copyWith({
    AssignableValue<int?> id = const MissingValue(),
    String? name,
    String? description,
    AssignableValue<double?> avgRating = const MissingValue(),
  }) {
    return Product(
      id: id is NullableValue<int?> ? id.value : this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      avgRating: avgRating is NullableValue<double?>
          ? avgRating.value
          : this.avgRating,
    );
  }
}
