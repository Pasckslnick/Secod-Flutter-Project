part of 'note_bloc.dart';

@immutable
sealed class NoteEvent {
  const NoteEvent();
}

class AddNote extends NoteEvent {
  const AddNote();
}

class DeleteNote extends NoteEvent {
  final int index;
  const DeleteNote(this.index);
}

class SelectNote extends NoteEvent {
  final int index;
  const SelectNote(this.index);
}

class SaveNote extends NoteEvent {
  final String text;
  const SaveNote(this.text);
}

class SearchNotes extends NoteEvent {
  final String query;
  const SearchNotes(this.query);
}

class StareNote extends NoteEvent {
  final int index;
  const StareNote(this.index);
}