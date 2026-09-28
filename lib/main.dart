import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Заметки',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: const MyHomePage(title: 'Icloud Заметки'),
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
  var notes = <String>[];
  var allNotes = <String>[];

  var _selectedNoteIndex;
  final _textController = TextEditingController();
  final _textControllerSearch = TextEditingController();
  
  bool isDarkMode = false;
  bool isSearching = false;
  bool newNote = false;

  var textColors = Colors.white;
  var backgroundColors = Colors.black;

  @override
  Widget build(BuildContext context) {
    if (isDarkMode) {
      textColors = Colors.grey[300]!;
      backgroundColors = const Color(0xFF505052);
    } else {
      textColors = Colors.black;
      backgroundColors = const Color(0xFFF7F7FA);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColors,
        actions: [
          if (isSearching)
            Expanded(
              child: TextField(
                controller: _textControllerSearch,
                autofocus: true,
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      notes = List.from(allNotes);
                    } else {
                      notes = allNotes
                          .where((n) =>
                              n.toLowerCase().contains(value.toLowerCase()))
                          .toList();
                    }
                  });
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
                  notes = List.from(allNotes);
                });
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
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: backgroundColors,
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: notes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 50),
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
                            style: TextStyle(color: textColors, fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            notes[index],
                            style: TextStyle(color: textColors),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            setState(() {
                              final realIndex = allNotes.indexOf(notes[index]);
                              if (allNotes[realIndex] == "Пустая заметка") {
                                _textController.text = "";
                              } else {
                                _textController.text = allNotes[realIndex];
                              }
                              _selectedNoteIndex = realIndex;
                            });
                          },
                        );
                      },
                    ),
            ),

            Container(
              width: 260,
              height: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: backgroundColors,
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: newNote == false && _selectedNoteIndex == null
                  ? Center(
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
                            style: TextStyle(color: textColors, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : TextField(
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: 'Введите текст заметки...',
                        border: InputBorder.none,
                      ),
                      style: TextStyle(color: textColors),
                      controller: _textController,
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_selectedNoteIndex != null && newNote == false)
            FloatingActionButton(
              heroTag: 'delete',
              onPressed: () {
                allNotes.removeAt(_selectedNoteIndex!);
                notes = List.from(allNotes);
                _selectedNoteIndex = null;
                _textController.clear();
                setState(() {});
              },
              backgroundColor: Colors.yellow,
              tooltip: 'Удалить заметку',
              child: const Icon(Icons.delete),
            ),

          if (_selectedNoteIndex != null) const SizedBox(width: 10),

          if (_selectedNoteIndex != null || newNote == true)
            FloatingActionButton(
              heroTag: 'save',
              onPressed: () {
                if (_textController.text.isEmpty) {
                  _textController.text = "Пустая заметка";
                }
                if (_textController.text.isNotEmpty && newNote) {
                  allNotes.add(_textController.text);
                } else if (_textController.text.isNotEmpty &&
                    _selectedNoteIndex != null) {
                  allNotes[_selectedNoteIndex] = _textController.text;
                }
                notes = List.from(allNotes);
                _selectedNoteIndex = null;
                _textController.clear();
                newNote = false;
                setState(() {});
              },
              backgroundColor: Colors.yellow,
              tooltip: 'Сохранить',
              child: const Icon(Icons.save),
            ),

          if (_selectedNoteIndex == null && newNote == false)
            FloatingActionButton(
              heroTag: 'add',
              onPressed: () {
                setState(() {
                  _selectedNoteIndex = null;
                  _textController.clear();
                  newNote = true;
                });
              },
              backgroundColor: Colors.yellow,
              tooltip: 'Добавить заметку',
              child: const Icon(Icons.edit),
            ),
        ],
      ),
    );
  }
}