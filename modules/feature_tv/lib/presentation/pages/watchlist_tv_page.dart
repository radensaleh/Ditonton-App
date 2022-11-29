import 'package:core/core.dart';
import 'package:feature_tv/presentation/blocs/watchlist_tv/watchlist_tv_bloc.dart';
import 'package:feature_tv/presentation/widgets/tv_card_list.dart';
import 'package:feature_tv/presentation/widgets/tv_not_found_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistTVPage extends StatefulWidget {
  const WatchlistTVPage({Key? key}) : super(key: key);

  @override
  State<WatchlistTVPage> createState() => _WatchlistTVPageState();
}

class _WatchlistTVPageState extends State<WatchlistTVPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<WatchlistTvBloc>().add(FetchWatchlistTvShows()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<WatchlistTvBloc>().add(FetchWatchlistTvShows());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist TV Shows'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchlistTvBloc, WatchlistTvState>(
          builder: (context, state) {
            if (state is WatchlistTvLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is WatchlistTvHasDataState) {
              final result = state.result;
              if (result.isEmpty) {
                return const TVNotFoundWidget(
                  message: 'Watchlist TV not found',
                );
              }
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = result[index];
                  return TVCard(tv);
                },
                itemCount: result.length,
              );
            } else if (state is WatchlistTvErrorState) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            } else if (state is WatchlistTvInitialState) {
              return const TVNotFoundWidget(message: 'Watchlist TV not found');
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
