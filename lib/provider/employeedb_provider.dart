// import 'dart:html';
import 'dart:io';
import 'package:flutter/cupertino.dart';
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
    final path = join(documentsDirectory.path, 'employee_manager.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate:  (Database db, int version) async {
          await db.execute('CREATE TABLE Employee('
              'id INTEGER PRIMARY KEY,'
              'email TEXT,'
              'username TEXT,'
              'name TEXT,'
              'phone TEXT,'
              'website TEXT'
              ')');
          await db.execute('CREATE TABLE Address('
              'adrs_id INTEGER,'
              'street TEXT,'
              'suite TEXT,'
              'city TEXT,'
              'zipcode TEXT,'
              'FOREIGN KEY(adrs_id) REFERENCES Employee(id)'
              ')');
          await db.execute('CREATE TABLE Company('
              'c_id INTEGER,'
              'c_name TEXT,'
              'catchPhrase TEXT,'
              'bs TEXT,'
              'FOREIGN KEY(c_id) REFERENCES Employee(id)'

         ')');
        });
  }

  createEmployee(Employee newEmployee) async {
    await deleteAllEmployees();
    final db = await database;
    final res = await db.insert('Employee', {
      'id':newEmployee.id,
      'email':newEmployee.email,
      'username':newEmployee.username,
      'name':newEmployee.name,
      'phone':newEmployee.phone,
      'website':newEmployee.website
    });

    Address newAddress = newEmployee.address;
    final addressResult = await db.insert('Address', {
      'adrs_id':newEmployee.id,
      'street':newAddress.street,
      'suite':newAddress.suite,
      'city':newAddress.city,
      'zipcode':newAddress.zipcode,
    });

    Company newCompany =newEmployee.company;
    final CompanyRes = await db.insert('Company', {
      'c_id':newEmployee.id,
      'c_name':newCompany.c_name,
      'catchPhrase':newCompany.catchPhrase,
      'bs':newCompany.bs
    });
  }

  Future<int> deleteAllEmployees() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Employee');
    return res;
  }



  //
  // Future<int> update(Map<String, dynamic> row)async{
  //     Database db =await db.database;
  //     int id =row[id];
  //     return await db.update(table, row, where: '$id=?', whereArgs:[id]);
  //
  //   }

  Future<List<Employee>> getAllEmployees() async {
    final db = await database;
        final res = await db.rawQuery( "SELECT Employee.id,"
            "Employee.name,"
            "Employee.username,"
            "Employee.email,"
            "Employee.phone,"
            "Employee.website,"
            "Address.street,"
            "Address.suite,"
            "Address.city,"
            "Address.zipcode,"
            "Company.c_name,"
            "Company.catchPhrase,"
            "Company.bs"
            " FROM Employee INNER JOIN Address on (Employee.id=Address.adrs_id)"
            " INNER JOIN Company on (Employee.id=Company.c_id)"

        // +"AND" + "INNER JOIN Employee.id=Company.cid"
    );
    List<Employee> list =
    res.isNotEmpty ? res.map((c) {
      final employee = Employee.fromJson(c);
      employee.address = Address.fromJson(c);
      employee.company=Company.fromJson(c);
      return employee;
    }).toList() : [];
    return list;
  }
/// update from data base table
//   Future<int> update(Employee user) async {
//
//     var db = await database;
//
//     final res = await db.update('Employee',
//         {
//       'id': user.id,
//       'email': user.email,
//       'username': "sky-cliff",
//       'name': user.name,
//       'phone': user.phone,
//
//     },
//         conflictAlgorithm: ConflictAlgorithm.replace,
//         where: "id = ?", whereArgs: [user.id]);
//     print("data will be updated");
//     return res;
//   }
  Future<int> update() async {
    final db = await database;
    final res = await db
        .rawUpdate("UPDATE Employee SET name = 'Veeru' WHERE id = 2");
    print(res);
    print("data will be  update");
    return res;
  }


}




