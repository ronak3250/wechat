class MessageModel {
 late final String image;
 late final String about;
 late final String name;
 late final String createdat;
 late final bool isonline;
 late final String id;
 late final String lastactive;
 late final String email;
 late final String pushToken;

  MessageModel(
      {required this.image,
        required this.about,
         required this.name,
        required this.createdat,
        required this.isonline,
        required this.id,
        required this.lastactive,
        required this.email,
        required this.pushToken});

  MessageModel.fromJson(Map<String, dynamic> json) {
    image = json['image']??'';
    about = json['about']??'';
    name = json['name']?? 'User';
    createdat = json['createdat']??'';
    isonline = json['isonline']??false;
    id = json['id']??'';
    lastactive = json['lastactive']??'';
    email = json['email']??'';
    pushToken = json['pushToken']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['about'] = this.about;
    data['name'] = this.name;
    data['createdat'] = this.createdat;
    data['isonline'] = this.isonline;
    data['id'] = this.id;
    data['lastactive'] = this.lastactive;
    data['email'] = this.email;
    data['pushToken'] = this.pushToken;
    return data;
  }
}
List <MessageModel> messagemodel=[];