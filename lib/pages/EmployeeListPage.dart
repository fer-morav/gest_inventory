import 'package:flutter/material.dart';
import 'package:gest_inventory/components/AppBarComponent.dart';
import 'package:gest_inventory/components/ButtonMain.dart';
import 'package:gest_inventory/components/UserComponent.dart';
import 'package:gest_inventory/utils/strings.dart';

import '../data/framework/FirebaseAuthDataSource.dart';
import '../data/framework/FirebaseUserDataSource.dart';
import '../data/models/User.dart';
import '../utils/colors.dart';
import '../utils/routes.dart';

class EmployeeListPage extends StatefulWidget {
  const EmployeeListPage({Key? key}) : super(key: key);

  @override
  State<EmployeeListPage> createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  final FirebaseAuthDataSource _authDataSource = FirebaseAuthDataSource();
  final FirebaseUserDataSouce _userDataSource = FirebaseUserDataSouce();

  String? businessId;
  late Stream<List<User>> _listUserStream;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _getArguments();
      _listUserStream = _userDataSource.getUsers(businessId!).asStream();
      //_listUsers();
    });
    super.initState();
  }

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(
        textAppBar: title_list_employee,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: isLoading
          ? waitingConnection()
          : StreamBuilder<List<User>>(
              stream: _listUserStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return hasError("Error de Conexion");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return waitingConnection();
                }
                if (snapshot.data!.isEmpty) {
                  return hasError("Lista Vacia");
                }
                if (snapshot.hasData) {
                  return _component(snapshot.data!);
                }

                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () => _nextScreen(register_employees_route),
        child: Icon(Icons.add),
      ),
    );
  }

  void _getArguments() {
    final args = ModalRoute.of(context)?.settings.arguments as Map;
    if (args.isEmpty) {
      Navigator.pop(context);
      return;
    }
    businessId = args["args"];
    setState(() {
      isLoading = false;
    });
  }

  void _nextScreen(String route) {
    Navigator.pushNamed(context, route);
  }

  void _nextScreenArgs(String route, User user) {
    final args = {"args": user};
    Navigator.pushNamed(context, route, arguments: args);
  }

  Widget _component(List<User> users) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (contex, index) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: UserComponent(
            user: users[index],
          ),
        );
      },
    );
  }

  Center waitingConnection() {
    return Center(
      child: SizedBox(
        child: CircularProgressIndicator(
          strokeWidth: 5,
        ),
        width: 75,
        height: 75,
      ),
    );
  }

  Center hasError(String text) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
