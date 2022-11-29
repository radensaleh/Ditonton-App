import 'package:feature_movie/presentation/blocs/top_rated_movie_bloc.dart';
import 'package:feature_movie/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedMoviesPage extends StatefulWidget {
  const TopRatedMoviesPage({Key? key}) : super(key: key);

  @override
  State<TopRatedMoviesPage> createState() => _TopRatedMoviesPageState();
}

class _TopRatedMoviesPageState extends State<TopRatedMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<TopRatedMovieBloc>().add(FetchNowTopRatedMovies()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedMovieBloc, TopRatedMovieState>(
          builder: (context, state) {
            if (state is TopRatedMovieLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TopRatedMovieHasDataState) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.result[index];
                  return MovieCard(movie);
                },
                itemCount: state.result.length,
              );
            } else if (state is TopRatedMovieErrorState) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            } else if (state is TopRatedMovieEmptyState) {
              return const Center(child: Text('Data Not Found'));
            } else {
              return const Center(child: Text('Error BLoC'));
            }
          },
        ),
      ),
    );
  }
}
