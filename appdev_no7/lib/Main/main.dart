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
              onPressed: () async {
               await FirebaseAuth.instance.signOut(); // ต้องใส่วงเล็บเพื่อเรียกใช้งาน method
                  Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()), // นำผู้ใช้กลับไปที่หน้า Login หลังจาก sign out
                );
              },
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
          style: const TextStyle(fontSize: 20, fontFamily: 'ComicSans'),
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
                style: const TextStyle(fontSize: 18, fontFamily: 'ComicSans'),
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
        title: Text(albumName), // แสดงชื่ออัลบั้ม
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
  List<String> _albumNames = []; // สร้าง List เพื่อเก็บชื่ออัลบั้ม

  @override
  void initState() {
    super.initState();
    _loadAlbums();  // โหลดอัลบั้มเมื่อเริ่มต้น
  }

  // ฟังก์ชันโหลดข้อมูลอัลบั้มจาก Firebase
  void _loadAlbums() async {
    final String userUid = _user!.uid;

    _database.child('users').child(userUid).onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        setState(() {
          // ดึงชื่ออัลบั้มจาก key ของ Map และเก็บไว้ใน List
          _albumNames = data.keys.map((key) => key.toString()).toList();
        });
      }
    });
  }

  // ฟังก์ชันลบอัลบั้ม
  void _deleteAlbum(String albumName) async {
    final String userUid = _user!.uid;

    await _database.child('users').child(userUid).child(albumName).remove(); // ลบอัลบั้มจาก Firebase
    setState(() {
      _albumNames.remove(albumName); // ลบอัลบั้มจาก List ในแอป
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
              // นำทางไปหน้า CreateAlbumScreen เพื่อเพิ่มอัลบั้มใหม่
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
                      // ลบอัลบั้มเมื่อกดปุ่มถังขยะ
                      _deleteAlbum(_albumNames[index]);
                    },
                  ),
                  onTap: () {
                    // เมื่อกดที่ชื่ออัลบั้ม สามารถนำทางไปหน้ารายละเอียดของอัลบั้มได้
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