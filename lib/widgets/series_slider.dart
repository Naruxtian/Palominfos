import 'package:flutter/material.dart';
import '../models/models.dart';

class SerieSlider extends StatefulWidget {

  final List<Serie> series;
  final String? title;
  final Function onNextPage;

  const SerieSlider({
    super.key, 
    required this.series, 
    required this.onNextPage,
    this.title, 
  });

  @override
  State<SerieSlider> createState() => _SerieSliderState();
}

class _SerieSliderState extends State<SerieSlider> {

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if(scrollController.position.pixels >= scrollController.position.maxScrollExtent - 500){
        widget.onNextPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    if(widget.series.isEmpty){
      return const SizedBox(
        width: double.infinity,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          if(widget.title != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(widget.title!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),

          const SizedBox(height: 5),

          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.series.length,
              itemBuilder: (_, int index) => _SeriePoster(serie: widget.series[index], 
                                              heroId: "${widget.title}-$index-${widget.series[index].id}")
            ),
          ),

        ]
      ),
    );
  }
}

class _SeriePoster extends StatelessWidget {
  final Serie serie;
  final String heroId;
  const _SeriePoster({ required this.serie, required this.heroId });

  @override
  Widget build(BuildContext context) {
    serie.heroId = heroId;
    return Container(
      width: 130,
      height: 190,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children:  [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'serieDetails', arguments: serie),
            child: Hero(
              tag: serie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/no-image.jpg'), 
                  image: NetworkImage(serie.posterImg),
                  width: 130,
                  height: 190,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          const SizedBox(height: 5),

          Text(serie.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,

            
          )
        ],
      ),
    );
  }
}