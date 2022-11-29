import 'package:feature_movie/presentation/blocs/now_playing_movie_bloc.dart';
import 'package:feature_movie/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NowPlayingMoviePage extends StatefulWidget {
  const NowPlayingMoviePage({super.key});

  @override
  State<NowPlayingMoviePage> createState() => _NowPlayingMoviePageState();
}

class _NowPlayingMoviePageState extends State<NowPlayingMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<NowPlayingMovieBloc>().add(FetchNowNowPlayingMovies()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<NowPlayingMovieBloc, NowPlayingMovieState>(
          builder: (context, state) {
            if (state is NowPlayingMovieLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is NowPlayingMovieHasDataState) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.result[index];
                  return MovieCard(movie);
                },
                itemCount: state.result.length,
              );
            } else if (state is NowPlayingMovieEmptyState) {
              return const Center(child: Text('Data Not Found'));
            } else if (state is NowPlayingMovieErrorState) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return const Center(child: Text('Error BLoC'));
            }
          },
        ),
      ),
    );
  }
}
