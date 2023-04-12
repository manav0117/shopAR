class Video {
  String? name;
  String? imageUrl;
  String? videoUrl;

  Video({this.name, this.imageUrl, this.videoUrl});

  Video.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    imageUrl = json['imageUrl'];
    videoUrl = json['videoUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['imageUrl'] = this.imageUrl;
    data['videoUrl'] = this.videoUrl;
    return data;
  }
}
