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
                'cid INTEGER,'
              'name TEXT,'
              'catchPhrase TEXT,'
              'bs TEXT,'
              'FOREIGN KEY(adrs_id) REFERENCES Employee(id)'

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
      'cid':newEmployee.id,
      'name':newCompany.name,
      'catchPhrase':newCompany.catchPhrase,
      'bs':newCompany.bs
    });
  }

  Future<int> deleteAllEmployees() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Employee');
    return res;
  }


  Future<List<Employee>> getAllEmployees() async {
    final db = await database;
    // final res =await db.query("SELECT * FROM Employee");
    final res = await db.rawQuery("SELECT Employee.id,"
        "Employee.name,"
        "Employee.username,"
        "Employee.email,"
        "Employee.website,"
        "Address.street,"
        "Address.suite,"
        "Address.city,"
        "Address.zipcode,"
        "Company.name,"
        "Company.bs"
        "FROM Employee INNER JOIN Address on (Employee.id=Address.adrs_id) INNER JOIN Company on (Employee.id=Company.cid)"

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

  // void update() async {
  //   Map<String, dynamic> row = {
  //     DBProvider._database: int.parse('${this.db.text}'),
  //   };
  //   final rowAffected = await DBProvider._update(row);
  //   print('updated $rowAffected row(s)');
  // }
}




