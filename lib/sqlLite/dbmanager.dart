import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:my_todo_app/model/todo_model.dart';

class DBmanager {
  static DBmanager instance = DBmanager._();
  DBmanager._() {}

  Future<Database> initDatabase() async {
    String dbPath = await getDatabasesPath();
    Database database = await openDatabase(join(dbPath, 'todoooooos.db'),
        onCreate: (db, version) {
      return db
          .execute('CREATE TABLE todo (id INTEGER PRIMARY KEY,title TEXT)');
    }, version: 1);
    return database;
  }

  Future<void> adddata(TodoModel todo) async {
    Database db = await this.initDatabase();

    await db.insert(
      'todo',
      todo.toMap(),
    );
  }

  Future<List<TodoModel>> loadData() async {
    Database db = await this.initDatabase();

    List<Map<String, dynamic>> todolist = await db.query('todo');

    return List.generate(todolist.length, (index) {
      return TodoModel(
        id: todolist[index]['id'],
        title: todolist[index]['title'],
      );
    });
  }

  Future<void> deleteTodo(String id) async {
    Database db = await this.initDatabase();

    await db.delete('todo', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateTodo(String id, TodoModel todo) async {
    Database db = await this.initDatabase();

    await db.update(
      'todo',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
