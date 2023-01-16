import 'package:flutter/material.dart';
import 'package:palominfos/providers/movies_provider.dart';
import 'package:palominfos/providers/series_provider.dart';
import 'package:palominfos/search/search_delegate.dart';
import 'package:provider/provider.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
   
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isMovies = true;
  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);
    final seriesProvider = Provider.of<SeriesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const[
            Icon(Icons.movie_creation_outlined),
            SizedBox(width: 10.0),
            Text("PALOMINFOS"),
            SizedBox(width: 10.0),
            Icon(Icons.movie_creation_outlined),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_outlined),
            onPressed: () => showSearch(
              context: context, 
              delegate: _isMovies ? MovieSearchDelegate() : SerieSearchDelegate()),
          ),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/banner.jpg"),
                  fit: BoxFit.contain,
                ),
              ),
              child: Container(),
            ),
            ListTile(
              leading: const Icon(Icons.movie_creation_outlined),
              title: const Text("Películas"),
              onTap: () {
                _isMovies = true;
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.tv_outlined),
              title: const Text("Series"),
              onTap: () {
                _isMovies = false;
                setState(() {});
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),

      body: Container(
            decoration: const BoxDecoration(
            image: DecorationImage(
            image: AssetImage("assets/backgrounds/christmas.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.srgbToLinearGamma(),
            ),
          ),
        child: SingleChildScrollView(
          child: Column(
            children: 
            _isMovies ?
            [
              MovieSwiper(
                movies: moviesProvider.onDisplayMovies,
              ), 
              MovieSlider(
                movies: moviesProvider.popularMovies,
                title: "Populares",
                onNextPage: () => moviesProvider.getPopularMovies(),
              ),
              MovieSlider(
                movies: moviesProvider.topRatedMovies,
                title: "Mejor valoradas",
                onNextPage: () => moviesProvider.getTopRatedMovies(),
              ),
            ]:[
              SerieSwiper(
                series: seriesProvider.onAirSeries,
              ),
              SerieSlider(
                series: seriesProvider.popularSeries, 
                title: "Series populares",
                onNextPage: ()=> seriesProvider.getPopularSeries(),
              ),
              SerieSlider(
                series: seriesProvider.topSeries, 
                title: "Series mejor valoradas",
                onNextPage: ()=> seriesProvider.getTopRatedSeries(),
              ),
            ]
          ),
        ),
        ) 
    );
  }
}