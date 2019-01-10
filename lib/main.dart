import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:myapp/imagefile.dart';
import 'dart:collection';

import 'package:myapp/newdart.dart';




void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget
{
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {




  @override
  Widget build(BuildContext context) {

    Widget titleSection = Container(
      padding: const EdgeInsets.all(32.0),
      child: Row(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Oeschinen Lake Campground',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'Kandersteg, Switzerland',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.star,
            color: Colors.red[500],
          ),
          Text('41'),
        ],
      ),
    );


    Widget texts = Container(

      margin: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          new GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => myposts()),
              );
            },
           child:  CircleAvatar(
            backgroundColor: Colors.deepOrange,
            backgroundImage: null,
          ),
          ),
          Expanded(child: Container(
            margin: const EdgeInsets.only(left: 5.0,),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text('hello',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0
                ),
              ),
            Text(
              'mohanraj',
              style: TextStyle(
                color: Colors.grey[500],

              ),
            ),
            ],
          ),

               new Container(
                 margin: const EdgeInsets.all(10.0),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.end,
                   children: [
                     Icon(Icons.more_horiz,
                       color: Colors.deepOrange,
                     ),


                   ],

                 ),
               ),
                            ],
          ),
          ),
          ),
      ],
      ),
    );
     Widget listwidget =
          new Container(
            height: 30.0,
            child: new ListView(
              scrollDirection: Axis.horizontal,
              children: new List.generate(100, (int index) {
                return new Card(
                  color: Colors.blue[index * 100],
                  child: new Container(
                    width: 20.0,
                    height: 20.0,
                    child: new Text("$index"),
                  ),
                );
              }),
           ),
         );
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Top Lakes'),
        ),
        body: ListView(
          children: [
            titleSection,
           texts,
          listwidget,
          ],
        ),
      ),
    );
    }
}
