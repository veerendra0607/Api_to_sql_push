import 'dart:convert';
List<Employee> employeeFromJson(String str) =>
    List<Employee>.from(json.decode(str).map((x) => Employee.fromJson(x)));

String employeeToJson(List<Employee>data) =>
    json.encode(List<dynamic>.from(data.map((x)=> x.toJson())));
class Employee
{
  int id;
  String email;
  String username;
  String name;

  Employee(
      {
        this.id,
        this.email,
        this.username,
        this.name

      }
      );

  factory Employee.fromJson(Map<String,dynamic>json) => Employee(
    id: json["id"],
    email: json["email"],
    username: json["username"],
    name: json["name"],
  );

  Map<String,dynamic>toJson() =>
      {
        "id":id,
        "email":email,
        "username":username,
        "name":name,
      };


}

