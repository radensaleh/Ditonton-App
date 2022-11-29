import 'package:core/core.dart';
import 'package:core/presentation/pages/core_navigation_page.dart';
import 'package:core/utils/http_ssl_pinning.dart';
import 'package:ditonton/firebase_options.dart';
import 'package:feature_about/feature_about.dart';
import 'package:feature_movie/presentation/blocs/detail_movie_bloc.dart';
import 'package:feature_movie/presentation/blocs/now_playing_movie_bloc.dart';
import 'package:feature_movie/presentation/blocs/popular_movie_bloc.dart';
import 'package:feature_movie/presentation/blocs/recommendation_movie_bloc.dart';
import 'package:feature_movie/presentation/blocs/search_movie_bloc.dart';
import 'package:feature_movie/presentation/blocs/top_rated_movie_bloc.dart';
import 'package:feature_movie/presentation/blocs/watchlist_movie_bloc.dart';
import 'package:feature_movie/presentation/blocs/watchlist_status_movie_cubit.dart';
import 'package:feature_movie/presentation/pages/now_playing_movie_page.dart';
import 'package:feature_movie/presentation/pages/movie_detail_page.dart';
import 'package:feature_movie/presentation/pages/popular_movies_page.dart';
import 'package:feature_movie/presentation/pages/search_movie_page.dart';
import 'package:feature_movie/presentation/pages/top_rated_movies_page.dart';
import 'package:feature_movie/presentation/pages/watchlist_movies_page.dart';
import 'package:feature_tv/presentation/blocs/detail_tv/detail_tv_bloc.dart';
import 'package:feature_tv/presentation/blocs/on_the_air_tv/on_the_air_tv_bloc.dart';
import 'package:feature_tv/presentation/blocs/popular_tv/popular_tv_bloc.dart';
import 'package:feature_tv/presentation/blocs/recommendation_tv/recommendation_tv_bloc.dart';
import 'package:feature_tv/presentation/blocs/search_tv/search_tv_bloc.dart';
import 'package:feature_tv/presentation/blocs/season_detail_tv/season_detail_tv_bloc.dart';
import 'package:feature_tv/presentation/blocs/top_rated_tv/top_rated_tv_bloc.dart';
import 'package:feature_tv/presentation/blocs/watchlist_status_tv/watchlist_status_tv_cubit.dart';
import 'package:feature_tv/presentation/blocs/watchlist_tv/watchlist_tv_bloc.dart';
import 'package:feature_tv/presentation/pages/on_the_air_tv_page.dart';
import 'package:feature_tv/presentation/pages/popular_tv_page.dart';
import 'package:feature_tv/presentation/pages/search_tv_page.dart';
import 'package:feature_tv/presentation/pages/top_rated_tv_page.dart';
import 'package:feature_tv/presentation/pages/tv_detail_page.dart';
import 'package:feature_tv/presentation/pages/tv_season_detail_page.dart';
import 'package:feature_tv/presentation/pages/watchlist_tv_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  await HttpSSLPinning.init();
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.locator<NowPlayingMovieBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<DetailMovieBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularMovieBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<RecommendationMovieBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedMovieBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchMovieBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistMovieBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistStatusMovieCubit>(),
        ),
        // TV Shows
        BlocProvider(
          create: (_) => di.locator<OnTheAirTvBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularTvBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedTvBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<RecommendationTvBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchTvBloc>(),
        ),
        BlocProvider(
          create: (context) => di.locator<DetailTvBloc>(),
        ),
        BlocProvider(
          create: (context) => di.locator<SeasonDetailTvBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistTvBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistStatusTvCubit>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        home: CoreNavigationPage(),
        debugShowCheckedModeBanner: false,
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case MOVIE_NOW_PLAYING_ROUTE:
              return MaterialPageRoute(builder: (_) => NowPlayingMoviePage());
            case MOVIE_POPULAR_ROUTE:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case MOVIE_TOP_RATED_ROUTE:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case MOVIE_DETAIL_ROUTE:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case MOVIE_SEARCH_ROUTE:
              return CupertinoPageRoute(builder: (_) => SearchMoviePage());
            case MOVIE_WATCHLIST_ROUTE:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case ABOUT_ROUTE:
              return MaterialPageRoute(builder: (_) => AboutPage());
            // TV Shows
            case TV_ON_THE_AIR_ROUTE:
              return MaterialPageRoute(builder: (_) => OnTheAirTVPage());
            case TV_POPULAR_ROUTE:
              return MaterialPageRoute(builder: (_) => PopularTVPage());
            case TV_TOP_RATED_ROUTE:
              return MaterialPageRoute(builder: (_) => TopRatedTVPage());
            case TV_WATCHLIST_ROUTE:
              return MaterialPageRoute(builder: (_) => WatchlistTVPage());
            case TV_SEARCH_ROUTE:
              return MaterialPageRoute(builder: (_) => SearchTVPage());
            case TV_DETAIL_ROUTE:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TVDetailPage(id: id),
                settings: settings,
              );
            case TV_SEASON_DETAIL_ROUTE:
              final args = settings.arguments as Map;
              return MaterialPageRoute(
                builder: (_) => TVSeasonDetailPage(
                  tvId: args['tvId'],
                  seasonNumber: args['seasonNumber'],
                ),
                settings: settings,
              );
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
