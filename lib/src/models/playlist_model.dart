import 'dart:convert';

class MyPlaylistModel {
  final String name;
  final String id;
  final String? thumbnail;
  final bool? isDeletable;

  List<String> songIds;

  MyPlaylistModel({
    required this.name,
    required this.id,
    required this.songIds,
    this.isDeletable,
    this.thumbnail,
  });

  MyPlaylistModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['id'],
        songIds = List<String>.from(json['songIds']),
        thumbnail = json['thumbnail'],
        isDeletable = json['isDeletable'];

  static Map<String, dynamic> toMap(MyPlaylistModel playlist) => {
        'name': playlist.name,
        'id': playlist.id,
        'songIds': playlist.songIds,
        'thumbnail': playlist.thumbnail,
        'isDeletable': playlist.isDeletable,
      };

  static String encode(List<MyPlaylistModel> playlists) => json.encode(
        playlists
            .map<Map<String, dynamic>>(
              (playlist) => MyPlaylistModel.toMap(playlist),
            )
            .toList(),
      );

  static List<MyPlaylistModel> decode(String playlists) =>
      (json.decode(playlists) as List<dynamic>)
          .map<MyPlaylistModel>((item) => MyPlaylistModel.fromJson(item))
          .toList();
}
