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
              'CREATE TABLE Bills (_id INTEGER PRIMARY KEY, title TEXT, date INTEGER, type INTEGER, accountIn TEXT, accountOut TEXT, category1 TEXT, category2 TEXT, member TEXT, value100 INTEGER);');
          print('New table created at $path');
        });
  }

  //获得所有数据
  Future<List<BillsModel>> getBillsFromDB() async {
    final db = await database;
    List<BillsModel> billsList = [];
    List<Map> maps = await db.query('Bills', columns: [
      '_id',
      'title',
      'date',
      'type',
      'accountIn',
      'accountOut',
      'category1',
      'category2',
      'member',
      'value100'
    ],
      orderBy: 'date DESC',
    );
    if (maps.length > 0) {
      maps.forEach((map) {
        billsList.add(BillsModel.fromMap(map));
      });
    }
    return billsList;
  }

  //获得所有数据
  Future<List<BillsModel>> getBillsFromDBDescand() async {
    final db = await database;
    List<BillsModel> billsList = [];
    List<Map> maps = await db.query('Bills', columns: [
      '_id',
      'title',
      'date',
      'type',
      'accountIn',
      'accountOut',
      'category1',
      'category2',
      'member',
      'value100'
      ],
      orderBy: 'date DESC',
    );
    if (maps.length > 0) {
      maps.forEach((map) {
        billsList.add(BillsModel.fromMap(map));
      });
    }
    return billsList;
  }

  Future<List<BillsModel>> getBillsFromDBByDate(
      DateTime dateStart, DateTime dateEnd) async {
    final db = await database;
    List<BillsModel> billsList = [];
    List<Map> maps = await db.query('Bills',
        columns: [
          '_id',
          'title',
          'date',
          'type',
          'accountIn',
          'accountOut',
          'category1',
          'category2',
          'member',
          'value100'
        ],
        where: 'date >= ? AND date <= ?',
        orderBy: 'date DESC',
        whereArgs: [
          dateStart.millisecondsSinceEpoch,
          dateEnd.millisecondsSinceEpoch
        ]);
    if (maps.length > 0) {
      maps.forEach((map) {
        billsList.add(BillsModel.fromMap(map));
      });
    }
    return billsList;
  }

  Future<List<BillsModel>> getBillsFromDBByDateOrderByDate(
      DateTime dateStart, DateTime dateEnd) async {
    final db = await database;
    List<BillsModel> billsList = [];
    List<Map> maps = await db.query('Bills',
        columns: [
          '_id',
          'title',
          'date',
          'type',
          'accountIn',
          'accountOut',
          'category1',
          'category2',
          'member',
          'value100'
        ],
        where: 'date >= ? AND date <= ?',
        whereArgs: [
          dateStart.millisecondsSinceEpoch,
          dateEnd.millisecondsSinceEpoch
        ],
        orderBy: 'date',
    );
    if (maps.length > 0) {
      maps.forEach((map) {
        billsList.add(BillsModel.fromMap(map));
      });
    }
    return billsList;
  }

//根据账户筛选账单
  Future<List<BillsModel>> getBillsFromDBByAccount(
      String accountIn, String accountOut) async {
    final db = await database;
    List<BillsModel> billsList = [];
    List<Map> maps = await db.query('Bills',
        columns: [
          '_id',
          'title',
          'date',
          'type',
          'accountIn',
          'accountOut',
          'category1',
          'category2',
          'member',
          'value100'
        ],
        where: 'accountIn = ? AND accountOut = ?',
        whereArgs: [accountIn, accountOut]);
    if (maps.length > 0) {
      maps.forEach((map) {
        billsList.add(BillsModel.fromMap(map));
      });
    }
    return billsList;
  }

