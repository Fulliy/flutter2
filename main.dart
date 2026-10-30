
import 'package:flutter/material.dart';

void main() {
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Заметки',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const NotesPage(),
    );
  }
}

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  // Контроллер для работы с текстовым полем
  final TextEditingController _controller =
      TextEditingController();

  // Список заметок
  final List<String> _notes = [];

  // Индекс заметки, которую редактируем
  int? _editingIndex;

  // Сохранение новой заметки или изменений
  void _saveNote() {
    final text = _controller.text.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Введите текст заметки!'),
        ),
      );
      return;
    }

    setState(() {
      if (_editingIndex == null) {
        // Добавление новой заметки
        _notes.add(text);
      } else {
        // Редактирование существующей заметки
        _notes[_editingIndex!] = text;
      }

      _controller.clear();
      _editingIndex = null;
    });
  }

  // Начало редактирования заметки
  void _editNote(int index) {
    setState(() {
      _controller.text = _notes[index];
      _editingIndex = index;
    });
  }

  // Удаление заметки
  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);

      if (_editingIndex == index) {
        _controller.clear();
        _editingIndex = null;
      } else if (_editingIndex != null &&
          _editingIndex! > index) {
        _editingIndex = _editingIndex! - 1;
      }
    });
  }

  @override
  void dispose() {
    // Освобождаем контроллер
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои заметки'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Поле ввода текста
            TextField(
              controller: _controller,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Введите заметку',
                hintText: 'Напишите что-нибудь...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Кнопка сохранения
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveNote,
                icon: Icon(
                  _editingIndex == null
                      ? Icons.save
                      : Icons.edit,
                ),
                label: Text(
                  _editingIndex == null
                      ? 'Сохранить'
                      : 'Сохранить изменения',
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Заголовок списка
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Список заметок (${_notes.length})',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Динамический список заметок
            Expanded(
              child: _notes.isEmpty
                  ? const Center(
                      child: Text(
                        'Пока нет заметок',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _notes.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.only(
                            bottom: 10,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text('${index + 1}'),
                            ),
                            title: Text(_notes[index]),
                            isThreeLine: false,
                            trailing: Wrap(
                              spacing: 0,
                              children: [
                                // Редактирование
                                IconButton(
                                  tooltip: 'Редактировать',
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    _editNote(index);
                                  },
                                ),

                                // Удаление
                                IconButton(
                                  tooltip: 'Удалить',
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    _deleteNote(index);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
