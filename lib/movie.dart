import 'package:flutter/material.dart';
import 'package:movie_app_ui/Model/model.dart';

class MovieDisplay extends StatefulWidget {
  const MovieDisplay({super.key});

  @override
  State<MovieDisplay> createState() => _MovieDisplayState();
}

class _MovieDisplayState extends State<MovieDisplay> {
  int current = 0;
  final PageController _pageController = PageController(viewportFraction: 0.7);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Escala para efecto de enlargeCenterPage
  double _scaleFromIndex(int index) {
    if (!_pageController.hasClients) return 1.0;
    double page =
        _pageController.page ?? _pageController.initialPage.toDouble();
    double diff = (page - index).abs();
    return 1 - (diff * 0.2).clamp(0.0, 0.2);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SizedBox(
        height: size.height,
        child: Stack(
          children: [
            // Background image (actual movie image based on current index)
            Image.network(
              movies[current]['Image'],
              fit: BoxFit.cover,
              height: size.height,
              width: size.width,
            ),

            // Gradient overlay at bottom
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: size.height * 0.33,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.grey.shade50.withOpacity(1),
                      Colors.grey.shade50.withOpacity(1),
                      Colors.grey.shade50.withOpacity(1),
                      Colors.grey.shade100.withOpacity(1),
                      Colors.grey.shade100.withOpacity(0.0),
                      Colors.grey.shade100.withOpacity(0.0),
                      Colors.grey.shade100.withOpacity(0.0),
                      Colors.grey.shade100.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),

            // PageView with movies
            Positioned(
            bottom: 50, // <-- Ajustado para dejar espacio a los íconos abajo
            height: size.height * 0.80, // <-- Reducida un poco la altura
            width: size.width,
            child: PageView.builder(
              controller: _pageController,
              itemCount: movies.length,
              onPageChanged: (index) {
                setState(() {
                  current = index;
                });
              },
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  double scale = _scaleFromIndex(index);

                  return Transform.scale(
                    scale: scale,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        width: size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                height: 350,
                                width: size.width * 0.55,
                                margin: const EdgeInsets.only(top: 20),
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Image.network(
                                  movie['Image'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                movie['Title'],
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                movie['Director'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black45,
                                ),
                              ),
                              const SizedBox(height: 20),
                              AnimatedOpacity(
                                duration: const Duration(milliseconds: 1000),
                                opacity: current == index ? 1.0 : 0.0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            movie['rating'],
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.black45,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time,
                                            color: Colors.black45,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            movie['duration'],
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.black45,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: size.width * 0.21,
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.fitness_center,
                                              color: Colors.black,
                                              size: 20,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              "250g",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black45,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
