import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:feature_tv/domain/entities/genre.dart';
import 'package:feature_tv/domain/entities/tv_detail.dart';
import 'package:feature_tv/presentation/blocs/detail_tv/detail_tv_bloc.dart';
import 'package:feature_tv/presentation/blocs/recommendation_tv/recommendation_tv_bloc.dart';
import 'package:feature_tv/presentation/blocs/watchlist_status_tv/watchlist_status_tv_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TVDetailPage extends StatefulWidget {
  final int id;

  const TVDetailPage({super.key, required this.id});

  @override
  State<TVDetailPage> createState() => _TVDetailPageState();
}

class _TVDetailPageState extends State<TVDetailPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<DetailTvBloc>().add(FetchDetailTvShow(id: widget.id));
      context
          .read<RecommendationTvBloc>()
          .add(FetchRecommendationTvShow(id: widget.id));
      context.read<WatchlistStatusTvCubit>().loadWatchlistStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DetailTvBloc, DetailTvState>(
        builder: (context, state) {
          if (state is DetailTvLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DetailTvHasDataState) {
            return SafeArea(
              child: DetailContentTVShow(tv: state.result),
            );
          } else if (state is DetailTvErrorState) {
            return Center(
                child: Text(
              key: const Key('error_message'),
              state.message,
            ));
          } else if (state is DetailTvInitialState) {
            return const Center(child: Text('Data Not Found'));
          } else {
            return const Center(child: Text('Error BLoC'));
          }
        },
      ),
    );
  }
}

class DetailContentTVShow extends StatelessWidget {
  final TVDetail tv;

  const DetailContentTVShow({
    super.key,
    required this.tv,
  });

  @override
  Widget build(BuildContext context) {
    final sizeWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
          width: sizeWidth,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            minChildSize: 0.25,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16.0)),
                ),
                padding: const EdgeInsets.only(
                  top: 16,
                  left: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tv.name,
                              style: kHeading5,
                            ),
                            BlocBuilder<WatchlistStatusTvCubit,
                                    WatchlistStatusTvState>(
                                builder: (context, state) {
                              bool isAddedWatchlist = state.isAddedWatchlist;
                              return ElevatedButton(
                                onPressed: () async {
                                  if (!isAddedWatchlist) {
                                    await context
                                        .read<WatchlistStatusTvCubit>()
                                        .addWatchlistTV(tv);
                                  } else {
                                    await context
                                        .read<WatchlistStatusTvCubit>()
                                        .removeFromWatchlistTV(tv);
                                  }

                                  final message = context
                                      .read<WatchlistStatusTvCubit>()
                                      .state
                                      .message;

                                  if (message ==
                                          WatchlistStatusTvCubit
                                              .watchlistAddSuccessMessage ||
                                      message ==
                                          WatchlistStatusTvCubit
                                              .watchlistRemoveSuccessMessage) {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(message)));
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        content: Text(message),
                                      ),
                                    );
                                  }
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    isAddedWatchlist
                                        ? const Icon(Icons.check)
                                        : const Icon(Icons.add),
                                    const Text(' Watchlist'),
                                  ],
                                ),
                              );
                            }),
                            Text(_showGenres(tv.genres)),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                  itemCount: 5,
                                  rating: tv.voteAverage / 2,
                                ),
                                Text('${tv.voteAverage}'),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tv.overview == '' ? '-' : tv.overview,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '${tv.seasons.length} Seasons',
                              style: kHeading6,
                            ),
                            const SizedBox(height: 8),
                            tv.seasons.isEmpty
                                ? const Text('-')
                                : SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: tv.seasons.length,
                                      itemBuilder: (context, index) {
                                        final tvs = tv.seasons[index];

                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () =>
                                                Navigator.pushReplacementNamed(
                                              context,
                                              TV_SEASON_DETAIL_ROUTE,
                                              arguments: {
                                                'tvId': tv.id,
                                                'seasonNumber':
                                                    tvs.seasonNumber,
                                              },
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(8.0),
                                              ),
                                              child: tvs.posterPath == null
                                                  ? Image.asset(
                                                      'assets/circle-g.png',
                                                      width: 100,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : CachedNetworkImage(
                                                      imageUrl:
                                                          'https://image.tmdb.org/t/p/w500${tvs.posterPath}',
                                                      placeholder:
                                                          (context, url) =>
                                                              const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                    ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                            const SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            const SizedBox(height: 8),
                            BlocBuilder<RecommendationTvBloc,
                                    RecommendationTvState>(
                                builder: (context, state) {
                              if (state is RecommendationTvLoadingState) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (state is RecommendationTvErrorState) {
                                return Text(
                                  key: const Key('error_message'),
                                  state.message,
                                );
                              } else if (state
                                  is RecommendationTvHasDataState) {
                                final result = state.result;

                                if (result.isEmpty) {
                                  return const Text('-');
                                }
                                return SizedBox(
                                  height: 150,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: result.length,
                                    itemBuilder: (context, index) {
                                      final tv = result[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: InkWell(
                                          onTap: () =>
                                              Navigator.pushReplacementNamed(
                                            context,
                                            TV_DETAIL_ROUTE,
                                            arguments: tv.id,
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(8.0),
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  'https://image.tmdb.org/t/p/w500${tv.posterPath}',
                                              placeholder: (context, url) =>
                                                  const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else if (state
                                  is RecommendationTvInitialState) {
                                return const Text('Data Not Found');
                              } else {
                                return const Text('Error BLoC');
                              }
                            }),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }
}
