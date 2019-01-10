

class cubelist
{
  String image;
  String id;
  String name;
  String cat_id;

  cubelist({this.image,this.id,this.name,this.cat_id});
  factory cubelist.fromjson(Map<String, dynamic> json)
  {
    return new cubelist(
      image: json['Image'],
      id: json['_id'],
      name: json['Name'],
      cat_id: json['Category_Id'],

    );
  }


}

class cubecatlist
{
  String name;
  String image;
  String id;
  cubecatlist({this.name,this.image,this.id});
  factory cubecatlist.fromjson(Map<String,dynamic> json)
  {

    return new cubecatlist(
      name: json['Name'],
      image: json['Image'],
      id: json['_id']


    );

  }



}

class imagelist
{
  String image;
  imagelist(this.image);

}