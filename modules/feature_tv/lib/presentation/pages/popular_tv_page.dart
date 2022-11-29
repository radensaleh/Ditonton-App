import 'package:feature_tv/presentation/blocs/popular_tv/popular_tv_bloc.dart';
import 'package:feature_tv/presentation/widgets/tv_card_list.dart';
import 'package:feature_tv/presentation/widgets/tv_not_found_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularTVPage extends StatefulWidget {
  const PopularTVPage({Key? key}) : super(key: key);

  @override
  State<PopularTVPage> createState() => _PopularTVPageState();
}

class _PopularTVPageState extends State<PopularTVPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<PopularTvBloc>().add(FetchPopularTvShows()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular TV Shows'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularTvBloc, PopularTvState>(
          builder: (context, state) {
            if (state is PopularTvLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PopularTvHasDataState) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.result[index];
                  return TVCard(tv);
                },
                itemCount: state.result.length,
              );
            } else if (state is PopularTvErrorState) {
              return Text(
                key: const Key('error_message'),
                state.message,
              );
            } else if (state is PopularTvInitialState) {
              return const TVNotFoundWidget(
                message: 'Popular TV Shows not found',
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
