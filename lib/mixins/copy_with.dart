/// Team usage of CopyWith with AssignableValue:
/// 
/// ```dart
/// class Team with CopyWith<Team> {
///   final String name; // Non-nullable field
///   final int? score; // Nullable field
/// 
///   const Team({
///     required this.name,
///     this.score,
///   });
/// 
///   @override
///   Team copyWith({
///     String? name, // Regular parameter for non-nullable field
///     AssignableValue<int?> score = const MissingValue(), // AssignableValue for nullable field
///   }) {
///     return Team(
///       name: name ?? this.name,
///       score: score is NullableValue<int?> ? score.value : this.score,
///     );
///   }
/// }
/// 
/// // Usage examples:
/// final team = Team(name: 'Original', score: 100);
/// 
/// // Update non-null field normally:
/// final updated1 = team.copyWith(name: 'New Name');
/// // Result: name = 'New Name', score = 100
/// 
/// // Update nullable field with non-null value:
/// final updated2 = team.copyWith(score: const NullableValue(200));
/// // Result: name = 'Original', score = 200
/// 
/// // Set nullable field to null:
/// final updated3 = team.copyWith(score: const NullableValue(null));
/// // Result: name = 'Original', score = null
/// 
/// // Keep original values:
/// final updated4 = team.copy();
/// // Result: name = 'Original', score = 100
/// 
/// // Update both fields:
/// final updated5 = team.copyWith(
///   name: 'Updated Name',
///   score: const NullableValue(300),
/// );
/// // Result: name = 'Updated Name', score = 300
/// ```
mixin class CopyWith<T> {
  /// Returns a new instance with copied values overridden by the fields provided.
  /// The nullable fields require a wrapper NullableField(value) to set a null value.
  T copyWith() {
    throw UnimplementedError();
  }

  T copy() {
    return copyWith();
  }
}

sealed class AssignableValue<T> {
  const AssignableValue();
}

class NullableValue<T> extends AssignableValue<T> {
  T? value;
  NullableValue(this.value);
}

class MissingValue<T> extends AssignableValue<T> {
  const MissingValue();
}
