import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:feature_movie/domain/entities/movie.dart';
import 'package:feature_movie/presentation/blocs/now_playing_movie_bloc.dart';
import 'package:feature_movie/presentation/blocs/popular_movie_bloc.dart';
import 'package:feature_movie/presentation/blocs/top_rated_movie_bloc.dart';
import 'package:feature_movie/presentation/widgets/sub_heading_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeMoviePage extends StatefulWidget {
  const HomeMoviePage({super.key});

  @override
  State<HomeMoviePage> createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<NowPlayingMovieBloc>().add(FetchNowNowPlayingMovies());
      context.read<PopularMovieBloc>().add(FetchNowPopularMovies());
      context.read<TopRatedMovieBloc>().add(FetchNowTopRatedMovies());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SubHeadingText(
              title: 'Now Playing',
              onTap: () =>
                  Navigator.pushNamed(context, MOVIE_NOW_PLAYING_ROUTE),
            ),
            BlocBuilder<NowPlayingMovieBloc, NowPlayingMovieState>(
                builder: (context, state) {
              if (state is NowPlayingMovieLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is NowPlayingMovieHasDataState) {
                return MovieList(state.result);
              } else if (state is NowPlayingMovieEmptyState) {
                return const Text('Data Not Found');
              } else if (state is NowPlayingMovieErrorState) {
                return Center(child: Text(state.message));
              } else {
                return const Center(child: Text('Error BLoC'));
              }
            }),
            SubHeadingText(
              title: 'Popular',
              onTap: () => Navigator.pushNamed(context, MOVIE_POPULAR_ROUTE),
            ),
            BlocBuilder<PopularMovieBloc, PopularMovieState>(
                builder: (context, state) {
              if (state is PopularMovieLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is PopularMovieHasDataState) {
                return MovieList(state.result);
              } else if (state is PopularMovieEmptyState) {
                return const Text('Data Not Found');
              } else if (state is PopularMovieErrorState) {
                return Center(child: Text(state.message));
              } else {
                return const Center(child: Text('Error BLoC'));
              }
            }),
            SubHeadingText(
              title: 'Top Rated',
              onTap: () => Navigator.pushNamed(context, MOVIE_TOP_RATED_ROUTE),
            ),
            BlocBuilder<TopRatedMovieBloc, TopRatedMovieState>(
                builder: (context, state) {
              if (state is TopRatedMovieLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is TopRatedMovieHasDataState) {
                return MovieList(state.result);
              } else if (state is TopRatedMovieEmptyState) {
                return const Text('Data Not Found');
              } else if (state is TopRatedMovieErrorState) {
                return Center(child: Text(state.message));
              } else {
                return const Center(child: Text('Error BLoC'));
              }
            }),
          ],
        ),
      ),
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  const MovieList(this.movies, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MOVIE_DETAIL_ROUTE,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
