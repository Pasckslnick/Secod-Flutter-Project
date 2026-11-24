import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'note.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  NoteBloc() : super(const NoteInitial()) {
    on<AddNote>(_onAddNote);
    on<DeleteNote>(_onDeleteNote);
    on<SelectNote>(_onSelectNote);
    on<SaveNote>(_onSaveNote);
    on<SearchNotes>(_onSearchNotes);
    on<StareNote>((event, emit) {
      _stareNote(event.index, emit);
    });
  }

  NotesLoaded get _loaded => state is NotesLoaded
      ? state as NotesLoaded
      : const NotesLoaded(allNotes: [], visibleNotes: []);

  void _onAddNote(AddNote event, Emitter<NoteState> emit) {
    final s = _loaded;
    emit(s.copyWith(isNewNote: true, clearSelection: true, selectedText: ''));
  }

  void _onDeleteNote(DeleteNote event, Emitter<NoteState> emit) {
    final s = _loaded;
    if (event.index < 0 || event.index >= s.allNotes.length) return;
    final updated = [...s.allNotes]..removeAt(event.index);
    emit(NotesLoaded(allNotes: updated, visibleNotes: updated));
  }

  void _onSelectNote(SelectNote event, Emitter<NoteState> emit) {
    final s = _loaded;
    if (event.index < 0 || event.index >= s.allNotes.length) return;
    final note = s.allNotes[event.index];
    emit(
      s.copyWith(
        selectedIndex: event.index,
        isNewNote: false,
        selectedText: note.text == 'Пустая заметка' ? '' : note.text,
      ),
    );
  }

void _onSaveNote(SaveNote event, Emitter<NoteState> emit) {
  final s = _loaded;

  var text = event.text;
  if (text.isEmpty) text = 'Пустая заметка';

  final updated = [...s.allNotes];

  if (s.isNewNote) {
    updated.add(Note(text));
  } else if (s.selectedIndex != null &&
      s.selectedIndex! >= 0 &&
      s.selectedIndex! < updated.length) {
    final oldNote = updated[s.selectedIndex!];

    updated[s.selectedIndex!] = Note(
      text,
      isStared: oldNote.isStared,
    );
  } else {
    return;
  }

  emit(NotesLoaded(
    allNotes: updated,
    visibleNotes: updated,
  ));
}

  void _stareNote(int index, Emitter<NoteState> emit) {
    final s = _loaded;

    if (index < 0 || index >= s.allNotes.length) return;

    final note = s.allNotes[index];

    final updated = [...s.allNotes];

    updated[index] = Note(note.text, isStared: !note.isStared);

    emit(s.copyWith(allNotes: updated, visibleNotes: updated));
  }

  void _onSearchNotes(SearchNotes event, Emitter<NoteState> emit) {
    final s = _loaded;
    if (event.query.isEmpty) {
      emit(s.copyWith(visibleNotes: s.allNotes));
      return;
    }
    final q = event.query.toLowerCase();
    final filtered = s.allNotes
        .where((n) => n.text.toLowerCase().contains(q))
        .toList();
    emit(s.copyWith(visibleNotes: filtered));
  }
}
