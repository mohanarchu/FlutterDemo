import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'  as http;
import 'package:http/http.dart';
import 'package:myapp/Congig.dart';
import 'package:myapp/createstory.dart';
import 'package:myapp/imagefile.dart';
import 'package:myapp/uploadFile.dart';
import 'package:video_player/video_player.dart';
import 'package:myapp/post.dart';
import 'package:myapp/getters/cubelist.dart';
import 'package:async_loader/async_loader.dart';

class myposts extends StatefulWidget
{
  @override
  post createState() => post();

}
class post extends State<myposts> {
  List list = new List();
  List<cubelist> cubes=new List();
  var isLoading = false;
  List<Imagelist> imagea;
  final GlobalKey<AsyncLoaderState> _asyncLoaderState =
  new GlobalKey<AsyncLoaderState>();
  final List<String> popupRoutes = <String>[
    "Properties", "Delete", "Leave"
  ];
  var posttext = new Text(" Posted a ", style: new TextStyle(color: Colors.black38),);
  String selectedPopupRoute = "Properties";
  Future<List<Postss>> _fetchDatas() async
  {
    final ress = await http.get(Config.POSTS); // get api call
    String output, mydata;
    var resBody = {};
    String response = ress.body;


    var res = json.decode(response);
    output = res['Output'];
    //  print(output);

    if (output.contains("True")) {
      list = res['Response'];
      List<Postss> postss = createPost(list);
      return postss;
    }
    else {
      String msg = res['Message'];
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text(msg),
      ));
    }
    return null;
  }


  Future<List<cubelist>> mycube() async
  {
    final ress = await http.get(Config.CUBE_LIST); // get api call
    String output, mydata;
    var resBody = {};
    String response = ress.body;


    var res = json.decode(response);
    output = res['Output'];

    if (output.contains("True")) {
      list = res['Response'];
      cubes = list.map((i)=> cubelist.fromjson(i)).toList();

    }
    else
    {
      String msg = res['Message'];
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text(msg),
      ));
    }
  }
  void _showPopupMenu3(BuildContext context)
  {
    showMenu<String>(
      context: context,
      initialValue: selectedPopupRoute,
      position: new RelativeRect.fromLTRB(100.0, 0.0, 0.0, 500.0),
      items: popupRoutes.map((String popupRoute)
      {
        return new PopupMenuItem<String>(
          child: new
          ListTile(
              leading: const Icon(Icons.visibility),
              title: new Text(popupRoute),
              onTap: ()
              {
                setState(() {
                  dispose();
                });

                selectedPopupRoute = popupRoute;
                switch(popupRoute) {
                  case "Delete":
                    Scaffold.of(context).showSnackBar(new SnackBar(
                      content: new Text("hello"),
                    ));
                }
              }
          ),
          value: popupRoute,
        );
      }).toList(),
    );
  }

  List<Postss> createPost(List data) {
    String images, file_type;
    imagea = new List();
    List<Postss> list = new List();
    for (int i = 0; i < data.length; i++) {
      String title = data[i]["User_Image"];
     // String cube_ids = data[i]["Cubes_Id"];
      String post_text = data[i]["Post_Text"];
      String Post_Category = data[i]["Post_Category"];
      String posterPath = data[i]["User_Name"];
      String backdropImage = data[i]["Time_Ago"];
      List attachments = data[i]["Attachments"];
      print(post_text+Post_Category);

      imagea = attachments.map((j) =>
          Imagelist.fromJson(j)).toList();
      Postss postsss = new Postss(title, posterPath, backdropImage, imagea,post_text,Post_Category);
      list.add(postsss);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: Scaffold(

        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.create, color: Colors.deepOrange),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> discovercubes() )),
          ),
          title: Text('posts'),
        ),
        body: new Container(
          child: Column(

            children: <Widget>[
           new Container(
                height: 30.0,

                  color: Colors.deepOrangeAccent,
                    
                    child: new Align(
                      alignment: Alignment.topLeft,
                      child: new GestureDetector(
                        onTap: ()
                            {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> createstory()));
                            }
                            ,
                        child: new Text("Share a story",
                          style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ),

              new Expanded(child: new Container(
              child:  FutureBuilder(
                  future: _fetchDatas(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List> snapshot) {
                    if (!snapshot.hasData)
                      // Shows progress indicator until the data is load.
                      return new MaterialApp(
                          home: new Scaffold(
                            body: new Center(
                              child: new CircularProgressIndicator(),
                            ),
                          )
                      );
                    // Shows the real data with the data retrieved.
                    List movies = snapshot.data;
                    return new ListView(
                      children: createMovieCardItem(movies, context),
                    );
                  }
              ),
              )
              )
            ],

          )
        )
      ),
    );
  }

  List<Widget> createMovieCardItem(List<Postss> posts, BuildContext context)
  {
    List<Widget> listElementWidgetList = new List<Widget>();
    if (posts.length != null) {
      var lenth = posts.length;
      for (int i = 0; i < lenth; i++) {
        Postss postss = posts[i];
        Widget widget = new Container(
          height: 50.0,
          margin: const EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              new Expanded(child: Row(
                children: [
                  new GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => upload()),
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.deepOrange,
                      backgroundImage: NetworkImage(
                          Config.USER_IMAGES + postss.Images),
                    ),
                  ),
                  Expanded(child: Container(
                    margin: const EdgeInsets.only(left: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(postss.User_Name+ " Posted a " + postss.postcategory ,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,

                                  fontSize: 12.0
                              ),
                            ),
                            Text(postss.Time_Ago,
                              style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 10.0
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ),
                ],
              ),
                flex: 2,
              ),
              Expanded(child:
              new Container(
                height: 50.0,
                child: Column(
                  children: [
                 Expanded(
                     child: new Align(
                       alignment: Alignment.topRight,
                       child:  new GestureDetector(
                         onTap: ()
                             {
                               _showPopupMenu3(context);
                               print("clicked");
                             },
                         child:

                         Icon(Icons.more_horiz,
                           color: Colors.deepOrange,
                         ),
                       )
                     ),
                    flex: 1,

                    ),
                 Expanded(
                     child: new Align(
                       alignment: Alignment.bottomRight,
                       child:
                         ListView.builder(
                                 scrollDirection: Axis.horizontal,
                                 itemCount: cubes.length,
                                 itemBuilder:
                                     (context, int index)

                                   {
                                     print(cubes);
                                   return new Expanded(

                                       child: new Column(
                                         crossAxisAlignment: CrossAxisAlignment.center,
                                         children: <Widget>[
                                           new GestureDetector(

                                             child:   new CircleAvatar(

                                               backgroundImage: NetworkImage(

                                                   Config.CUBE_IMAGE +   cubes[index].image),
                                                radius: 10.0,
                                             ),
                                             onTap: ()
                                             {

                                             },
                                           ),

                                         ],
                                       )

                                   );
                                 }
                             )
                             )



                 ),
                  ],
                ),
              ),
                flex: 2,
              )

            ],
          )

        );
          var column = new Column(
            children:  <Widget>[
              widget,
           postss.attachments.length != 0 ?
                new Container(
                  height: 200.0,

                    margin: new EdgeInsets.only(left: 16.0, right: 16.0),
                color: Colors.white,
                child: new GestureDetector(
                  onTap: (){
                    print(("clicked"));
                    },
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: postss.attachments.length,
                      itemBuilder: (context, int index)
                      {
                        return new UserWidget(imageURL: Config.ATTACHMENTS +
                            postss.attachments[index].filename,
                          imageType: postss.attachments[index].filetype,


                        );
                      }
                  ),
                )
               ):new Container(),

            ],
          );
          listElementWidgetList.add(column);
        }
        return listElementWidgetList;
      }

    }

  }
