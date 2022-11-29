import 'package:core/core.dart';
import 'package:feature_tv/presentation/blocs/search_tv/search_tv_bloc.dart';
import 'package:feature_tv/presentation/widgets/tv_card_list.dart';
import 'package:feature_tv/presentation/widgets/tv_not_found_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchTVPage extends StatelessWidget {
  const SearchTVPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Search TV Shows'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                onChanged: (query) => context
                    .read<SearchTvBloc>()
                    .add(OnQueryTvChange(query: query)),
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
              BlocBuilder<SearchTvBloc, SearchTvState>(
                builder: (context, state) {
                  if (state is SearchTvLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SearchTvHasDataState) {
                    final result = state.result;

                    if (result.isEmpty) {
                      return const Expanded(
                        child: TVNotFoundWidget(message: 'TV Show not found'),
                      );
                    }
                    return Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemBuilder: (context, index) {
                          final tv = result[index];
                          return TVCard(tv);
                        },
                        itemCount: result.length,
                      ),
                    );
                  } else if (state is SearchTvErrorState) {
                    return Center(
                        child: Text(
                      key: const Key('error_message'),
                      state.message,
                    ));
                  } else if (state is SearchTvInitialState) {
                    return const Expanded(
                      child: TVNotFoundWidget(message: 'TV Show not found'),
                    );
                  } else {
                    return const Center(child: Text('Error BLoC'));
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
