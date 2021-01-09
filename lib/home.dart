import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'game_card.dart';
import 'package:http/http.dart' as http;
import 'package:paging/paging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

String cursor = "";
class HomePage extends StatefulWidget{
  String username;
  HomePage(String username){
    this.username = username;
  }
  _HomePageState createState() => _HomePageState(username);
}

class _HomePageState extends State<HomePage> {
  String username;
  _HomePageState(String username){
    this.username = username;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Flyingwolf', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: Icon(Icons.logout, color: Colors.black),
          tooltip: "Press to logout.",
          onPressed: () async{
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString("username", null);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage()),
            );
          },
        ),
      ),*/
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          FutureBuilder<LinkedHashMap<String, dynamic>>(
            future: fetchUserDetails(username),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                return Column(
                  children: <Widget>[
                    SizedBox(height: 30),
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.logout, color: Colors.black),
                          tooltip: "Press to logout.",
                          onPressed: () async{
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setString("username", null);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => MyHomePage()),
                            );
                          },
                        ),
                        Text(snapshot.data['display_name'], style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: Icon(Icons.logout, color: Colors.white),
                          tooltip: "Press to logout.",
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                    Container(
                      margin: EdgeInsets.all(20),
                      child: Row(
                        children: <Widget>[
                          ClipRRect(
                              borderRadius: BorderRadius.circular(28.0),
                              child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: NetworkImage(
                                    snapshot.data['profile_pic']
                                  )
                              )
                          ),
                          SizedBox(width: 30),
                          Column(
                            children: <Widget>[
                              Text(snapshot.data['name'], style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold)),
                              SizedBox(height: 20),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(width: 2, color: Colors.blue)
                                ),
                                width: 150,
                                height: 40,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(snapshot.data['elo_rating'].toString(), style: TextStyle(color: Colors.blue,
                                        fontSize: 22)),
                                    Text("Elo Rating")
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(left: 25, right: 25),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 120,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    bottomLeft: Radius.circular(20)),
                                gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [Color(0xffeca700), Color(0xffe37600)]),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(snapshot.data['played'].toString(),
                                      style: TextStyle(fontSize: 22, color: Colors
                                          .white)),
                                  SizedBox(height: 10),
                                  Center(
                                      child: Text(
                                        'Tournaments Played',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white),
                                      )
                                  )
                                ],
                              ),
                            ),
                            Container(
                                width: 120,
                                height: 100,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [Color(0xffa053bc), Color(0xff452497)]),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(snapshot.data['won'].toString(),
                                        style: TextStyle(fontSize: 22, color: Colors
                                            .white)),
                                    SizedBox(height: 10),
                                    Text(
                                      'Tournaments Won',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                )
                            ),
                            Container(
                                width: 120,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20)),
                                  gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [Color(0xffef7e4e), Color(0xffec5243)]),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(((snapshot.data['played']/snapshot.data['won'])*10).toInt().toString()+"%",
                                        style: TextStyle(fontSize: 22, color: Colors
                                            .white)),
                                    SizedBox(height: 10),
                                    Text(
                                      'Winning percentage',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                )
                            ),
                          ],
                        )
                      )
                    )
                  ],
                );
              }
              return Center(
                child: Container(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          ),
          SizedBox(height: 20),
          Container(
              margin: EdgeInsets.fromLTRB(25, 0, 0, 0),
              child: Row(
                children: <Widget>[
                  Text("Recommended for you", style: TextStyle(
                      fontSize: 26, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left)
                ],
              )
          ),
          SizedBox(height: 20),
          Expanded(
            child: Pagination(
                pageBuilder: (currentListSize) => fetchGameData(currentListSize),
                itemBuilder: (index, item) => GameCard(item['url'], item['name'], item['game_name'])
            ),
          )
        ],
      ),
    );
  }
}

Future<List<dynamic>> fetchGameData(int previousCount) async{
  if(previousCount < 10){
    var response = await http.get("http://tournaments-dot-game-tv-prod.uc.r.appspot.com/tournament/api/tournaments_list_v2?limit=10&status=all");
    LinkedHashMap<String, dynamic> body = jsonDecode(response.body);
    List<dynamic> list = body['data']['tournaments'];
    cursor = body['data']['cursor'];
    List<dynamic> returnList = new List();
    for(var content in list){
      HashMap<String, String> map = new HashMap();
      map["name"] = content["name"];
      map["game_name"] = content["game_name"];
      map["url"] = content["cover_url"];
      returnList.add(map);
    }
    return returnList;
  }
  else{
    var response = await http.get("http://tournaments-dot-game-tv-prod.uc.r.appspot.com/tournament/api/tournaments_list_v2?limit=10&status=all&cursor="+cursor);
    LinkedHashMap<String, dynamic> body = jsonDecode(response.body);
    List<dynamic> list = body['data']['tournaments'];
    cursor = body['data']['cursor'];
    List<dynamic> returnList = new List();
    for(var content in list){
      HashMap<String, String> map = new HashMap();
      map["name"] = content["name"];
      map["game_name"] = content["game_name"];
      map["url"] = content["cover_url"];
      returnList.add(map);
    }
    return returnList;
  }
}

Future<LinkedHashMap<String, dynamic>> fetchUserDetails(String username) async {
  var response = await http.get("https://677393c0-223c-47b0-8683-474bb75ad7ff.mock.pstmn.io/user_details/"+username);
  LinkedHashMap<String, dynamic> body = jsonDecode(response.body);
  return body;
}
//name, cover_url, game_name.
