// To parse this JSON data, do
//
//     final popularSeries = popularSeriesFromMap(jsonString);
import 'dart:convert';
import '../models.dart';

class PopularSeries {
    PopularSeries({
      required this.page,
      required this.results,
      required this.totalPages,
      required this.totalResults,
    });

    int page;
    List<Serie> results;
    int totalPages;
    int totalResults;

    factory PopularSeries.fromJson(String str) => PopularSeries.fromMap(json.decode(str));

    factory PopularSeries.fromMap(Map<String, dynamic> json) => PopularSeries(
        page: json["page"],
        results: List<Serie>.from(json["results"].map((x) => Serie.fromMap(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
    );
}
