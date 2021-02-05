
import 'dart:io';
import 'package:mission_mangal/model/employee_model.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class DBProvider
{
  static Database _database;
  static final DBProvider db = DBProvider._();
  DBProvider._();

  Future<Database> get database async
  {
    if (_database != null) return _database;
    _database= await initDB();
    return _database;

  }

  initDB () async
  {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path,'employee_manager.db' );

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate:  (Database db, int version) async {
          await db.execute('CREATE TABLE EMPLOYEE('
              'id INTEGER PRIMARY KEY,'
              'email TEXT,'
              'username TEXT,'
              'name TEXT'
               'Uid INTEGER '
                'FOREIGN KEY (Uid)   REFERENCES Address (Uid)'
                'ON UPDATE SET NULL'
                 'ON DELETE SET NULL'

              ')');

          await db.execute('''
             CREATE TABLE Address(
                 'id INTEGER PRIMARY KEY AUTOINCREMENT'
                 ' Uid INTEGER FOREIGN KEY',
                 'street TEXT NOT NULL',
                 ' suite TEXT NOT NULL',
                 ' city TEXT NOT NULL',
                  'zipcode TEXT NOT NULL',

    ),
    ''');

        }
        );



  }
  createEmployee(Employee newEmployee) async {
    await deleteAllEmployees();
    final db = await database;
    final res = await db.insert('Employee', newEmployee.toJson());
    print('create employee table');
    return res;

  }

  createAddress(Address  Newaddress) async {
    await deleteAllAddress();
    final db = await database;
    final res = await db.insert('Address', Newaddress.toJson());
    print('create address table');
    return res;
  }

  Future<int> update(Map<String, dynamic> row)async {
      Database db = await database;
      return await db.rawUpdate('UPDATE FROM ADDRESS');
    }



  Future<int> deleteAllEmployees() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Employee');
    print('delete form employee');
    return res;
  }

  Future<int> deleteAllAddress() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Address');
    print('Delete from Address');
    return res;
  }

  Future<List<Employee>> getAllEmployees() async {
    final db = await database;
    final res = await db.rawQuery
      ("SELECT * FROM Employee");
      // ("SELECT * FROM Address");
      // ("SELECT e.Uid, a.Uid  FROM Employee, Address  INNER JOIN Uid on Employee.Uid= Address.uid");
      // ("SELECT EMPLOYEE.Uid,Address.Uid FROM EMPLOYEE Natural JOIN Address");
    List<Employee> list =
    res.isNotEmpty ? res.map((c) => Employee.fromJson(c)).toList() : [];

    return list;
  }






}




