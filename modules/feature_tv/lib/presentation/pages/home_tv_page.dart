import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:feature_tv/domain/entities/tv.dart';
import 'package:feature_tv/presentation/blocs/on_the_air_tv/on_the_air_tv_bloc.dart';
import 'package:feature_tv/presentation/blocs/popular_tv/popular_tv_bloc.dart';
import 'package:feature_tv/presentation/blocs/top_rated_tv/top_rated_tv_bloc.dart';
import 'package:feature_tv/presentation/widgets/sub_heading_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeTVPage extends StatefulWidget {
  const HomeTVPage({Key? key}) : super(key: key);

  @override
  State<HomeTVPage> createState() => _HomeTVPageState();
}

class _HomeTVPageState extends State<HomeTVPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () {
        context.read<OnTheAirTvBloc>().add(FetchOnTheAirTvShows());
        context.read<PopularTvBloc>().add(FetchPopularTvShows());
        context.read<TopRatedTvBloc>().add(FetchTopRatedTvShows());
      },
    );
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
              title: 'TV Shows',
              onTap: () => Navigator.pushNamed(context, TV_ON_THE_AIR_ROUTE),
            ),
            BlocBuilder<OnTheAirTvBloc, OnTheAirTvState>(
                builder: (context, state) {
              if (state is OnTheAirTvLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is OnTheAirTvHasDataState) {
                return TVList(state.result);
              } else if (state is OnTheAirTvErrorState) {
                return Text(state.message);
              } else if (state is OnTheAirTvInitialState) {
                return const Text('Data Not Found');
              } else {
                return const Text('Error BLoC');
              }
            }),
            SubHeadingText(
              title: 'Popular TV Shows',
              onTap: () => Navigator.pushNamed(context, TV_POPULAR_ROUTE),
            ),
            BlocBuilder<PopularTvBloc, PopularTvState>(
                builder: (context, state) {
              if (state is PopularTvLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is PopularTvHasDataState) {
                return TVList(state.result);
              } else if (state is PopularTvErrorState) {
                return Text(state.message);
              } else if (state is PopularTvInitialState) {
                return const Text('Data Not Found');
              } else {
                return const Text('Error BLoC');
              }
            }),
            SubHeadingText(
              title: 'Top Rated TV Shows',
              onTap: () => Navigator.pushNamed(context, TV_TOP_RATED_ROUTE),
            ),
            BlocBuilder<TopRatedTvBloc, TopRatedTvState>(
                builder: (context, state) {
              if (state is TopRatedTvLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is TopRatedTvHasDataState) {
                return TVList(state.result);
              } else if (state is TopRatedTvErrorState) {
                return Center(child: Text(state.message));
              } else if (state is TopRatedTvInitialState) {
                return const Text('Data Not Found');
              } else {
                return const Text('Error BLoC');
              }
            }),
          ],
        ),
      ),
    );
  }
}

class TVList extends StatelessWidget {
  final List<TV> tvs;

  const TVList(this.tvs, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tvs.length,
        itemBuilder: (context, index) {
          final tv = tvs[index];
          return Container(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () => Navigator.pushNamed(
                context,
                TV_DETAIL_ROUTE,
                arguments: tv.id,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(16.0),
                ),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
