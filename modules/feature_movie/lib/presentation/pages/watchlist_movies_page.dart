import 'package:core/core.dart';
import 'package:feature_movie/presentation/blocs/watchlist_movie_bloc.dart';
import 'package:feature_movie/presentation/widgets/movie_card_list.dart';
import 'package:feature_movie/presentation/widgets/movie_not_found_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistMoviesPage extends StatefulWidget {
  const WatchlistMoviesPage({super.key});

  @override
  State<WatchlistMoviesPage> createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<WatchlistMovieBloc>().add(FetchNowWatchlistMovie()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<WatchlistMovieBloc>().add(FetchNowWatchlistMovie());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchlistMovieBloc, WatchlistMovieState>(
          builder: (context, state) {
            if (state is WatchlistMovieLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is WatchlistMovieHasDataState) {
              if (state.result.isEmpty) {
                return const MovieNotFoundWidget(
                  message: 'Watchlist Movie not found',
                );
              }
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.result[index];
                  return MovieCard(movie);
                },
                itemCount: state.result.length,
              );
            } else if (state is WatchlistMovieEmptyState) {
              return const MovieNotFoundWidget(
                message: 'Watchlist Movie not found',
              );
            } else if (state is WatchlistMovieErrorState) {
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

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
