class MyPlaylistModel {
  final String name;
  final String id;

  List<String> songIds;

  MyPlaylistModel(
      {required this.name, required this.id, required this.songIds});
}
