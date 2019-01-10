
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:http/http.dart'  as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:myapp/Congig.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/getters/cubelist.dart';
import 'package:myapp/getters/cubelist.dart';
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multiple_image_picker/flutter_multiple_image_picker.dart';
class upload extends StatefulWidget
{
  @override
  myupload createState() =>new myupload();

}
BuildContext context;
class myupload extends State<upload>  with TickerProviderStateMixin
{
  final JsonDecoder _decoder = new JsonDecoder();
  List cubearray=new List();
  List  jsonarrays  = new List();
  List list = new List();
  List imageList  = new List();
  List<cubelist> cubes=new List();
  bool selected= false;
  String jsonstring;
  List<File> attachments= new List();

  Future<http.Response> mycube() async
  {
    final ress = await http.get(Config.CUBE_LIST); // get api call
    String output, mydata;
    var resBody = {};
    String response = ress.body;


    var res = json.decode(response);
    output = res['Output'];
    //  print(output);
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

  final mytext = TextEditingController();
  bool _visble= true;
  int _angle = 90;
  bool _isRotated = true;
  File video_file ;
  AnimationController _controller;
  Animation<double> _animation;
  Animation<double> _animation2;
  Animation<double> _animation3;

  @override
  void initState() {
   
    _controller = new AnimationController (
      vsync : this,
      duration: const Duration(milliseconds: 180),
    );

    _animation = new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.0, 1.0, curve: Curves.linear),
    );

