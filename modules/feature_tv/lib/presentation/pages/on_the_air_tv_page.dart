import 'package:feature_tv/presentation/blocs/on_the_air_tv/on_the_air_tv_bloc.dart';
import 'package:feature_tv/presentation/widgets/tv_card_list.dart';
import 'package:feature_tv/presentation/widgets/tv_not_found_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnTheAirTVPage extends StatefulWidget {
  const OnTheAirTVPage({Key? key}) : super(key: key);

  @override
  State<OnTheAirTVPage> createState() => _OnTheAirTVPageState();
}

class _OnTheAirTVPageState extends State<OnTheAirTVPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<OnTheAirTvBloc>().add(FetchOnTheAirTvShows()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TV Shows'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<OnTheAirTvBloc, OnTheAirTvState>(
          builder: (context, state) {
            if (state is OnTheAirTvLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OnTheAirTvHasDataState) {
              return ListView.builder(
                itemCount: state.result.length,
                itemBuilder: (context, index) {
                  final tv = state.result[index];
                  return TVCard(tv);
                },
              );
            } else if (state is OnTheAirTvErrorState) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            } else if (state is OnTheAirTvInitialState) {
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
