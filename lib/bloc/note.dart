import 'package:meta/meta.dart';

@immutable
class Note {
  final String text;
  final bool isStared;

  const Note(
    this.text, {
    this.isStared = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Note &&
          other.text == text &&
          other.isStared == isStared);

  @override
  int get hashCode => Object.hash(text, isStared);
}