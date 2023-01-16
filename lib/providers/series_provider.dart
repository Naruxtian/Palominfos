import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:palominfos/helpers/debouncer.dart';
import 'package:palominfos/models/models.dart';
import 'dart:async';

import 'package:palominfos/models/responses/popular_series.dart';
import 'package:palominfos/models/responses/searchSerie_response.dart';

class SeriesProvider extends ChangeNotifier {
  
  final String _baseUrl   = 'api.themoviedb.org';
  final String _apiKey    = '4329972224e46cebe4ee77f1bb538372';
  final String _language  = 'es-MX';

  List<Serie> onAirSeries = [];
  List<Serie> popularSeries = [];
  List<Serie> topSeries = [];

  Map<int, List<Cast>> seriesCast = {};

  int _popularPage = 0;
  int _topRatedPage = 0;

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500),
  );

  final StreamController<List<Serie>> _suggestionStreamController = StreamController.broadcast();
  Stream<List<Serie>> get suggestionStream => _suggestionStreamController.stream;

  SeriesProvider(){
    getOnAirSeries();
    getPopularSeries();
    getTopRatedSeries();
  }

  Future<String> _getJsonData(String endpoint, {int page = 1}) async{
     final url =Uri.https(_baseUrl, endpoint, {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page'
      });

    final response = await http.get(url);
    return response.body;

  }

  getOnAirSeries() async{
    final jsonData = await _getJsonData('3/tv/on_the_air');
    final onAirResponse = PopularSeries.fromJson(jsonData);

    onAirSeries = onAirResponse.results;

    notifyListeners();
  }

  getPopularSeries() async {
    _popularPage++;  
    final jsonData = await _getJsonData('3/tv/popular', page: _popularPage);
    final popularResponse = PopularSeries.fromJson(jsonData);
    popularSeries = [...popularSeries, ...popularResponse.results];

    notifyListeners();  
  }

  getTopRatedSeries() async {
    _topRatedPage++;  
    final jsonData = await _getJsonData('3/tv/top_rated', page: _topRatedPage);
    final topResponse = PopularSeries.fromJson(jsonData);
    topSeries = [...topSeries, ...topResponse.results];

    notifyListeners();  
  }

  Future<List<Cast>> getSerieCast(int serieId) async{
    if(seriesCast.containsKey(serieId)){
      return seriesCast[serieId]!;
    } 
    
    final jsonData = await _getJsonData('3/tv/$serieId/credits');
    final creditsResponse = Credits.fromJson(jsonData);

    seriesCast[serieId] = creditsResponse.cast;

    return creditsResponse.cast;
  }

  Future<List<Serie>> searchSerie (String query) async{

    final url = Uri.https(_baseUrl, '3/search/tv', {
      'api_key': _apiKey,
      'language': _language,
      'query': query
    });

    final response = await http.get(url);
    final searchResponse = SearchSerieResponse.fromJson(response.body);

    return searchResponse.results;
  }

  void getSuggestionByQuery(String searchTerm){
    debouncer.value = '';
    debouncer.onValue =(value) async{
      final results = await searchSerie(value);
      _suggestionStreamController.add(results);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) { 
      debouncer.value = searchTerm;
      });

    Future.delayed(const Duration(milliseconds:  301)).then((_) => timer.cancel());
  }

}