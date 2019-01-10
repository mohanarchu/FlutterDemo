
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart'  as http;
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/Congig.dart';
import 'package:myapp/getters/cubelist.dart';
import 'package:myapp/imagefile.dart' ;
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_multiple_image_picker/flutter_multiple_image_picker.dart';
import 'package:photo_view/photo_view.dart';
class createstory extends StatefulWidget
{
  @override
 create createState()=> create();
  
}
class create extends State<createstory>
{
  BuildContext context;
  String _platformMessage = 'No Error';
  List<File> image=[];

  String _base64;
  static const Base64Codec base64 = const Base64Codec();
  //List images;

  int maxImageNo = 10;
  bool selectSingleImage = false;
  List resultList;
  List cubearray=new List();
  final myController = TextEditingController();

 List<cubelist> cubes=new List();
 List list;
 String jsonstring;
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

  initMultiPickUp() async {


    String error;
    setState(() {
      //images=null;
    });
    try
    {
      resultList = await FlutterMultipleImagePicker.pickMultiImages(
          maxImageNo, selectSingleImage);
    } on PlatformException catch (e)
    {
      error = e.message;
    }
    if (!mounted) return;
    setState(() {
      for(int i=0;i<resultList.length;i++)
        {
          image.add(File(resultList[i]));
          print( image.toString());
        }

      if (error == null) _platformMessage = 'No Error Dectected';
    });
  }
  Future<File> _imageFile;
  VideoPlayerController play_controller;
  VoidCallback listener;
  bool isVideo = false;
  File files;
  bool _isPlaying = false;
  void _onImageButtonPressed(ImageSource source)
  {
    setState(()
    {
      if (play_controller != null)
      {
        play_controller.setVolume(0.0);
        play_controller.removeListener(listener);

      }
        ImagePicker.pickVideo(source: source).then((File files) {
          if (files != null && mounted) {

            setState(() {

              image.add(File(files.path));


            });
          }
        });
    });
  }


