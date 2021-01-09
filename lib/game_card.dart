import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class GameCard extends StatefulWidget {
  String url;
  String name;
  String game_name;
  GameCard(String url, String name, String game_name){
    this.url = url;
    this.name = name;
    this.game_name = game_name;
  }
  @override
  _GameCardState createState() => _GameCardState(url, name, game_name);
}

class _GameCardState extends State<GameCard> {
  String url;
  String name;
  String game_name;
  _GameCardState(String url, String name, String game_name){
    this.url = url;
    this.name = name;
    this.game_name = game_name;
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 150,
      margin: EdgeInsets.fromLTRB(25, 10, 25, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
        ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
          child : Image.network(
            url,
            width: 370,
          ),
        ),

        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 60,
              width: 370,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(12), bottomLeft: Radius.circular(12))
              ),
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,), textAlign: TextAlign.left, overflow: TextOverflow.ellipsis),
                  Text(game_name, textAlign: TextAlign.left)
                ],
              ),
            ),
          )
        )
        ],
      ),
    );
  }
}

