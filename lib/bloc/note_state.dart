part of 'note_bloc.dart';

@immutable
sealed class NoteState {
  const NoteState();
}

final class NoteInitial extends NoteState {
  const NoteInitial();
}

final class NotesLoaded extends NoteState {
  final List<Note> allNotes;
  final List<Note> visibleNotes;
  final int? selectedIndex;
  final bool isNewNote;
  final String selectedText;

  const NotesLoaded({
    required this.allNotes,
    required this.visibleNotes,
    this.selectedIndex,
    this.isNewNote = false,
    this.selectedText = '',
  });

  NotesLoaded copyWith({
    List<Note>? allNotes,
    List<Note>? visibleNotes,
    int? selectedIndex,
    bool? isNewNote,
    String? selectedText,
    bool clearSelection = false,
  }) {
    return NotesLoaded(
      allNotes: allNotes ?? this.allNotes,
      visibleNotes: visibleNotes ?? this.visibleNotes,
      selectedIndex:
          clearSelection ? null : (selectedIndex ?? this.selectedIndex),
      isNewNote: isNewNote ?? this.isNewNote,
      selectedText: selectedText ?? this.selectedText,
    );
  }
}