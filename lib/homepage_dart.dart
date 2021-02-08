import 'package:flutter/material.dart';
import 'package:mission_mangal/provider/employee_api_provider.dart';
import 'package:mission_mangal/provider/employeedb_provider.dart';
class Employ extends StatefulWidget {
  const Employ ({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Employ> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Api to SQFlite'),
        centerTitle: true,
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 10.0, left: 65),
            child: IconButton(
              icon: Icon(Icons.settings_input_antenna),
              onPressed: () async {
                await _loadFromApi();
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await _deleteData();
              },
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : _buildEmployeeListView(),
    );
  }

  _loadFromApi() async {
    setState(() {
      isLoading = true;
    });
    var apiProvider = EmployeeApiProvider();
    await apiProvider.getAllEmployees();
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isLoading = false;
    });
  }

  _deleteData() async {
    setState(() {
      isLoading = true;
    });
    await DBProvider.db.deleteAllEmployees();
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });
    print('All employees deleted');
  }

  _buildEmployeeListView() {
    return FutureBuilder(
      future: DBProvider.db.getAllEmployees(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.separated(
            separatorBuilder: (context, index) =>
                Divider(
                  color: Colors.black12,
                ),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                shadowColor: Colors.blue,
                color: Colors.teal,
                elevation: 50,
                child:
                  ListTile(
                    // onTap: (){
                    //   update();
                    // },
                      title:Text("Name: ${snapshot.data[index].name}"),
                  leading: Text("id: ${snapshot.data[index].id}"),
                  subtitle:Text("User Name: ${snapshot.data[index].username}"),
                    trailing: Column(children: [
                    Text("Website: ${snapshot.data[index].website}"),
                    Text("city: ${snapshot.data[index].address.city}"),
                    // Text("name:${snapshot.data[index].Company.name}"),
                    Text("zipcode: ${snapshot.data[index].address.zipcode}"),
                      // Text("street: ${snapshot.data[index].address.street}"),
                  ],),)
              );
            },
          );
        }
      },
    );
  }
  // void update() async {
  //   Map<String, dynamic> row = {
  //     DBProvider.id: int.parse('${this.id.toString()}'),
  //     DBProvider.name: '${this.name.toString()}',
  //
  //   };
  //   final rowAffected = await DBProvider.update(row);
  //   print('updated $rowAffected row(s)');
  // }
}