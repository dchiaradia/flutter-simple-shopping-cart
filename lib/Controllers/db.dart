import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DB {
  static final _databaseName = "shoppingCart.db";
  static final _databaseVersion = 3;

  // torna esta classe singleton
  DB._privateConstructor();
  static final DB instance = DB._privateConstructor();
  // tem somente uma referência ao banco de dados
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    // instancia o db na primeira vez que for acessado
    _database = await _initDatabase();
    return _database;
  }

  // abre o banco de dados e o cria se ele não existir
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  //Código SQL para criar o banco de dados e a tabela
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE products (
            id INTEGER PRIMARY KEY,
            title TEXT NOT NULL,
            price REAL NOT NULL,
            description TEXT NOT NULL,            
            category TEXT NOT NULL,            
            image TEXT NOT NULL
          )
          ''');

    await db.execute('''
          CREATE TABLE cartItems (
            id INTEGER PRIMARY KEY,
            productId INTEGER,
            productPrice REAL NOT NULL,
            productQtd INT NOT NULL,
            productName TEXT NOT NULL,            
            productImage TEXT NOT NULL,    
            pedidoId INT
          )
          ''');

    await db.execute('''
          CREATE TABLE pedidos (
            id INTEGER PRIMARY KEY  ,
            dtPedido INTEGER NOT NULL
          )
          ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute("DROP TABLE IF EXISTS cartItems");
    await db.execute("DROP TABLE IF EXISTS pedidos");
    await db.execute("DROP TABLE IF EXISTS products");

    _onCreate(db, newVersion);
  }

  // métodos Helper
  //----------------------------------------------------
  // Insere uma linha no banco de dados onde cada chave
  // no Map é um nome de coluna e o valor é o valor da coluna.
  // O valor de retorno é o id da linha inserida.
  Future<int> insert(table, Map<String, dynamic> row) async {
    Database? db = await instance.database;
    try {
      return await db!.insert(table, row);
    } on Exception catch (_) {
      print('Error ao inserir');
      return 0;
    }
  }

  // Todas as linhas são retornadas como uma lista de mapas, onde cada mapa é
  // uma lista de valores-chave de colunas.
  Future<List<Map<String, dynamic>>> queryAllRows(table) async {
    Database? db = await instance.database;
    return await db!.query(table);
  }

  //executa uma query especifica
  Future<List<Map<String, dynamic>>> query(query, where) async {
    Database? db = await instance.database;
    if (where == "" || where == null) {
      return await db!.rawQuery(query);
    } else {
      return await db!.rawQuery(query, where);
    }
  }

  // T0dos os métodos : inserir, consultar, atualizar e excluir,
  // também podem ser feitos usando  comandos SQL brutos.
  // Esse método usa uma consulta bruta para fornecer a contagem de linhas.
  Future<int?> queryRowCount(table) async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(
        await db!.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // Assumimos aqui que a coluna id no mapa está definida. Os outros
  // valores das colunas serão usados para atualizar a linha.
  Future<int> update(table, columnId, Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[columnId];
    //row.remove(columnId);
    return await db!
        .update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Exclui a linha especificada pelo id. O número de linhas afetadas é
  // retornada. Isso deve ser igual a 1, contanto que a linha exista.
  Future<int> delete(table, columnId, value) async {
    Database? db = await instance.database;
    return await db!.delete(table, where: '$columnId = ?', whereArgs: [value]);
  }

  Future<int> rawDelete(table, [columnId, value]) async {
    Database? db = await instance.database;

    if (value == "" || value == null) {
      return await db!.rawDelete('DELETE FROM $table');
    } else {
      return await db!
          .rawDelete('DELETE FROM $table WHERE $columnId =? ', value);
    }
  }
}
