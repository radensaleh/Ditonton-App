import 'package:core/core.dart';
import 'package:feature_movie/presentation/blocs/search_movie_bloc.dart';
import 'package:feature_movie/presentation/widgets/movie_card_list.dart';
import 'package:feature_movie/presentation/widgets/movie_not_found_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchMoviePage extends StatelessWidget {
  const SearchMoviePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Search Movies'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                onChanged: (query) {
                  context
                      .read<SearchMovieBloc>()
                      .add(OnQueryChanged(query: query));
                },
                decoration: const InputDecoration(
                  hintText: 'Search title',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.search,
              ),
              const SizedBox(height: 16),
              Text(
                'Search Result',
                style: kHeading6,
              ),
              BlocBuilder<SearchMovieBloc, SearchMovieState>(
                builder: (context, state) {
                  if (state is SearchMovieLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SearchMovieHasDataState) {
                    final result = state.result;
                    if (result.isEmpty) {
                      return const Expanded(
                        child: MovieNotFoundWidget(
                          message: 'Movie Not Found',
                        ),
                      );
                    }
                    return Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          final movie = state.result[index];
                          return MovieCard(movie);
                        },
                        itemCount: result.length,
                      ),
                    );
                  } else if (state is SearchMovieEmptyState) {
                    return const Expanded(
                      child: MovieNotFoundWidget(
                        message: 'Movie Not Found',
                      ),
                    );
                  } else if (state is SearchMovieErrorState) {
                    return Center(
                        child: Text(
                      key: const Key('error_message'),
                      state.message,
                    ));
                  } else {
                    return Expanded(
                      child: Container(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
