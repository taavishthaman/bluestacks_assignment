import 'dart:collection';

import 'package:bluestacks_assignment/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

/*void main(){
  runApp(MyApp());
}*/

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var username = prefs.getString('username');
  print(username);
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
          home: username == null ? MyApp() : HomePage(username)
      )
  );
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool userValidated = false;
  bool pwdValidated = false;
  bool correctCredentials = true;

  //Two users
  UserPairs user1 = new UserPairs("9898989898", "password123");
  UserPairs user2 = new UserPairs("9876543210", "password123");


  TextEditingController user = TextEditingController();
  TextEditingController pwd = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: height, width: width,
            padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xff452497), Color(0xffa053bc)]),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: 150,
                    height: 150,
                    child: Image.asset(
                      "assets/images/game-tv.png",
                    )
                ),
                SizedBox(height: 40),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    controller: user,
                    decoration: InputDecoration(
                      hintText: "Username",
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                    ),
                    onChanged: (String user){
                      if(user.length >= 3 && user.length <= 11){
                        userValidated = true;
                      }
                      else{
                        userValidated = false;
                      }
                    },
                  ),
                ),
                userValidated ? Text('') : Text("3-11 characters.", style: TextStyle(color: Colors.red)),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    controller: pwd,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Password",
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                    ),
                    onChanged: (String pwd){
                      if(pwd.length >= 3 && pwd.length <= 11){
                        pwdValidated = true;
                      }
                      else{
                        pwdValidated = false;
                      }
                    },
                  ),
                ),
                pwdValidated ? Text('') : Text("3-11 characters.", style: TextStyle(color: Colors.red),),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  height: 60.0,
                  decoration: BoxDecoration(
                    gradient: userValidated && pwdValidated ? LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Color(0xffe37600), Color(0xffeca700)]) :
                    LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.topLeft,
                        colors: [Colors.black12, Colors.black26]
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async{
                        //Authenticate user
                        if((user.text == user1.username && pwd.text == user1.pwd) || (user.text == user2.username && pwd.text == user2.pwd)){
                          //User exists
                          correctCredentials = true;
                          setState(() {});
                          if(userValidated && pwdValidated){
                            //Save user here
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setString('username', user.text);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => HomePage(user.text)),
                            );
                          }
                        }
                        else{
                          //User does not exist
                          correctCredentials = false;
                          setState(() {
                            print("Authentication Failed");
                          });
                        }
                      },
                      child: Center(
                          child: Text('Signin', style: TextStyle(color: Colors.white, fontSize: 22))
                      )),
                  ),
                ),
                correctCredentials ? Text("") : Text("User does not exist!", style: TextStyle(color: Colors.red))
              ],
            )
        ),
      ),
    );
  }
}

//#a053bc  #452497  #e37600 #eca700 #ec5243 #ef7e4e