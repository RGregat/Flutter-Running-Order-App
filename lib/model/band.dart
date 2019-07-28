class Band {
  String stage;
  int time;
  String bandName;
  String genre;
  String bandDescription;
  String officialWebsite;
  String spotifyArtist;
  String thumbnail;
  String youtubeLink;

  Band(
      {this.stage,
      this.time,
      this.bandName,
      this.genre,
      this.bandDescription,
      this.officialWebsite,
      this.spotifyArtist,
      this.thumbnail,
      this.youtubeLink});

  factory Band.fromJson(Map<String, dynamic> json) {
    return Band(
        stage: json["stage"],
        time: int.parse(json["time"]),
        bandName: json["bandName"],
        genre: json["genre"],
        bandDescription: json["bandDescription"],
        officialWebsite: json["officialWebsite"],
        spotifyArtist: json["spotifyArtist"],
        thumbnail: json["thumbnail"],
        youtubeLink: json["youtubeLink"]);
  }
}
