import 'package:dio/dio.dart';
import 'package:mission_mangal/model/employee_model.dart';
import 'employeedb_provider.dart';

class EmployeeApiProvider {
  Future<List<Employee>> getAllEmployees() async {
    var url = "https://jsonplaceholder.typicode.com/users";
    Response response = await Dio().get(url);

    return (response.data as List).map((employee) {
      print('Inserting $employee');
      DBProvider.db.createEmployee(Employee.fromJson(employee));
    }).toList();
  }
}