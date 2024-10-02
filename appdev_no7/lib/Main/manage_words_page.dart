import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';

class ManageWordsPage extends StatefulWidget {
  const ManageWordsPage({super.key});

  @override
  _ManageWordsPageState createState() => _ManageWordsPageState();
}

class _ManageWordsPageState extends State<ManageWordsPage> {
  List<Map<String, String>> _words = [];
  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _translationController = TextEditingController();

  final List<String> _wordTypes = [
    'Nouns',
    'Verbs',
    'Adjectives',
    'Adverbs',
    'Prepositions',
    'Determiners',
    'Pronouns',
    'Conjunctions'
  ];
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  void _loadWords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedWords = prefs.getString('words');

    if (storedWords != null) {
      setState(() {
        _words = List<Map<String, String>>.from(json.decode(storedWords));
      });
    }
  }

 void _saveWords(List<Map<String, String>> words) {
  // อ้างอิงไปยังเส้นทาง "vocabulary/words" ใน Firebase
  DatabaseReference ref = FirebaseDatabase.instance.ref("Vocabulary/word");
  for (var word in words) {
    ref.push().set({
      "word": word['word'],                 // คำศัพท์
      "translation": word['translation'],   // คำแปล
      "type": word['type'],                 // ประเภทของคำ (เช่น noun, verb)
    }).then((_) {
      print('Word saved successfully');      // ข้อมูลถูกบันทึกสำเร็จ
    }).catchError((error) {
      print('Error saving word: $error');    // กรณีมีข้อผิดพลาด
    });
  }
}

  void _addWord() {
  // อ้างอิงไปยังเส้นทาง "vocabulary/words"
  DatabaseReference ref = FirebaseDatabase.instance.ref("Vocabulary/word");

  // การใช้ push().set() เพื่อเพิ่มข้อมูล
  ref.push().set({
    "word": _wordController.text,           // ข้อความจาก TextField
    "translation": _translationController.text,  // คำแปล
    "type": _selectedType,                  // ประเภทของคำ
  }).then((_) {
    print('Data added successfully');       // ข้อมูลถูกบันทึกสำเร็จ
  }).catchError((error) {
    print('Error adding data: $error');     // กรณีมีข้อผิดพลาด
  });
}

   void _removeWord(int index) {
  setState(() {
    // ลบคำจากรายการในแอปพลิเคชัน
    _words.removeAt(index);
  });

   // สมมุติว่าเราเก็บคีย์ไว้ในรายการ `_words` เช่น _words[index]['key']
  String wordKey = _words as String;

  // อ้างอิง Firebase Realtime Database ไปยังคำที่ต้องการลบ
  DatabaseReference ref = FirebaseDatabase.instance.ref("Vocabulary/$wordKey");

  // ลบคำจาก Firebase Realtime Database
  ref.remove().then((_) {
    print('Word removed successfully');
  }).catchError((error) {
    print('Error removing word: $error');
  });
}


 void _editWord(int index) {
  // ตั้งค่าข้อมูลเริ่มต้นใน TextField และ Dropdown
  _wordController.text = _words[index]['word']!;
  _translationController.text = _words[index]['translation']!;
  _selectedType = _words[index]['type'];


    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Word'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _wordController,
                decoration: const InputDecoration(labelText: 'Word'),
              ),
              TextField(
                controller: _translationController,
                decoration: const InputDecoration(labelText: 'Translation'),
              ),
              DropdownButton<String>(
                value: _selectedType,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedType = newValue;
                  });
                },
                items: _wordTypes.map<DropdownMenuItem<String>>((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                setState(() {
                  _words[index]['word'] = _wordController.text;
                  _words[index]['translation'] = _translationController.text;
                  _words[index]['type'] = _selectedType!;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Words'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextField(
                  controller: _wordController,
                  decoration: const InputDecoration(labelText: 'Word'),
                ),
                TextField(
                  controller: _translationController,
                  decoration: const InputDecoration(labelText: 'Translation'),
                ),
                DropdownButton<String>(
                  value: _selectedType,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedType = newValue;
                    });
                  },
                  items:
                      _wordTypes.map<DropdownMenuItem<String>>((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                ),
                ElevatedButton(
                  onPressed: _addWord,
                  child: const Text('Add Word'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _words.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(_words[index]['word']!),
                  subtitle: Text(
                      '${_words[index]['translation']} - ${_words[index]['type']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeWord(index),
                  ),
                  onTap: () => _editWord(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
