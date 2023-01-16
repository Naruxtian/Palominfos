import 'package:flutter/material.dart';
import 'package:palominfos/models/models.dart';
import 'package:palominfos/providers/series_provider.dart';
import 'package:provider/provider.dart';
import '../providers/movies_provider.dart';

class CastingCards extends StatelessWidget {

  final int movieId;
  final bool isSerie;

  const CastingCards({super.key, required this.movieId, required this.isSerie});

  @override
  Widget build(BuildContext context) {

    final movieProvider = Provider.of<MoviesProvider>(context, listen: false);
    final serieProvider = Provider.of<SeriesProvider>(context, listen: false);

    return FutureBuilder(
      future: isSerie ? serieProvider.getSerieCast(movieId) : movieProvider.getMovieCast(movieId),
      builder: (_, AsyncSnapshot<List<Cast>> snapshot) {

        if(!snapshot.hasData){
          return const SizedBox(
            width: double.infinity,
            height: 200,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final cast = snapshot.data!;

        return Container(
          margin: const EdgeInsets.only(bottom: 30),
          width: double.infinity,
          height: 250,
          child: ListView.builder(
            itemCount: cast.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, int index) => _CastCard(actor: cast[index]),
          ),
        );
      },
    );

    
  }
}

class _CastCard extends StatelessWidget {

  final Cast actor;

  const _CastCard({required this.actor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 110,
      height: 100,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: const AssetImage('assets/no-image.jpg'),
              image: NetworkImage(actor.profilePathImg),
              width: 100,
              height: 130,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            actor.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 2),

          Text("como:", style: Theme.of(context).textTheme.caption),

          const SizedBox(height: 2),

          Text(
            actor.character!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}