//根据一级分类筛选
  Future<List<BillsModel>> getBillsFromDBByCate1(String category1) async {
    final db = await database;
    List<BillsModel> billsList = [];
    List<Map> maps = await db.query('Bills',
        columns: [
          '_id',
          'title',
          'date',
          'type',
          'accountIn',
          'accountOut',
          'category1',
          'category2',
          'member',
          'value100'
        ],
        where: 'category1 = ?',
        whereArgs: [category1]);
    if (maps.length > 0) {
      maps.forEach((map) {
        billsList.add(BillsModel.fromMap(map));
      });
    }
    return billsList;
  }

//根据二级分类筛选
  Future<List<BillsModel>> getBillsFromDBByCate2(
      String category1, String category2) async {
    final db = await database;
    List<BillsModel> billsList = [];
    List<Map> maps = await db.query('Bills',
        columns: [
          '_id',
          'title',
          'date',
          'type',
          'accountIn',
          'accountOut',
          'category1',
          'category2',
          'member',
          'value100'
        ],
        where: 'category1 = ? AND category2 = ?',
        whereArgs: [category1, category2]);
    if (maps.length > 0) {
      maps.forEach((map) {
        billsList.add(BillsModel.fromMap(map));
      });
    }
    return billsList;
  }

//根据成员筛选
  Future<List<BillsModel>> getBillsFromDBByMember(String member) async {
    final db = await database;
    List<BillsModel> billsList = [];
    List<Map> maps = await db.query('Bills',
        columns: [
          '_id',
          'title',
          'date',
          'type',
          'accountIn',
          'accountOut',
          'category1',
          'category2',
          'member',
          'value100'
        ],
        where: 'member = ?',
        whereArgs: [member]);
    if (maps.length > 0) {
      maps.forEach((map) {
        billsList.add(BillsModel.fromMap(map));
      });
    }
    return billsList;
  }

  //根据ID更新数据
  updateBillInDB(BillsModel updatedBill) async {
    final db = await database;
    await db.update('Bills', updatedBill.toMap(),
        where: '_id = ?', whereArgs: [updatedBill.id]);
    print(
        'Bill updated: ${updatedBill.title} ${updatedBill.value100} ${updatedBill.date}');
  }

  updateMemberInDB(String memberToBeUpdated, String memberNewName) async {
    print ("Will update member: $memberToBeUpdated to $memberNewName");
    final db = await database;
    int count = await db.rawUpdate('UPDATE Bills SET member = ? WHERE member = ?', [memberNewName, memberToBeUpdated]);
    print("updated: $count");
  }

  updateAccountInDB(String accountToBeUpdated, String accountNewName) async {
    print ("Will update member: $accountToBeUpdated to $accountNewName");
    final db = await database;
    int count = await db.rawUpdate('UPDATE Bills SET accountIn = ? WHERE accountIn = ?', [accountNewName, accountToBeUpdated]);
    count += await db.rawUpdate('UPDATE Bills SET accountOut = ? WHERE accountOut = ?', [accountNewName, accountToBeUpdated]);
    print("updated: $count");
  }

  deleteAccountInDB(String accountToBeDeleted) async {
    final db = await database;
    int count = await db.delete('Bills', where: 'accountIn = ? OR accountOut = ?', whereArgs: [accountToBeDeleted, accountToBeDeleted]);
    print("deleted: $count");
  }

  Future<int> getAccountNetAsset(String accountName) async {
    print("Will check $accountName");
    final db = await database;
    List<Map<String, dynamic>> queryResultIn = await db.rawQuery('SELECT sum(value100) FROM Bills WHERE accountIn = ? AND type IN (0, 2)', [accountName]);
    var temp = queryResultIn[0]['sum(value100)'].toString();
    var assetIn = int.tryParse(temp) as int;
    if (assetIn == null) assetIn = 0;
    List<Map<String, dynamic>> queryResultOut = await db.rawQuery('SELECT sum(value100) FROM Bills WHERE accountOut = ? AND type IN (1, 2)', [accountName]);
    temp = queryResultOut[0]['sum(value100)'].toString();
    var assetOut = int.tryParse(temp) as int;
    if (assetOut == null) assetOut = 0;
    int netAsset = assetIn - assetOut;
    print("Net Asset is: $netAsset");
    return netAsset;
  }


  //清空数据
  deleteBillAllInDB() async {
    final db = await database;
    await db.delete('Bills');
    print('All bills deleted');
  }

  //根据BillsModel删除数据
  deleteBillInDB(BillsModel billToDelete) async {
    final db = await database;
    await db.delete('Bills', where: '_id = ?', whereArgs: [billToDelete.id]);
    print('Bill deleted');
  }

  //根据ID删除数据
  deleteBillIdInDB(int id) async {
    final db = await database;
    await db.delete('Bills', where: '_id = ?', whereArgs: [id]);
    print('Bill deleted');
  }

  updateCategory1InDB(String category1ToBeUpdated, String category1NewName) async {
    final db = await database;
    int count = await db.rawUpdate('UPDATE Bills SET category1 = ? WHERE category1 = ?', [category1NewName, category1ToBeUpdated]);
    print("updated: $count");
  }

  updateCategory2InDB(String category2ToBeUpdated, String category2NewName, String fatherCategory) async {
    final db = await database;
    int count = await db.rawUpdate('UPDATE Bills SET category2 = ? WHERE category2 = ? AND category1 = ?', [category2NewName, category2ToBeUpdated, fatherCategory]);
    print("updated: $count");
  }

  deleteCategory1InDB(String category1ToBeDeleted) async {
    final db = await database;
    int count = await db.delete('Bills', where: 'category1 = ?', whereArgs: [category1ToBeDeleted]);
    print("deleted: $count");
  }

  deleteCategory2InDB(String category2ToBeDeleted, String fatherCategory) async {
    final db = await database;
    print(category2ToBeDeleted);
    print(fatherCategory);
    int count = await db.delete('Bills', where: 'category2 = ? AND category1 = ?', whereArgs: [category2ToBeDeleted.toString(), fatherCategory.toString()]);
    print("deleted: $count");
  }

  queryCategory2InDB(String category1, String category2) async {

  }

  //添加一条数据
  Future<BillsModel> addBillInDB(BillsModel newBill) async {
    final db = await database;
    if (newBill.title.trim().isEmpty) newBill.title = ' ';
    int id = await db.transaction((transaction) {
      transaction.rawInsert(
          'INSERT into Bills(title, date, type, accountIn, accountOut, category1, category2, member, value100) VALUES ("${newBill.title}", "${newBill.date.millisecondsSinceEpoch}", "${newBill.type}", "${newBill.accountIn}", "${newBill.accountOut}", "${newBill.category1}", "${newBill.category2}", "${newBill.member}", "${newBill.value100}");');
    });
    newBill.id = id;
    print(
        'Bill added: ${newBill.title} ${newBill.value100} ${newBill.date} type is: ${newBill.type}');
    return newBill;
  }


  //本月记账条数
  Future<int> billsCountThisMonth() async {
    int count = 0;
    final db = await database;
    DateTime to = DateTime.now();
    DateTime from = DateTime(to.year, to.month, 1);
    List<Map<String, dynamic>> result = await db.rawQuery('SELECT count(*) FROM Bills WHERE date >= ? AND date <= ?', [from.millisecondsSinceEpoch, to.millisecondsSinceEpoch]);
    count = result[0]['count(*)'] == null ? 0 : result[0]['count(*)'];
    print(count);
    return count;
  }

  //本月收入（格式化String）
  Future<String> assetInThisMonth() async {
    final db = await database;
    DateTime to = DateTime.now();
    DateTime from = DateTime(to.year, to.month, 1);
    List<Map<String, dynamic>> result = await db.rawQuery('SELECT sum(value100) FROM Bills WHERE date >= ? AND date <= ? AND type = 0', [from.millisecondsSinceEpoch, to.millisecondsSinceEpoch]);
    int value100 = result[0]['sum(value100)'];
    String sum = (value100 == null) ? '0.00' :
    (value100 > 99)?
    value100.toString().substring(0, value100.toString().length-2)
        + '.'
        + value100.toString().substring(value100.toString().length-2, value100.toString().length):
    (value100 > 9) ? '0.' + value100.toString() :'0.0' + value100.toString();
    print(sum);
    return sum;
  }

  //本月支出（格式化String）
  Future<String> assetOutThisMonth() async {
    final db = await database;
    DateTime to = DateTime.now();
    DateTime from = DateTime(to.year, to.month, 1);
    List<Map<String, dynamic>> result = await db.rawQuery('SELECT sum(value100) FROM Bills WHERE date >= ? AND date <= ? AND type = 1', [from.millisecondsSinceEpoch, to.millisecondsSinceEpoch]);
    int value100 = result[0]['sum(value100)'];
    String sum = (value100 == null) ? '0.00' :
    (value100 > 99)?
    value100.toString().substring(0, value100.toString().length-2)
        + '.'
        + value100.toString().substring(value100.toString().length-2, value100.toString().length):
    (value100 > 9) ? '0.' + value100.toString() :'0.0' + value100.toString();
    print(sum);
    return sum;
  }

  Future<String> assetThisMonth() async {
    final db = await database;
    DateTime to = DateTime.now();
    DateTime from = DateTime(to.year, to.month, 1);
    List<Map<String, dynamic>> resultIn = await db.rawQuery('SELECT sum(value100) FROM Bills WHERE date >= ? AND date <= ? AND type = 0', [from.millisecondsSinceEpoch, to.millisecondsSinceEpoch]);
    int value100In = resultIn[0]['sum(value100)'] == null ? 0 : resultIn[0]['sum(value100)'];
    List<Map<String, dynamic>> resultOut = await db.rawQuery('SELECT sum(value100) FROM Bills WHERE date >= ? AND date <= ? AND type = 1', [from.millisecondsSinceEpoch, to.millisecondsSinceEpoch]);
    int value100Out = resultOut[0]['sum(value100)'] == null ? 0 : resultOut[0]['sum(value100)'];
    int value100 = value100In - value100Out;
    bool isNegative = false;
    if (value100 < 0) {
      isNegative = true;
      value100 = -value100;
    }
    String sum = (value100 == null) ? '0.00' :
    (value100 > 99)?
    value100.toString().substring(0, value100.toString().length-2)
        + '.'
        + value100.toString().substring(value100.toString().length-2, value100.toString().length):
    (value100 > 9) ? '0.' + value100.toString() :'0.0' + value100.toString();
    print(sum);
    if (isNegative) {
      sum = '-' + sum;
    }
    return sum;
  }

  //返回最近一笔记账
  Future<BillsModel> LatestBill() async {
    final db = await database;
    List<BillsModel> billsList = [];
    List<Map> maps = await db.query('Bills', columns: [
      '_id',
      'title',
      'date',
      'type',
      'accountIn',
      'accountOut',
      'category1',
      'category2',
      'member',
      'value100'
    ],
      orderBy: 'date DESC',
      limit: 1
    );
    if (maps.length > 0) {
      maps.forEach((map) {
        billsList.add(BillsModel.fromMap(map));
      });
    }
    if (billsList.length != 0)
      return billsList[0];
    return null;
  }

  Future<BillsModel> getBillById(int id) async {
    final db = await database;
    List<BillsModel> billsList = [];
    List<Map> maps = await db.query('Bills', columns: [
      '_id',
      'title',
      'date',
      'type',
      'accountIn',
      'accountOut',
      'category1',
      'category2',
      'member',
      'value100'
    ],
        where: '_id = ?',
        whereArgs: [id],
        orderBy: 'date DESC',
        limit: 1
    );
    if (maps.length > 0) {
      maps.forEach((map) {
        billsList.add(BillsModel.fromMap(map));
      });
    }
    if (billsList.length != 0)
      return billsList[0];
    return null;
  }




}
