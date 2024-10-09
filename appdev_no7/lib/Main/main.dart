import 'package:appdev_no7/Main/manage_album.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import '../Login & regist/login_screen.dart';

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
  // Set initial index to 2 to show VocabularyPage first
  int _currentIndex = 2;  // <- Changed from 0 to 2

  final List<Widget> _pages = [
    SettingPage(),
    GamePage(),
    VocabularyPage(),  // VocabularyPage is at index 2
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

// ---------------- Updated Setting Page ----------------
class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  double _volume = 50;
  String _selectedTheme = 'Blue Pastel';
  String _selectedLanguage = 'ENGLISH';

  List<String> themes = ['Blue Pastel', 'Dark Mode', 'Light Mode'];
  List<String> languages = ['ENGLISH', 'FRENCH', 'SPANISH'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "SETTINGS",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        shadows: [
                          Shadow(
                            blurRadius: 5.0,
                            color: Colors.black,
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Volume Control
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Volume", style: TextStyle(fontSize: 18)),
                        Expanded(
                          child: Slider(
                            value: _volume,
                            min: 0,
                            max: 100,
                            divisions: 100,
                            label: _volume.round().toString(),
                            onChanged: (value) {
                              setState(() {
                                _volume = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // Theme Selection
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Theme", style: TextStyle(fontSize: 18)),
                        DropdownButton<String>(
                          value: _selectedTheme,
                          items: themes.map((String theme) {
                            return DropdownMenuItem<String>(
                              value: theme,
                              child: Text(theme),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedTheme = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // Language Selection
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("App Language", style: TextStyle(fontSize: 18)),
                        DropdownButton<String>(
                          value: _selectedLanguage,
                          items: languages.map((String language) {
                            return DropdownMenuItem<String>(
                              value: language,
                              child: Row(
                                children: [
                                  Text(language),
                                  const SizedBox(width: 8),
                                  if (language == 'ENGLISH')
                                    const Icon(Icons.flag, color: Colors.red),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedLanguage = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
            // Sign Out Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'ComicSans',
                    ),
                  ),
                  child: const Text('Sign Out'),
                ),
              ),
            ),
          ],
        ),
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
        title: const Text('เกมจับคู่คำศัพท์'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: _buildGrid(), // แสดงตาราง
            ),
            ElevatedButton(
              onPressed: _setupGame,
              child: const Text('เริ่มเกมใหม่'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // ตาราง 4x4
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

class VocabularyPage extends StatefulWidget {
  const VocabularyPage({Key? key}) : super(key: key);

  @override
  _Vocabularystate createState() => _Vocabularystate();
}
class AlbumDetailScreen extends StatelessWidget {
  final String albumName;

  const AlbumDetailScreen({Key? key, required this.albumName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(albumName), 
      ),
      body: Center(
        child: Text('Details for album: $albumName'),
      ),
    );
  }
}

class _Vocabularystate extends State<VocabularyPage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final User? _user = FirebaseAuth.instance.currentUser;
  List<String> _albumNames = []; 

  @override
  void initState() {
    super.initState();
    _loadAlbums();  
  }

  void _loadAlbums() async {
    final String userUid = _user!.uid;

    _database.child('users').child(userUid).onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        setState(() {
          _albumNames = data.keys.map((key) => key.toString()).toList();
        });
      }
    });
  }

  void _deleteAlbum(String albumName) async {
    final String userUid = _user!.uid;

    await _database.child('users').child(userUid).child(albumName).remove(); 
    setState(() {
      _albumNames.remove(albumName); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Albums'),
        actions: [
          IconButton(
            icon: Icon(Icons.add), 
            tooltip: 'Add Album',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateAlbumScreen()),
              );
            },
          ),
        ],
      ),
      body: _albumNames.isNotEmpty
          ? ListView.builder(
              itemCount: _albumNames.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_albumNames[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: const Color.fromARGB(255, 0, 0, 0)),
                    onPressed: () {
                      _deleteAlbum(_albumNames[index]);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AlbumDetailScreen(albumName: _albumNames[index]),
                      ),
                    );
                  },
                );
              },
            )
          : const Center(child: Text('No albums found')),
    );
  }
}  