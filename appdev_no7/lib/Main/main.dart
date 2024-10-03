import 'package:appdev_no7/Main/manage_album.dart';
import 'package:appdev_no7/firebase_auth_service.dart/firebase_auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';
import '../Login & regist/login_screen.dart';
import 'manage_words_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyVocabApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}

class MyVocabApp extends StatelessWidget {
  const MyVocabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'ComicSans',
        primarySwatch: Colors.blue,
      ),
      home: MainScaffold(),
    );
  }
}

// ---------------- Scaffold หลักสำหรับการนำทาง ----------------
class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}


class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    SettingPage(),
    GamePage(),
    VocabularyPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.black,
              child: Text(
                'MV',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 10),
            Text('My Vocab App'),
          ],
        ),
        
        backgroundColor: Colors.lightBlue,
      ),
        
        body: _pages[_currentIndex],
        
        bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gamepad),
            label: 'Game',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Album',
          ),
        ],
      ),
    );
  }
}

// ---------------- หน้า Setting ----------------

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  void _signOut(BuildContext context) {
    // เมื่อกดปุ่ม Sign Out, นำทางกลับไปที่หน้า LoginScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
    // หากมีการจัดการ session เช่น shared preferences ก็สามารถเคลียร์ที่นี่ได้
    // เช่น: SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.clear();
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Settings Page'),
    ),
    body: Column(
      children: [
        Expanded(
          child: Center(
            child: const Text(
              'Settings Page',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0), // Padding รอบๆปุ่ม
          child: SizedBox(
            width: double.infinity, // ให้ปุ่มกว้างเต็มที่
            child: ElevatedButton(
              onPressed: () => _signOut(context),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue, // เปลี่ยนสีฟอนต์เป็นสีขาว
                padding: const EdgeInsets.symmetric(vertical: 20), // ปรับความสูงปุ่ม
                textStyle: const TextStyle(fontSize: 18, fontFamily: 'ComicSans'), // ปรับขนาดฟอนต์
              ),
              child: const Text('Sign Out'),
            ),
          ),
        ),
      ],
    ),
  );
}
}

// ---------------- หน้าจัดการเกม ----------------

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final List<Map<String, String>> _words = [
    {'word': 'apple', 'translation': 'แอปเปิ้ล'},
    {'word': 'dog', 'translation': 'หมา'},
    {'word': 'cat', 'translation': 'แมว'},
    {'word': 'car', 'translation': 'รถยนต์'},
    {'word': 'sun', 'translation': 'ดวงอาทิตย์'},
    {'word': 'moon', 'translation': 'พระจันทร์'},
    {'word': 'bird', 'translation': 'นก'},
    {'word': 'fish', 'translation': 'ปลา'},
  ];

  List<String> _tiles = [];
  List<bool> _revealed = [];
  int? _firstTileIndex;
  bool _canTap = true;

  @override
  void initState() {
    super.initState();
    _setupGame();
  }

  void _setupGame() {
    List<String> wordList = [];
    for (var word in _words) {
      wordList.add(word['word']!);
      wordList.add(word['translation']!);
    }
    wordList.shuffle(Random());
    setState(() {
      _tiles = wordList;
      _revealed = List.filled(_tiles.length, false);
      _firstTileIndex = null;
      _canTap = true;
    });
  }

  void _onTileTap(int index) {
    if (!_canTap || _revealed[index]) return;

    setState(() {
      _revealed[index] = true;
    });

    if (_firstTileIndex == null) {
      _firstTileIndex = index;
    } else {
      _canTap = false;
      int firstIndex = _firstTileIndex!;
      String firstValue = _tiles[firstIndex];
      String secondValue = _tiles[index];

      bool isMatch = _checkMatch(firstValue, secondValue);

      if (isMatch) {
        _canTap = true;
        _firstTileIndex = null;
      } else {
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            _revealed[firstIndex] = false;
            _revealed[index] = false;
          });
          _canTap = true;
          _firstTileIndex = null;
        });
      }
    }
  }

  bool _checkMatch(String first, String second) {
    for (var word in _words) {
      if ((first == word['word'] && second == word['translation']) ||
          (second == word['word'] && first == word['translation'])) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Matching Game'),
      ),
      body: const Center(
        child: Text(
          'Game Page',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // Change to 4 columns for 4x4 grid
      ),
      itemCount: _tiles.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _onTileTap(index),
          child: Card(
            color: _revealed[index] ? Colors.white : Colors.blue,
            child: Center(
              child: Text(
                _revealed[index] ? _tiles[index] : '',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ---------------- หน้าจัดการคำศัพท์ ----------------

class VocabularyPage extends StatelessWidget {
  const VocabularyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Album'),
      
        actions: [
          IconButton(
            icon: Icon(Icons.add), // ไอคอน "+"
            tooltip: 'Create Album',
            onPressed: () {
              // เมื่อกดปุ่มนี้ จะไปยังหน้า manage_word_page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateAlbumScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
