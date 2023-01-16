import 'package:flutter/material.dart';
import 'package:palominfos/providers/movies_provider.dart';
import 'package:palominfos/providers/series_provider.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';

class MovieSearchDelegate extends SearchDelegate{

  Widget _emptyContainer(){
    return const Center(
      child: Icon(Icons.movie_creation_outlined, size: 150, color: Colors.black38),
    );
  }

  @override
  String? get searchFieldLabel => "Buscar";

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = "", 
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: (){
        close(context, null);
      } 
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if(query.isEmpty){
      return _emptyContainer();
    }

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    moviesProvider.getSuggestionByQuery(query);

    return StreamBuilder(
      stream: moviesProvider.suggestionStream,
      builder: ( _, AsyncSnapshot<List<Movie>> snapshot) {
         
        if(!snapshot.hasData){
          return _emptyContainer();
        }

        final movies = snapshot.data!;

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: ( _ , int index) {
            return _SuggestionMovie(movie: movies[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if(query.isEmpty){
      return _emptyContainer();
    }

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    moviesProvider.getSuggestionByQuery(query);

    return StreamBuilder(
      stream: moviesProvider.suggestionStream,
      builder: ( _, AsyncSnapshot<List<Movie>> snapshot) {
         
        if(!snapshot.hasData){
          return _emptyContainer();
        }

        final movies = snapshot.data!;

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: ( _ , int index) {
            return _SuggestionMovie(movie: movies[index]);
          },
        );
      },
    );
  }

}

class SerieSearchDelegate extends SearchDelegate{

  Widget _emptyContainer(){
    return const Center(
      child: Icon(Icons.movie_creation_outlined, size: 150, color: Colors.black38),
    );
  }

  @override
  String? get searchFieldLabel => "Buscar";

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = "", 
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: (){
        close(context, null);
      } 
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if(query.isEmpty){
      return _emptyContainer();
    }

    final seriesProvider = Provider.of<SeriesProvider>(context, listen: false);
    seriesProvider.getSuggestionByQuery(query);

    return StreamBuilder(
      stream: seriesProvider.suggestionStream,
      builder: ( _, AsyncSnapshot<List<Serie>> snapshot) {
         
        if(!snapshot.hasData){
          return _emptyContainer();
        }

        final series = snapshot.data!;

        return ListView.builder(
          itemCount: series.length,
          itemBuilder: ( _ , int index) {
            return _SuggestionSerie(serie: series[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if(query.isEmpty){
      return _emptyContainer();
    }
    final seriesProvider = Provider.of<SeriesProvider>(context, listen: false);
    seriesProvider.getSuggestionByQuery(query);
    return StreamBuilder(
      stream: seriesProvider.suggestionStream,
      builder: ( _, AsyncSnapshot<List<Serie>> snapshot) {
         
        if(!snapshot.hasData){
          return _emptyContainer();
        }

        final series = snapshot.data!;

        return ListView.builder(
          itemCount: series.length,
          itemBuilder: ( _ , int index) {
            return _SuggestionSerie(serie: series[index]);
          },
        );
      },
    );
  }

}



class _SuggestionMovie extends StatelessWidget {
  final Movie movie;
  const _SuggestionMovie({required this.movie});

  @override
  Widget build(BuildContext context) {
    movie.heroId = "search-${movie.id}";
    return ListTile(
      leading: Hero(
        tag: movie.heroId!,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: FadeInImage(
            placeholder: const AssetImage("assets/no-image.jpg"),
            image: NetworkImage(movie.posterImg),
            width: 50,
            fit: BoxFit.contain,
          ),
        ),
      ),
      title: Text(movie.title),
      subtitle: Text(movie.originalTitle),
      onTap: (){
        Navigator.pushNamed(context, "details", arguments: movie);
      },
    );
  }
}

class _SuggestionSerie extends StatelessWidget {
  final Serie serie;
  const _SuggestionSerie({required this.serie});

  @override
  Widget build(BuildContext context) {
    serie.heroId = "search-${serie.id}";
    return ListTile(
      leading: Hero(
        tag: serie.heroId!,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: FadeInImage(
            placeholder: const AssetImage("assets/no-image.jpg"),
            image: NetworkImage(serie.posterImg),
            width: 50,
            fit: BoxFit.contain,
          ),
        ),
      ),
      title: Text(serie.name),
      subtitle: Text(serie.originalName),
      onTap: (){
        Navigator.pushNamed(context, "serieDetails", arguments: serie);
      },
    );
  }
}