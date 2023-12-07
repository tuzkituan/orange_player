class MyPlaylistModel {
  final String name;
  final String id;

  List<String> songIds;

  MyPlaylistModel(
      {required this.name, required this.id, required this.songIds});

  MyPlaylistModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['id'],
        songIds = json['songIds'];
}
