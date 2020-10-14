
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../data/model.dart';

//账单数据库服务
class BillsDatabaseService {
  String path;

  BillsDatabaseService._();

  static final BillsDatabaseService db = BillsDatabaseService._();

  Database _database;

  //获得数据库
  Future<Database> get database async {
    if (_database != null) return _database;
    //if null then init
    _database = await init();
    return _database;
  }

  //初始化
  init() async {
    String path = await getDatabasesPath();
    path = join(path, 'bills.db');
    print("Entered path $path");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(
              'CREATE TABLE Bills (_id INTEGER PRIMARY KEY, title TEXT, date TEXT, type INTEGER, accountIn INTEGER, accountOut INTEGER, category1 INTEGER, category2 INTEGER, member INTEGER, value100 INTEGER);');
          print ('New table created at $path');
        });
  }

  //获得所有数据
  Future<List<BillsModel>> getBillsFromDB() async {
    final db = await database;
    List<BillsModel> billsList = [];
    List<Map> maps = await db.query('Bills',
        columns: [
          '_id', 'title', 'date', 'type', 'accountIn', 'accountOut', 'category1', 'category2', 'member', 'value100'
        ]);
    if (maps.length > 0) {
      maps.forEach((map) {
        billsList.add(BillsModel.fromMap(map));
      });
    }
    return billsList;
  }

  /*
  //根据账户获得数据
  Future<List<BillsModel>> getBillsFromDBByCat1(DateTime dayStart, DateTime dayEnd, int type, int account, int category1) async {
    final db = await database;
    List<BillsModel> billsList = [];

    List<Map> maps = await db.query('Bills',
    columns: [
      '_id', 'title', 'date', 'type', 'accountIn', 'accountOut', 'category1', 'category2', 'hasMember', 'member', 'value100'
    ],
      where: '"date" >=  '
    );
    if (maps.length > 0) {
      maps.forEach((map) {
        billsList.add(BillsModel.fromMap(map));
      });
  }
  */

  //根据ID更新数据
  updateBillInDB(BillsModel updatedBill) async {
    final db = await database;
    await db.update('Bills', updatedBill.toMap(),
        where: '_id = ?', whereArgs: [updatedBill.id]);
    print('Bill updated: ${updatedBill.title} ${updatedBill.value100} ${updatedBill.date}');
  }



  //根据ID删除数据
  deleteBillInDB(BillsModel billToDelete) async {
    final db = await database;
    await db.delete('Bills', where: '_id = ?', whereArgs: [billToDelete.id]);
    print('Note deleted');
  }

  //添加一条数据
  Future<BillsModel> addBillInDB(BillsModel newBill) async {
    final db = await database;
    if (newBill.title.trim().isEmpty) newBill.title = 'Untitled Bill';
    int id = await db.transaction((transaction) {
      transaction.rawInsert(
          'INSERT into Bills(title, date, type, accountIn, accountOut, category1, category2, member, value100) VALUES ("${newBill.title}", "${newBill.date.toIso8601String()}", "${newBill.type}", "${newBill.accountIn}", "${newBill.accountOut}", "${newBill.category1}", "${newBill.category2}", "${newBill.member}", "${newBill.value100}");'
      );
    });
    newBill.id = id;
    print('Bill added: ${newBill.title} ${newBill.value100} ${newBill.date} type is: ${newBill.type}');
    return newBill;
  }
}