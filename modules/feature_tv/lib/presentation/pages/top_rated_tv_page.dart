import 'package:feature_tv/presentation/blocs/top_rated_tv/top_rated_tv_bloc.dart';
import 'package:feature_tv/presentation/widgets/tv_card_list.dart';
import 'package:feature_tv/presentation/widgets/tv_not_found_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedTVPage extends StatefulWidget {
  const TopRatedTVPage({Key? key}) : super(key: key);

  @override
  State<TopRatedTVPage> createState() => _TopRatedTVPageState();
}

class _TopRatedTVPageState extends State<TopRatedTVPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<TopRatedTvBloc>().add(FetchTopRatedTvShows()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated TV Shows'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedTvBloc, TopRatedTvState>(
          builder: (context, state) {
            if (state is TopRatedTvLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TopRatedTvHasDataState) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.result[index];
                  return TVCard(tv);
                },
                itemCount: state.result.length,
              );
            } else if (state is TopRatedTvErrorState) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            } else if (state is TopRatedTvInitialState) {
              return const TVNotFoundWidget(message: 'TV Show not found');
            } else {
              return const Center(child: Text('Error BLoC'));
            }
          },
        ),
      ),
    );
  }
}
