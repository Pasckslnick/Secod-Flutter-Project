import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/note_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NoteBloc(),
      child: MaterialApp(
        title: 'Заметки',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        ),
        home: const MyHomePage(title: 'ICloud Заметки'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _textController = TextEditingController();
  final _textControllerSearch = TextEditingController();

  bool isDarkMode = false;
  bool isSearching = false;
  bool isEditing = false;

  Color textColors = Colors.white;
  Color backgroundColors = Colors.black;
  Color noteColors = Colors.grey;

  @override
  void dispose() {
    _textController.dispose();
    _textControllerSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isDarkMode) {
      textColors = Colors.grey[300]!;
      backgroundColors = const Color(0xFF505052);
      noteColors = Colors.grey[800]!;
    } else {
      textColors = Colors.black;
      backgroundColors = const Color(0xFFF7F7FA);
      noteColors = Colors.grey[200]!;
    }

    return BlocBuilder<NoteBloc, NoteState>(
      builder: (context, state) {
        final s = state is NotesLoaded
            ? state
            : const NotesLoaded(allNotes: [], visibleNotes: []);

        final selectedIndex = s.selectedIndex;
        final hasSelectedNote = selectedIndex != null &&
            selectedIndex >= 0 &&
            selectedIndex < s.allNotes.length;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: backgroundColors,
            title: Row(
              children: [
                Icon(Icons.apple, size: 25, color: textColors),
                Text(
                  'ICloud',
                  style: TextStyle(
                    color: textColors,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SF Pro',
                  ),
                ),
                const SizedBox(width: 3),
                const Text(
                  'Заметки',
                  style: TextStyle(
                    color: Colors.yellow,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SF Pro',
                  ),
                ),
              ],
            ),
            actions: [
              if (isSearching)
                Expanded(
                  child: TextField(
                    controller: _textControllerSearch,
                    autofocus: true,
                    onChanged: (value) {
                      context.read<NoteBloc>().add(SearchNotes(value));
                    },
                    decoration: InputDecoration(
                      hintText: 'Поиск заметок...',
                      hintStyle: TextStyle(color: textColors),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: textColors),
                  ),
                ),
              if (isSearching)
                IconButton(
                  icon: Icon(Icons.close, color: textColors),
                  onPressed: () {
                    setState(() {
                      isSearching = false;
                      _textControllerSearch.clear();
                    });
                    context.read<NoteBloc>().add(const SearchNotes(''));
                  },
                ),
              if (!isSearching)
                IconButton(
                  icon: Icon(Icons.search, color: textColors),
                  onPressed: () {
                    setState(() {
                      isSearching = true;
                    });
                  },
                ),
              if (!isSearching)
                IconButton(
                  icon: Icon(
                    isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    color: textColors,
                  ),
                  onPressed: () {
                    setState(() {
                      isDarkMode = !isDarkMode;
                    });
                  },
                ),
            ],
          ),
          body: Row(
            children: [
              // Список заметок
              Container(
                width: 150,
                height: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: backgroundColors,
                  border: Border.all(color: noteColors),
                ),
                child: s.visibleNotes.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isDarkMode)
                              Image.asset(
                                'assets/image3.png',
                                width: 85,
                                height: 85,
                              )
                            else
                              Image.asset(
                                'assets/image.png',
                                width: 85,
                                height: 85,
                              ),
                            const SizedBox(height: 10),
                            Text(
                              'Нет заметок',
                              style: TextStyle(
                                color: textColors,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: s.visibleNotes.length,
                        itemBuilder: (context, index) {
                          final note = s.visibleNotes[index];
                          final realIndex = s.allNotes.indexOf(note);

                          return Dismissible(
                            key: ValueKey('${note.text}-$index'),

                            direction: note.isStared
                                ? DismissDirection.horizontal
                                : DismissDirection.endToStart,

                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.startToEnd) {
                                if (realIndex != -1) {
                                  context
                                      .read<NoteBloc>()
                                      .add(StareNote(realIndex));
                                }
                                return false;
                              }

                              return true;
                            },
                            onDismissed: (_) {
                              if (realIndex != -1) {
                                context
                                    .read<NoteBloc>()
                                    .add(DeleteNote(realIndex));
                              }
                            },
                            background: Container(
                              alignment: Alignment.centerLeft,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.star_border,
                                color: Colors.white,
                              ),
                            ),
                            secondaryBackground: Container(
                              alignment: Alignment.centerRight,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            child: Container(
                              margin: const EdgeInsets.only(top: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: noteColors,
                                border: Border.all(color: noteColors),
                              ),
                              child: GestureDetector(
                                onDoubleTap: () {
                                  if (realIndex != -1) {
                                    context
                                        .read<NoteBloc>()
                                        .add(StareNote(realIndex));
                                  }
                                },
                                child: ListTile(
                                  title: Text(
                                    note.text,
                                    style: TextStyle(
                                      color: textColors,
                                      fontWeight: note.isStared
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: note.isStared
                                      ? const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        )
                                      : null,
                                  onTap: () {
                                    if (realIndex == -1) return;

                                    setState(() {
                                      isEditing = false;
                                    });

                                    context
                                        .read<NoteBloc>()
                                        .add(SelectNote(realIndex));

                                    _textController.text =
                                        note.text == 'Пустая заметка'
                                            ? ''
                                            : note.text;
                                  },
                                  onLongPress: () {
                                    if (realIndex == -1) return;

                                    setState(() {
                                      isEditing = true;
                                    });

                                    context
                                        .read<NoteBloc>()
                                        .add(SelectNote(realIndex));

                                    _textController.text =
                                        note.text == 'Пустая заметка'
                                            ? ''
                                            : note.text;
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),

              Expanded(
                child: Container(
                  height: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: backgroundColors,
                    border: Border.all(color: noteColors),
                  ),
                  child: s.isNewNote || isEditing
                      ? TextField(
                          maxLines: null,
                          expands: true,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: const InputDecoration(
                            hintText: 'Введите текст заметки...',
                            border: InputBorder.none,
                          ),
                          style: TextStyle(color: textColors),
                          controller: _textController,
                        )
                      : hasSelectedNote
                          ? SingleChildScrollView(
                              child: Text(
                                s.allNotes[selectedIndex].text,
                                style: TextStyle(
                                  color: textColors,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (isDarkMode)
                                    Image.asset(
                                      'assets/image4.png',
                                      width: 200,
                                      height: 200,
                                    )
                                  else
                                    Image.asset(
                                      'assets/image2.png',
                                      width: 200,
                                      height: 200,
                                    ),
                                  Text(
                                    'Выберите заметку или создайте новую',
                                    style: TextStyle(
                                      color: textColors,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                ),
              ),
            ],
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (hasSelectedNote && !s.isNewNote)
                FloatingActionButton(
                  heroTag: 'delete',
                  onPressed: () {
                    context
                        .read<NoteBloc>()
                        .add(DeleteNote(selectedIndex));

                    _textController.clear();
                    setState(() {
                      isEditing = false;
                    });
                  },
                  backgroundColor: Colors.yellow,
                  tooltip: 'Удалить заметку',
                  child: const Icon(Icons.delete),
                ),

              if (hasSelectedNote && !s.isNewNote)
                const SizedBox(width: 10),

              if (isEditing || s.isNewNote)
                FloatingActionButton(
                  heroTag: 'save',
                  onPressed: () {
                    context
                        .read<NoteBloc>()
                        .add(SaveNote(_textController.text));

                    _textController.clear();
                    setState(() {
                      isEditing = false;
                    });
                  },
                  backgroundColor: Colors.yellow,
                  tooltip: 'Сохранить',
                  child: const Icon(Icons.save),
                ),

              if (!hasSelectedNote && !s.isNewNote)
                FloatingActionButton(
                  heroTag: 'add',
                  onPressed: () {
                    _textController.clear();
                    setState(() {
                      isEditing = true;
                    });
                    context.read<NoteBloc>().add(const AddNote());
                  },
                  backgroundColor: Colors.yellow,
                  tooltip: 'Добавить заметку',
                  child: const Icon(Icons.edit),
                ),
            ],
          ),
        );
      },
    );
  }
}