class UserWidget extends StatelessWidget
{
  final String imageURL;
  final String imageType;
  const UserWidget  ({Key key, this.imageURL,this.imageType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
 //   print(this.imageType);
    VideoPlayerController playerController;
    VoidCallback listener;
    Widget play=new Icon(Icons.play_arrow);
    Widget pause=new Icon(Icons.pause);
    FadeAnimation imageFadeAnim =
    new FadeAnimation(child: const Icon(Icons.play_arrow, size: 100.0));


    return  this.imageType.contains("Image") ? new Container(
      height: 200.0,
      child: new Card(
          child: new Column(
            children: <Widget>[
             new GestureDetector(
               onTap: ()
                 {


                 },
          child:

        Image.network(imageURL,
            fit: BoxFit.cover,
          height: 190.0,
          width: 200.0,

          ),
             )
            ],
          )
      ),
    ): this.imageType.contains("Video") ?
    new Container(
      height: 100.0,
      child: AspectRatio(aspectRatio: 16/9,
         child: GestureDetector(
             onTap: ()
             {
                  playerController.initialize();
                  playerController.play();

             },
               child:
              VideoPlayer(playerController = VideoPlayerController.network(imageURL)
                ..addListener(listener)
                ..setVolume(1.0)
                ..initialize()
                ,
           )
         )
      )
    ): new
    Container();
  }
}
class FadeAnimation extends StatefulWidget
{
  final Widget child;
  final Duration duration;
  FadeAnimation(
      {this.child, this.duration = const Duration(milliseconds: 500)});
  @override
  _FadeAnimationState createState() => new _FadeAnimationState();
}
class _FadeAnimationState extends State<FadeAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  @override
  void initState() {
    super.initState();
    animationController =
    new AnimationController(duration: widget.duration, vsync: this);
    animationController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    animationController.forward(from: 0.0);
  }
  @override
  void deactivate()
  {
    animationController.stop();
    super.deactivate();
  }
  @override
  void didUpdateWidget(FadeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      animationController.forward(from: 0.0);
    }
  }
  @override
  void dispose()
  {
    animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return animationController.isAnimating
        ? new Opacity(
      opacity: 1.0 - animationController.value,
      child: widget.child,
    )
    : new Container();
  }
}

