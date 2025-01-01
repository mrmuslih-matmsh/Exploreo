import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BookmarkDatabase {
  static final BookmarkDatabase instance = BookmarkDatabase._init();
  static Database? _database;

  BookmarkDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('bookmarks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE bookmarks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        postid TEXT NOT NULL,
        coverImage TEXT,
        title TEXT,
        location TEXT
      )
    ''');
  }

  Future<void> addBookmark(Map<String, dynamic> bookmark) async {
    final db = await instance.database;
    await db.insert('bookmarks', bookmark);
  }

  Future<List<Map<String, dynamic>>> getBookmarks() async {
    final db = await instance.database;
    return await db.query('bookmarks');
  }

  Future<void> removeBookmark(String postid) async {
    final db = await instance.database;
    await db.delete('bookmarks', where: 'postid = ?', whereArgs: [postid]);
  }

  Future<bool> isBookmarked(String postid) async {
    final db = await instance.database;
    final result =
    await db.query('bookmarks', where: 'postid = ?', whereArgs: [postid]);
    return result.isNotEmpty;
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