  Future getImage() async
  {
    File _image=  await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {

    try
    {
      image.add(_image);
    }
    catch(e)
     {
     print(e);
     }
    });
  }

  var hint = InputDecoration(
                     border: InputBorder.none,
                           hintText: "share your thoughts");
  void uploads() async
  {
    var multipartFile;
    var uri = Uri.parse( Config.URL + "Posts/Cube_Post_Submit");
    var request = new http.MultipartRequest("POST", uri);
    for(int i=0;i<image.length;i++)
    {
      print(image[i]);
      request.files.add(
        http.MultipartFile(
          'attachments',
          http.ByteStream(DelegatingStream.typed(image[i].openRead())),
          await image[i].length(),
          filename: basename(image[i].path),
        ),
      );
    }
   // request.files.add(multipartFile);
    request.fields['User_Id'] = Config.USER_ID;
    request.fields['Cubes_Id'] = jsonstring;
    request.fields['Post_Text'] =  "hello";
    request.fields['Post_Category'] = "Story";
    request.fields['Post_Link'] = "";
    var response = await request.send();
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value)
    {

      print(value);

    }

    );

  }




  Widget _previewVideo(VideoPlayerController controller) {
    if (controller == null) {
      return const Text(
        'You have not yet picked a video',
        textAlign: TextAlign.center,
      );
    } else if (controller.value.initialized) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: AspectRatioVideo(controller),
      );
    } else {
      return const Text(
        'Error Loading Video',
        textAlign: TextAlign.center,
      );
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: Text("craete story"),
      ),
      body: new Container(

        child: new Column(
          children: <Widget>[
           new Container(
             decoration: BoxDecoration(color: Colors.white12),
                      child: new Row(
               crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Expanded(child:new GestureDetector(
                    child:  new Container(
                      child:  Image (image:new  AssetImage('assets/article.png'),
                        height: 30.0,
                        width: 30.0,
                      ),


                    ),
                    onTap: ()
                    {

                     setState(() {
                       hint = InputDecoration(
                           border: InputBorder.none,
                           hintText: "share your Story");
                     });
                    },
                  ),

                  ),
                  new Expanded(child:new  GestureDetector(
                    child:  new Container(
                      child:  Image (image:new  AssetImage('assets/image/newspaper.png'),
                        height: 30.0,
                        width: 30.0,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        hint = InputDecoration(
                            border: InputBorder.none,
                            hintText: "Share an announcement or News");
                      });
                    },
                  )
                  ),
                  new Expanded(child: new GestureDetector(
                    child: new Container(
                      child:  Image (image:new  AssetImage('assets/image/script (1).png'),
                        height: 30.0,
                        width: 30.0,
                      ),
                    ),
                    onTap:
                    ()

                    {
                    setState(()
                    {
                      hint = InputDecoration
                        (border: InputBorder.none,
                          hintText: "Wrte an orticle or blog");
                    });
                    },
                  )
                  ),
                  new Expanded(child: new GestureDetector(
                    child: new Container(
                      child:  Image (image:new  AssetImage('assets/image/idea.png'),
                        height: 30.0,
                        width: 30.0,
                      ),
                    ),
                    onTap: (){
                      setState(() {
                        hint = InputDecoration(       border: InputBorder.none,
                            hintText: "Share an Idea");
                      });
                    },
                  )
                  ),
                  new Expanded(child: new GestureDetector(
                    child:  new Container(
                      child:  Image (image:new  AssetImage('assets/image/manager.png'),
                        height: 30.0,
                        width: 30.0,
                      ),
                    ),
                    onTap: (){
                    setState(()
                    {
                      hint = InputDecoration(
                           border: InputBorder.none,
                          hintText: "What if..!");
                     }
                    );
                    },
                  )
                  ),
                  new Expanded(child: new GestureDetector(
                    child: new Container(
                      child:  Image (image:new  AssetImage('assets/image/talent-search.png'),
                        height: 30.0,
                        width: 30.0,
                      ),
                    ),
                    onTap: (){
                      setState(() {
                        hint = InputDecoration(
                            border: InputBorder.none,
                            hintText: "Express your talent");
                      }
                     );
                   },
                  )
                  ),
                  new Expanded(child: new GestureDetector(
                    child: new Container(
                      child:  Image (image:new  AssetImage('assets/image/feedback.png'),
                        height: 30.0,
                        width: 30.0,
                      ),
                    ),
                    onTap: (){
                      setState(() {
                        hint = InputDecoration(
                            border: InputBorder.none,
                            hintText: "Ask a question");
                      });
                    },
                  )
                  ),
                  new Expanded(child: new GestureDetector(
                    child: new Container(
                      child:  Image (image:new  AssetImage('assets/image/handshake.png'),
                        height: 30.0,
                        width: 30.0,
                      ),
                    ),
                    onTap: (){
                      setState(() {
                        hint = InputDecoration(
                            border: InputBorder.none,
                            hintText: "Share what's happening");


                      });
                    },
                  )
                  ),
                ],
              ),
              height: 60.0,
              ),
             new Divider(
               height: 2.0,
               color: Colors.black,
             ),
            new Container
             (
              height: 100.0,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(18.0)
              ),
             margin: const EdgeInsets.all(2.0),
              child: new Padding(padding: EdgeInsets.all(5.0),
                child:  new TextField(
                  decoration:  hint,
                  controller: myController,
                ),
              )
             ),
       Expanded(child:
       image == null
           ? new Container() :new  Container(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  new Expanded(child: SizedBox(
                    height: 160.0,
                    child: new ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index)
                      {
                     //   Hello(index);

                     //   print(image[index].toString());
                        return new Users(imageURL: image[index],image: image,    );


                      },

                      itemCount: image.length,
                    ),
                  ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Text('Error Dectected: $_platformMessage'),
                  ),
                ],
              ),
            ),
            ),

           Expanded(child:
            new Container(
              height: 80.0,
              margin: const EdgeInsets.only(top: 10.0),
             child: new Column(
               children: <Widget>[
                 new Row(
                   children: <Widget>[
                     new Expanded(child:     new IconButton(icon: new Icon(Icons.videocam,color: Colors.blueGrey,
                       size: 50.0,
                     ),
                         onPressed: ()
                         {

                           _onImageButtonPressed(ImageSource.gallery);
                           isVideo = true;
                         }
                     ),
                       flex: 1,
                     ),
                     new Expanded(child:     new IconButton(icon: new Icon(Icons.image,color: Colors.blueGrey,
                       size: 50.0,
                     ),
                         onPressed: ()
                         {
                          setState(()
                          {
                            getImage();
                          }
                          );
                         }
                     ),
                       flex: 1,
                     ),
                     new Expanded(child: new IconButton(icon: new Icon(Icons.album ,color: Colors.blueGrey,
                       size: 50.0,
                     ),
                         onPressed: ()
                         {
                           initMultiPickUp();

                         }
                     ),
                       flex: 1,
                     )
                   ],
                 ),
              Expanded(child:
                   new Container(
                     height: 120.0,
                     child:   Column(
                     children: [ new Align(
                             alignment: Alignment.topLeft,
                             child:
                             new Text("hello",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)
                              ),
                                   new FutureBuilder(
                                       future: mycube(),
                                       builder: (context,AsyncSnapshot<List> response)
                                   {
                                      print("hello");
                                       return new Expanded(child:   ListView.builder(
                                             scrollDirection: Axis.horizontal,
                                             itemCount: cubes.length,
                                             itemBuilder:
                                               (context, int index)
                                                 {
                                               return new Container(
                                                   padding: EdgeInsets.all(10.0),
                                                   child: new Column(
                                                     crossAxisAlignment: CrossAxisAlignment.center,
                                                     children: <Widget>[
                                                       new GestureDetector(
                                                        child:   new CircleAvatar(
                                                           backgroundImage: NetworkImage(
                                                               Config.CUBE_IMAGE+   cubes[index].image),
                                                         ),
                                                         onTap: ()
                                                         {
                                                           jsonstring =   jsonEncode(cubearray);
                                                           print(jsonstring);

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
                                       );
                                   }


                           ),
                        ],
                     ),

                  ),
                flex: 1,
                  ),

                new Container(child: Expanded(child:
                new Align(
                    alignment: Alignment.center,
                    child: new RawMaterialButton(onPressed: ()
                      {
                        uploads();

                      },
                      shape: CircleBorder(),
                    child: new Text("Post"),

                  ),
                ),
                )
                ),

               ],
             )
            ),
            ),
          ],
        )
        ),
    );
  }
}

Color color = Colors.grey;

void Hello(int index)
{

}
class Users extends StatefulWidget
{
 final   List image;
  final File imageURL;
  const  Users  ({Key key, this.imageURL,this.image}) : super(key: key);
  @override
 UserWidgets createState() => UserWidgets();


}

class UserWidgets extends State<Users>
{

  @override
  Widget build(BuildContext context)
  {


    VideoPlayerController playerController;
    VoidCallback listener;
    Widget play=new Icon(Icons.play_arrow);
    Widget pause=new Icon(Icons.pause);

    return new Container(
      height: 200.0,
      child: Stack(
         children: <Widget>[
            widget.imageURL.toString().contains(".jpg") ||widget.imageURL.toString().contains(".png") ||
               widget.imageURL.toString().contains(".jpeg") ?
            new Container(

           child: new Card(
          child: new Column(
          children: <Widget>[
          new GestureDetector(
                      onTap: ()
                            {
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>   VideoApp(file: widget.imageURL,)

                            ),

                          );

                      },
                child:
                    new  Image.file(widget.imageURL
                      ,fit: BoxFit.cover,
                      height: 150.0,
                      width: 100.0,

                           ),

                          )
                      ],
                      )
                      ),
                  ): widget.imageURL.toString().contains(".mp4") ||widget.imageURL.toString().contains(".3gp") ?
                  new Container(
          height: 100.0,
          child: AspectRatio(aspectRatio: 10/6,
              child: GestureDetector(
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  VideoApp(file: widget.imageURL,)
                    ),
                    );
                  },
                  child:
                  VideoPlayer(playerController = VideoPlayerController.file (widget.imageURL)
                    ..addListener(listener)
                    ..setVolume(1.0)
                    ..initialize()
                    ..pause()
                       )
                          )
                       )
                    ): new
                              Container(),
                        new  Positioned(
                          child:
                            IconButton(icon: Icon(Icons.remove_circle),
                            color: Colors.black,

                            onPressed : ()
                            {

                              setState(() {
                                widget.image.remove(widget.imageURL);
                                print("helo");
                              });
                            }
                            )
                          ,
                          top: 0.0,
                          right: 0.0,
                        )
                        ],
                      ),
                       );

  }



}

  class VideoApp extends StatefulWidget {
  final File file;
   const VideoApp  ({Key key, this.file}) : super(key: key);

   @override
   ImageView createState() => ImageView();
   }
      class ImageView extends State<VideoApp>
 {
  VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context)
  {
    return  widget.file.toString().contains(".jpg") ||widget.file.toString().contains(".png") ||
        widget.file.toString().contains(".jpeg") ?
     new Container(
        child: new PhotoView(
          imageProvider: FileImage(widget.file),
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: 4.0,
        ),
    ):
    new  MaterialApp(
      debugShowCheckedModeBanner: false,
      home:
    Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _controller.value.initialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
        : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _controller.value.isPlaying
            ? _controller.pause
            : _controller.play,
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    ),
    );

  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(
      widget.file
    )
      ..addListener(() {
        final bool isPlaying = _controller.value.isPlaying;
        if (isPlaying != _isPlaying) {
          setState(() {
            _isPlaying = isPlaying;
          });
        }
      })
      ..initialize().then((_) {

        setState(() {});
      });
  }
}
