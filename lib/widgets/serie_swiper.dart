import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import '../models/models.dart';

class SerieSwiper extends StatelessWidget {

  final List<Serie> series;

  const SerieSwiper({super.key, 
  required this.series
  });

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    if(series.isEmpty){
      
      return SizedBox(
        width: double.infinity,
        height: screenSize.height * 0.5,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 25),
          child: Text("NOVEDADES",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: screenSize.height * 0.5,
          child: Swiper(
            autoplay: true,
            autoplayDisableOnInteraction: true,
            autoplayDelay: 10000,
            itemCount: series.length,
            layout: SwiperLayout.STACK,
            itemWidth: screenSize.width * 0.6,
            itemHeight: screenSize.height * 0.45,
            itemBuilder: (BuildContext context, int index) {
              final serie = series[index];
              serie.heroId = "swiper-${serie.id}";
              
              return GestureDetector(
                onTap: () =>  Navigator.pushNamed(context, 'serieDetails', arguments: serie),
                child: Hero(
                  tag: serie.heroId!,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FadeInImage(
                      placeholder: const AssetImage("assets/no-image.jpg"),
                      image: NetworkImage(serie.posterImg),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
            )
        ),
      ],
    );
  }
}