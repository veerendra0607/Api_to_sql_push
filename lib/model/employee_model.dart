import 'dart:convert';
List<Employee> employeeFromJson(String str) =>
    List<Employee>.from(json.decode(str).map((x) => Employee.fromJson(x)));

String employeeToJson(List<Employee>data) =>
    json.encode(List<dynamic>.from(data.map((x)=> x.toJson())));


List<Address> addressFromJson(String str) =>
    List<Address>.from(json.decode(str).map((x) => Address.fromJson(x)));

String addressToJson(List<Employee>data) =>
    json.encode(List<dynamic>.from(data.map((x)=> x.toJson())));


class Employee
{
  int id;
  String email;
  String username;
  String name;
  Address address;

  Employee(
      {
        this.id,
        this.email,
        this.username,
        this.name,
        this.address,

      }
      );

  factory Employee.fromJson(Map<String,dynamic>json) => Employee(
    id: json["id"],
    email: json["email"],
    username: json["username"],
    name: json["name"],
      address:
      json['address'] != null ? new Address.fromJson(json['address']) : null,
  );

  Map<String,dynamic>toJson() =>
      {
        "id":id,
        "email":email,
        "username":username,
        "name":name,
        // "address":address,
      };


}
class Address
{
  int Uid;
  String street;
  String suite;
  String city;

  Address(
      {
        this.Uid,
        this.street,
        this.suite,
        this.city

      }
      );

  factory Address.fromJson(Map<String,dynamic>json) => Address(
    Uid: json["Uid"],
    street: json["street"],
    suite: json["suite"],
    city: json["city"],
  );

  Map<String,dynamic>toJson() =>
      {
        "Uid":Uid,
        "email":street,
        "suite":suite,
        "city":city,
      };


}


