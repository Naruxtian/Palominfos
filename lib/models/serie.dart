import 'dart:convert';

class Serie {
    Serie({
      this.backdropPath,
      this.firstAirDate,
      required this.genreIds,
      required this.id,
      required this.name,
      required this.originCountry,
      required this.originalLanguage,
      required this.originalName,
      required this.overview,
      required this.popularity,
      this.posterPath,
      required this.voteAverage,
      required this.voteCount,
    });

    String? backdropPath;
    String? firstAirDate;
    List<int> genreIds;
    int id;
    String name;
    List<String> originCountry;
    String originalLanguage;
    String originalName;
    String overview;
    double popularity;
    String? posterPath;
    double voteAverage;
    int voteCount;

    String? heroId;

    get posterImg {
      if (posterPath != null) {
        return 'https://image.tmdb.org/t/p/w500/$posterPath';
      } else {
        return 'https://i.stack.imgur.com/GNhxO.png';
      }
    }

    get backdropPathImg {
      if (backdropPath != null) {
        return 'https://image.tmdb.org/t/p/w500/$backdropPath';
      } else {
        return 'https://i.stack.imgur.com/GNhxO.png';
      }
    }

    get firstAirTxt {
      if (firstAirDate != null) {
        final date = DateTime.parse(firstAirDate!);
        final year = date.year;
        final month = date.month;
        final day = date.day;

        return '$day/$month/$year';

      } else {
        return 'No data';
      }
    }

    factory Serie.fromJson(String str) => Serie.fromMap(json.decode(str));

    factory Serie.fromMap(Map<String, dynamic> json) => Serie(
        backdropPath: json["backdrop_path"],
        firstAirDate: json["first_air_date"],
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        id: json["id"],
        name: json["name"],
        originCountry: List<String>.from(json["origin_country"].map((x) => x)),
        originalLanguage: json["original_language"],
        originalName: json["original_name"],
        overview: json["overview"],
        popularity: json["popularity"].toDouble(),
        posterPath: json["poster_path"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
    );

}