    _animation2 = new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.5, 1.0, curve: Curves.linear),
    );

    _animation3 = new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.8, 1.0, curve: Curves.linear),
    );
    _controller.reverse();
    super.initState();
    listener = () {
      setState(() {});
    };

  }
  String _platformMessage = 'No Error';
  List images;
  int maxImageNo = 10;
  bool selectSingleImage = false;

  Future<File> _imageFile;
  bool isVideo = false;
  File files;
  VideoPlayerController play_controller;
  VoidCallback listener;
  @override
  void dispose() {
    if (_controller != null) {
      _controller.dispose();
    }
    super.dispose();
  }
  void _onImageButtonPressed(ImageSource source) {
    setState(() {
      if (play_controller != null) {
        play_controller.setVolume(0.0);
        play_controller.removeListener(listener);
      }
      if (isVideo)
      {
        ImagePicker.pickVideo(source: source).then((video_file) {

          if ( video_file!= null && mounted) {
            setState(() {
              play_controller = VideoPlayerController.file(video_file)
                ..addListener(listener)
                ..setVolume(1.0)
                ..initialize()
                ..setLooping(true)
                ..play();
            });
          }
        });
      }
      else
      {
       _imageFile =  ImagePicker.pickImage(source: source);

      }
    });
  }

  initMultiPickUp() async {
    setState(() {
      images = null;
      _platformMessage = 'No Error';
    });
    List resultList;
    String error;

    try
    {
      resultList = await FlutterMultipleImagePicker.pickMultiImages
        (
          maxImageNo, selectSingleImage);
    } on PlatformException catch (e) {
      error = e.message;
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
      if (error == null) _platformMessage = 'No Error Dectected';
    });
  }
  void upload() async
{
  var multipartFile;
  var uri = Uri.parse( Config.URL + "Posts/Cube_Post_Submit");
  var request = new http.MultipartRequest("POST", uri);
 for(int i=0;i<images.length;i++)
    {
      print(File(images[i]));
      var stream = new http.ByteStream(DelegatingStream.typed(File(images[i]).openRead()));
      var length = await File(images[i]).length();
      multipartFile  = new http.MultipartFile('attachments', stream, length,
          filename: basename(File(images[i]).path));
    }
  request.fields['User_Id'] = Config.USER_ID;
  request.fields['Cubes_Id'] = jsonstring;
  request.fields['Post_Text'] ="hello";
  request.fields['Post_Category'] = "Story";
  request.fields['Post_Link'] = "";
  //contentType: new MediaType('image', 'png'));
  request.files.add(multipartFile);
  var response = await request.send();
  print(response.statusCode);
  response.stream.transform(utf8.decoder).listen((value)
  {
    print(value);
  });
 }
  Future getImage() async
  {
    setState(() async
    {


 //     _image = image;
      _imageFile = ImagePicker.pickImage(source: ImageSource.gallery);
   //   print(_imageFile);
    });
  }
  Future getVideo() async
  {
    setState(()
    {
    });
  }
  void _rotate(){
    setState((){
      if(_isRotated) {
        _angle = 45;
        _isRotated = false;
        _controller.forward();
      } else {
        _angle = 90;
        _isRotated = true;
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "image",
      home: Scaffold(
          appBar: new AppBar(
            title: Text("Upload image"),

          ),
          body: new Stack(
              children: <Widget>[
                new Positioned(
                    bottom: 200.0,
                    right: 24.0,
                    child: new Container(
                      child: new Row(
                        children: <Widget>[
                          new ScaleTransition(
                            scale: _animation3,
                            alignment: FractionalOffset.center,
                            child: new Container(
                              margin: new EdgeInsets.only(right: 16.0),
                              child: new Text(
                                'Image',
                                style: new TextStyle(
                                  fontSize: 13.0,
                                  fontFamily: 'Roboto',
                                  color: new Color(0xFF9E9E9E),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          new ScaleTransition(
                            scale: _animation3,
                            alignment: FractionalOffset.center,
                            child: new Material(
                                color: new Color(0xFF9E9E9E),
                                type: MaterialType.circle,
                                elevation: 6.0,
                                child: new GestureDetector(
                                  child: new Container(
                                      width: 40.0,
                                      height: 40.0,
                                      child: new InkWell(
                                        onTap: (){
                                          if(_angle == 45.0)
                                          {
                                           //_onImageButtonPressed(ImageSource.camera);
                                          getImage();
                                          }
                                        },
                                        child: new Center(
                                          child: new Icon(
                                            Icons.image,
                                            color: new Color(0xFFFFFFFF),
                                          ),
                                        ),
                                      )
                                  ),
                                )
                            ),
                          ),
                        ],
                      ),
                    )
                ),

                new Positioned(
                    bottom: 144.0,
                    right: 24.0,
                    child: new Container(
                      child: new Row(
                        children: <Widget>[
                          new ScaleTransition(
                            scale: _animation2,
                            alignment: FractionalOffset.center,
                            child: new Container(
                              margin: new EdgeInsets.only(right: 16.0),
                              child: new Text(
                                'Video',
                                style: new TextStyle(
                                  fontSize: 13.0,
                                  fontFamily: 'Roboto',
                                  color: new Color(0xFF9E9E9E),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          new ScaleTransition(
                            scale: _animation2,
                            alignment: FractionalOffset.center,
                            child: new Material(
                                color: new Color(0xFF00BFA5),
                                type: MaterialType.circle,
                                elevation: 6.0,
                                child: new GestureDetector(
                                  child: new Container(
                                      width: 40.0,
                                      height: 40.0,
                                      child: new InkWell(
                                        onTap: (){
                                          if(_angle == 45.0){
                                            isVideo = true;
                                           _onImageButtonPressed(ImageSource.camera);
                                          }
                                        },
                                        child: new Center(
                                          child: new Icon(
                                            Icons.videocam,
                                            color: new Color(0xFFFFFFFF),
                                          ),
                                        ),
                                      )
                                  ),
                                )
                            ),
                          ),
                        ],
                      ),
                    )
                ),
                new Positioned(
                    bottom: 88.0,
                    right: 24.0,
                    child: new Container(
                      child: new Row(
                        children: <Widget>[
                          new ScaleTransition(
                            scale: _animation,
                            alignment: FractionalOffset.center,
                            child: new Container(
                              margin: new EdgeInsets.only(right: 16.0),
                              child: new Text(
                                'Gallery',
                                style: new TextStyle(
                                  fontSize: 13.0,
                                  fontFamily: 'Roboto',
                                  color: new Color(0xFF9E9E9E),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          new ScaleTransition(
                            scale: _animation,
                            alignment: FractionalOffset.center,
                            child: new Material(
                                color: new Color(0xFFE57373),
                                type: MaterialType.circle,
                                elevation: 6.0,
                                child: new GestureDetector(
                                  child: new Container(
                                      width: 40.0,
                                      height: 40.0,
                                      child: new InkWell(
                                        onTap: (){
                                          if(_angle == 45.0){
                                            isVideo = false;
                                            mycube();
                                          //  _onImageButtonPressed(ImageSource.gallery);
                                          }
                                        },
                                        child: new Center(
                                          child: new Icon(
                                            Icons.store,
                                            color: new Color(0xFFFFFFFF),
                                          ),
                                        ),
                                      )
                                  ),
                                )
                            ),
                          ),
                        ],
                      ),
                    )
                ),
                new Positioned(
                  bottom: 16.0,
                  right: 16.0,
                  child: new Material(
                      color: new Color(0xFFE57373),
                      type: MaterialType.circle,
                      elevation: 6.0,
                      child: new GestureDetector(
                        child: new Container(
                            width: 56.0,
                            height: 56.00,
                            child: new InkWell(
                              onTap: _rotate,
                              child: new Center(
                                  child: new RotationTransition(
                                    turns: new AlwaysStoppedAnimation(_angle / 270),
                                    child: new Icon(
                                      Icons.attach_file,
                                      color: new Color(0xFFFFFFFF),
                                    ),
                                  )
                              ),
                            )
                        ),
                      )
                  ),
                ),

              new Positioned(
                bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  top: 0.0,
                  child:
                  new Column(
                      children: <Widget>[
                  new Container(
                  decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.deepOrange
                  ),
                height: 100.0,
                child: new TextField(
                  controller: mytext,
                  decoration: InputDecoration(

                      border: InputBorder.none,
                      hintText: "Tyepe Something",
                      hintStyle: TextStyle(
                          color: Colors.white
                      )
                  ),
                  maxLength: 164,
                ),
              ),
        new Container(
          height: 100.0,
          child:
          new ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: cubes.length,
                      itemBuilder:

                          (context, int index)
                      {

                            return new Container(
                                height: 80.0,
                                width: 80.0,
                                padding: EdgeInsets.all(10.0),
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                  new GestureDetector(

                                    child:   new CircleAvatar(

                                      radius: 26.0,
                                      backgroundImage: NetworkImage(

                                          Config.CUBE_IMAGE+   cubes[index].image),
                                    ),
                                    onTap: ()
                                        {
                                        jsonstring =   jsonEncode(cubearray);

                                         if(cubearray.contains(cubes[index].id))
                                           {
                                             cubearray.remove(cubes[index].id);

                                           }
                                           else
                                           {
                                               cubearray.add(cubes[index].id);
                                           }
                                        },
                                  ),
                                    new Center(
                                      heightFactor: 1.0,
                                      child: new Text(cubes[index].name,

                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 10.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold

                                        ),
                                      ),
                                    )

                                  ],
                                )


                            );
                          }
          )
        ),


        new  Container(
      padding: const EdgeInsets.all(8.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          images == null
              ? new Container(
            height: 300.0,
            width: 400.0,
            child: new Icon(
              Icons.image,
              size: 250.0,
              color: Theme.of(context).primaryColor,
            ),
          )
              : new SizedBox(
            height: 300.0,
            width: 400.0,
            child: new ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) =>
              new Padding(
                padding: const EdgeInsets.all(5.0),
                child: new Image.file(
                  new File(images[index].toString()),

                ),
              ),
              itemCount: images.length,
            ),
          ),
          new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text('Error Dectected: $_platformMessage'),
          ),
          new RaisedButton.icon(
              onPressed: initMultiPickUp,
              icon: new Icon(Icons.image),
              label: new Text("Pick-Up Images")),
        ],
      ),
    ),

                        new RawMaterialButton(onPressed:()
                        {
                           upload();
                        },
                          child: new Text("Post"),

                        )


                  ]
                ),
              )
              ]
          )
          )
      );
  }
}
class UserWidgets extends StatelessWidget
{
  final String imageURL;
  const UserWidgets  ({Key key, this.imageURL}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    VideoPlayerController playerController;
    VoidCallback listener;



    return  this.imageURL.contains(".jpg")||this.imageURL.contains(".jpeg") ? new Container(
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
                  fit: BoxFit.fill,
                  height: 190.0,
                ),
              )
            ],
          )
      ),
    ): this.imageURL.contains(".mp4")||this.imageURL.contains(".3gp") ?
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

