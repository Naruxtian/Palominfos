import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:palominfos/helpers/debouncer.dart';
import 'package:palominfos/models/models.dart';

class MoviesProvider extends ChangeNotifier{

  final String _baseUrl   = 'api.themoviedb.org';
  final String _apiKey    = '4329972224e46cebe4ee77f1bb538372';
  final String _language  = 'es-MX';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];
  List<Movie> topRatedMovies = [];

  Map<int, List<Cast>> moviesCast = {};

  int _popularPage = 0;
  int _topRatedPage = 0;


  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500),
  );

  final StreamController<List<Movie>> _suggestionStreamController = StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream => _suggestionStreamController.stream;

  MoviesProvider(){
    getOnDisplayMovies();
    getPopularMovies();
    getTopRatedMovies();
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

  getOnDisplayMovies() async{
    final jsonData = await _getJsonData('3/movie/now_playing');
    final nowPlayingResponse = NowPlaying.fromJson(jsonData);

    onDisplayMovies = nowPlayingResponse.results;

    notifyListeners();
  }

  getPopularMovies() async{
    _popularPage++;  
    final jsonData = await _getJsonData('3/movie/popular', page: _popularPage);
    final popularResponse = Popular.fromJson(jsonData);

    popularMovies = [...popularMovies, ...popularResponse.results];

    notifyListeners();
  }

  getTopRatedMovies() async{
    _topRatedPage++;  
    final jsonData = await _getJsonData('3/movie/top_rated', page: _topRatedPage);
    final topResponse = TopRated.fromJson(jsonData);

    topRatedMovies = [...topRatedMovies, ...topResponse.results];

    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async{
    if(moviesCast.containsKey(movieId)){
      return moviesCast[movieId]!;
    } 
    
    final jsonData = await _getJsonData('3/movie/$movieId/credits');
    final creditsResponse = Credits.fromJson(jsonData);

    moviesCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovie (String query) async{

    final url = Uri.https(_baseUrl, '3/search/movie', {
      'api_key': _apiKey,
      'language': _language,
      'query': query
    });

    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);

    return searchResponse.results;
  }

  void getSuggestionByQuery(String searchTerm){
    debouncer.value = '';
    debouncer.onValue =(value) async{
      final results = await searchMovie(value);
      _suggestionStreamController.add(results);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) { 
      debouncer.value = searchTerm;
      });

    Future.delayed(const Duration(milliseconds:  301)).then((_) => timer.cancel());
  }
}