
class Postss
{
  String Images;
  String User_Name;
  String Time_Ago;
  String images,file_type;
  String cubeid,posttext,postcategory;
 List<Imagelist> attachments;

  Postss(String imgae,String name,String time,List attach,String posttext,String postcat)
  {
    this.Images = imgae;
    this.User_Name = name;
    this.Time_Ago = time;
    this.attachments = attach;

    this.posttext = posttext;
    this.postcategory= postcat;
  }
}

class Imagelist
{
  final  String filename;
  final String filetype;
   Imagelist ({this.filename,this.filetype});

  factory Imagelist.fromJson(Map<String, dynamic> json)
  {
    return new Imagelist(
        filename : json['File_Name'],
        filetype : json['File_Type'],
    );
  }
}
