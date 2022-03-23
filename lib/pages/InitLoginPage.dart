import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gest_inventory/components/AppBarComponent.dart';
import 'package:gest_inventory/components/ButtonMain.dart';
import 'package:gest_inventory/utils/strings.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';

import 'package:gest_inventory/data/models/User.dart';
import 'package:gest_inventory/data/framework/FirebaseAuthDataSource.dart';
import 'package:gest_inventory/data/framework/FirebaseUserDataSource.dart';

class InitLoginPage extends StatefulWidget {
  const InitLoginPage({Key? key}) : super(key: key);

  @override
  State<InitLoginPage> createState() => _InitLoginPageState();
}
class _InitLoginPageState extends State<InitLoginPage> {

  String correo = "";
  String contrasena = "";
  String id = "";
  String idNegocio = "";
  String cargo = "";
  String nombre = "";
  String apellidos = "";
  int telefono = 0;
  double Salario = 0.0;

  final _padding = const EdgeInsets.only(
    left: 30,
    top: 10,
    right: 30,
    bottom: 10,
  );

    User newUser = User(
    id: "",
    idNegocio: "",
    cargo: "",
    nombre: "",
    apellidos: "",
    telefono: 0,
    salario: 0.0,
  );

  late final FirebaseAuthDataSource _authDataSource = FirebaseAuthDataSource();
  late final FirebaseUserDataSouce _userDataSouce = FirebaseUserDataSouce();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBarComponent(
          textAppBar: title_login,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        body: ListView(
          children: [

            TextField(
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                  labelText: 'ID negocio',
                  contentPadding: EdgeInsets.all(15)
              ),
              onChanged: (text) {
                print("First text field: $text");
                idNegocio = text;
              },
            ),

            TextField(
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                  labelText: 'Nombre',
                  contentPadding: EdgeInsets.all(15)
              ),
              onChanged: (text) {
                print("First text field: $text");
                nombre = text;
              },
            ),

            TextField(
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                  labelText: 'Apellidos',
                  contentPadding: EdgeInsets.all(15)
              ),
              onChanged: (text) {
                print("First text field: $text");
                apellidos = text;
              },
            ),

            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: 'Telefono',
                  contentPadding: EdgeInsets.all(15)
              ),
              onChanged: (text) {
                if(text == ""){
                  text = "0";
                }
                print("First text field: $text");
                telefono = int.parse(text);
              },
            ),

        MultiSelect(
            cancelButtonText: "Cancelar",
            saveButtonText: "Guardar",
            clearButtonText: "Reiniciar",
            titleText: "Roles",
            checkBoxColor: Colors.blue,
            selectedOptionsInfoText: "",
            hintText: "Cargo",
            maxLength: 1,
            dataSource: const [
              {"cargo": "Empleado", "code": "Empleado"},
              {"cargo": "Administrador", "code": "Administrador"},
            ],
            textField: 'cargo',
            valueField: 'code',
            filterable: true,
            required: true,
            onSaved: (value) {
              print('The saved values are $value');
              cargo = value.toString();
              print(cargo);
            }),

            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: 'Salario',
                  contentPadding: EdgeInsets.all(15),
              ),
              onChanged: (text) {
                if(text == ""){
                  text = "0";
                }
                print("First text field: $text");
                Salario = double.parse(text);
              },
            ),

            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  contentPadding: EdgeInsets.all(15)
              ),
              onChanged: (text) {
                print("First text field: $text");
                correo = text;
              },
            ),

            TextField(
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  contentPadding: EdgeInsets.all(15)
              ),
              onChanged: (text) {
                print("First text field: $text");
                contrasena = text;
              },
            ),


            Container(
              padding: _padding,
              height: 80,
              child: ButtonMain(
                onPressed: () {
                  if(correo == ""|| contrasena == ""|| nombre == ""|| apellidos == ""|| Salario <= 0 || telefono <= 0 || cargo != "[Empleado]"){
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Informacion incompleta"),
                    ));
                  }else{

                  newUser = User(
                      id: "",
                      idNegocio: idNegocio,
                      cargo: cargo,
                      nombre: nombre,
                      apellidos: apellidos,
                      telefono: telefono,
                      salario: Salario,
                    );
                    _signUp();
                    _signIn();
                  }

                },
                text: button_login_admin,
                isDisabled: true,
              ),
            ),

          ],
        ),
      ),
      onWillPop: () => exit(0),
    );
  }

  String? _signUp() {
    /* La pantalla de registro donde se implementara esta funcion debe capturar
     del usuario su correo, contraseña para darlo de alta en firebase*/
    String email = correo;
    String password = contrasena;
    //String email = "fer.1998.madrid@gmail.com";
    //String password = "TestPassword";

    String? _userId;
    _authDataSource.signUpWithEmail(email, password).then((id) => {
      _userId = id,
      /* Esta funcion en caso de realizarse con exito la alta del usuario
          * retornara el ID unico que firebase le otorgo automaticamente*/
      _showToast("Sign up: " + _userId.toString()),
      /* Este id debera ser guardado en un objeto de tipo User junto con
          * toda la infomacion de la que este esta compuesto*/
      _saveChanges(_userId)
    });
    return _userId;
  }

  void _addUser() {
    /* La funcion para agregar usuario nesesitara de un objeto User el cual
    * ya debe tener toda la informacion capturada del usuario, este objeto sera
    * cargado en Cloud Firestore*/
    _userDataSouce.addUser(newUser).then((value) => {
      _showToast("Add user: " + value.toString()),
    });
  }

  void _saveChanges(String? id) {
    newUser.id = id ?? "";
    _addUser();
  }


  String? _signIn() {
    /* Los siguientes valores seran remplazados por los datos de email y
    * contraseña capturados del usuario, si el usuario ya registro sus
    * credenciales podra iniciar sesion sin problemas*/

    String email = correo;
    String password = contrasena;
    //String email = "fer.1998.madrid@gmail.com";
    //String password = "TestPassword";

    String? _userId;
    _authDataSource.signInWithEmail(email, password).then((id) =>
    {_userId = id,
      _showToast("Sign in: " + _userId.toString()),
    });
    return _userId;
  }

  void _showToast(String content) {
    final snackBar = SnackBar(
      content: Text(
        content,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}