class Todo {
  final String cubeid;
  Todo(this.cubeid);
}
class discovercubes extends StatefulWidget
{
  @override
 discovercube createState() => discovercube();

}
class discovercube extends State<discovercubes>
{
  bool select = true;
  List cat_id=new List();

List<cubecatlist> cubes;
// discovercube({Key key,@required this.todos}) : super(key : key);
  Future<List<cubecatlist>> discubes() async
  {
    final ress = await http.get(Config.URL +"Cubes/Category_List"); // get api call
    String output, mydata;
    var resBody = {};
    String response = ress.body;
    var res = json.decode(response);
    output = res['Output'];
    print(output);
    if (output.contains("True")) {
     List list = res['Response'];
  //    print(list);
      cubes = list.map((i)=> cubecatlist.fromjson(i)).toList();
      return cubes;
    }
    else
    {
      String msg = res['Message'];
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text(msg),
      ));
    }
  }

@override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "hello",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Hello"),
        ),
        body: FutureBuilder(
            future: discubes(),
            builder: (BuildContext context,AsyncSnapshot<List> response)
            {
              if (response.hasData)
              {

                print("hai");
                return new Container(
                    margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                    child: new GridView.count(crossAxisCount: 3,
                        children: List.generate(cubes.length, (index) {
                          return new GestureDetector(
                            onTap: ()
                            {
                              
                          Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => view(todo: cubes[index].id)
                                ),
                              );

                     print("pressed");

                            },
                            child:  Container(

                              alignment: Alignment.center,
                              height: 100.0,
                              width :  100.0,
                              child :  new Column(
                                  children: <Widget>
                                  [          Expanded(child:
                                    new Container(
                                      child: Image(image: NetworkImage(
                                        Config.CUBE_IMAGE + cubes[index].image,
                                      ),
                                        fit: BoxFit.fitHeight,
                                      ),
                                      height: 90.0,
                                      width: 80.0,
                                      margin: EdgeInsets.fromLTRB(0.0, 0.0,0.0,0.0),
                                    ),
                                      flex: 1,
                                    ),
                                    Expanded(child: new Container(

                                      child: Text(cubes[index].name,
                                        style: new TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black
                                        ),
                                      ),
                                    ),
                                      flex: 1,
                                    ),
                                  ],
                                ),
                              )
                          );
                        })
                    )
                );
              } //
              else
                {
                  return new MaterialApp(
                      home: new Scaffold(
                        body: new Center(
                          child: new CircularProgressIndicator(),
                        ),
                      )
                  );// Shows the real data with the data retrieved)
              }
            }
        )
      ),
    );
  }
}

class Cubes extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
  }
 
}

class view extends StatelessWidget
{
  final String todo;
  Future<bool> _willPopCallback() async
  {

    Navigator.push(context,MaterialPageRoute(builder : (context) => discovercubes()));
    return true; // return true if the route to be popped
  }

  view({Key key, @required this.todo}) : super(key: key);
  @override
  Widget build(BuildContext context) {


    return  new Scaffold(

        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.orange),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text("Cubes view"),
        ),
        body: new Container(
          child: new WillPopScope(child: new Text(todo), onWillPop: _willPopCallback),
        )

      ) ;

  }

}