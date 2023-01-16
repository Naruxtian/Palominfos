import 'package:flutter/material.dart';
import 'package:palominfos/models/models.dart';
import 'package:palominfos/widgets/widgets.dart';

class SeriesDetailsScreen extends StatelessWidget {
   
  const SeriesDetailsScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final Serie serie = ModalRoute.of(context)!.settings.arguments as Serie;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _CustomAppBar(serie: serie,),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _PosterAndTitle(serie: serie),
                _Overview(serie: serie),
                CastingCards(movieId: serie.id, isSerie: true,)
              ])
          )

        ],

      )
    );
  }
}

class _CustomAppBar extends StatelessWidget { 
  final Serie serie;
  const _CustomAppBar({required this.serie});

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
            serie.name,
            style: const TextStyle( fontSize: 16),
            textAlign: TextAlign.center,
          )
        ),

        background: FadeInImage(
          placeholder: const AssetImage('assets/loading.gif'), 
          image: NetworkImage(serie.backdropPathImg),
          fit: BoxFit.cover,
        )
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  final Serie serie;
  const _PosterAndTitle({required this.serie});
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
            tag: serie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'), 
                image: NetworkImage(serie.posterImg),
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
                Text(serie.name,
                    style: textTheme.headline5,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                ),
                
                const SizedBox(height: 5),
          
                Text(serie.originalName,
                    style: textTheme.subtitle2,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                ),
          
                const SizedBox(height: 5),
          
                Row(
                  children: [
                    Icon(Icons.star, size: 20, color: Colors.yellow.shade700),
                    const SizedBox(width: 5),
                    Text(serie.voteAverage.toString(),
                        style: textTheme.caption, 
                        )
                  ],
                ),

                const SizedBox(height: 5),

                Text("Fecha de salida: ${serie.firstAirTxt}",
                    style: textTheme.caption)
          
              ],
            ),
          )
        ]),
    );
  }
}

class _Overview extends StatelessWidget {
  final Serie serie;

  const _Overview({required this.serie});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: 
        Text(serie.overview,
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.subtitle1,
        ),
    );
  }
}