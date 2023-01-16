import 'package:flutter/material.dart';
import 'package:palominfos/models/models.dart';
import 'package:palominfos/widgets/widgets.dart';

class DetailsScreen extends StatelessWidget {
   
  const DetailsScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _CustomAppBar(movie: movie,),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _PosterAndTitle(movie: movie),
                _Overview(movie: movie),
                CastingCards(movieId: movie.id, isSerie: false,)
              ])
          )

        ],

      )
    );
  }
}

class _CustomAppBar extends StatelessWidget { 
  final Movie movie;
  const _CustomAppBar({required this.movie});

  @override
  Widget build(BuildContext context) {
    return  SliverAppBar(
      backgroundColor: Colors.red,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.all(0),
        title: Container(
          color: Colors.black12,
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 5, left: 10, right: 10),
          child: Text(
            movie.title,
            style: const TextStyle( fontSize: 16),
            textAlign: TextAlign.center,
          )
        ),

        background: FadeInImage(
          placeholder: const AssetImage('assets/loading.gif'), 
          image: NetworkImage(movie.backdropPathImg),
          fit: BoxFit.cover,
        )
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  final Movie movie;
  const _PosterAndTitle({required this.movie});
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Hero(
            tag: movie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'), 
                image: NetworkImage(movie.posterImg),
                height: 150,
              ),
            ),
          ),

          const SizedBox( width: 20),

          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width - 180),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movie.title,
                    style: textTheme.headline5,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                ),
                
                const SizedBox(height: 5),
          
                Text(movie.originalTitle,
                    style: textTheme.subtitle2,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                ),
          
                const SizedBox(height: 5),
          
                Row(
                  children: [
                    Icon(Icons.star, size: 20, color: Colors.yellow.shade700),
                    const SizedBox(width: 5),
                    Text(movie.voteAverage.toString(),
                        style: textTheme.caption, 
                        )
                  ],
                ),

                const SizedBox(height: 5),

                Text("Fecha de salida: ${movie.releaseDateTxt}",
                    style: textTheme.caption)
          
              ],
            ),
          )
        ]),
    );
  }
}

class _Overview extends StatelessWidget {
  final Movie movie;

  const _Overview({required this.movie});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: 
        Text(movie.overview,
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.subtitle1,
        ),
    );
  }
}