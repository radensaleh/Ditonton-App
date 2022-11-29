import 'package:core/core.dart';
import 'package:feature_about/feature_about.dart';
import 'package:feature_movie/presentation/pages/home_movie_page.dart';
import 'package:feature_tv/presentation/pages/home_tv_page.dart';
import 'package:flutter/material.dart';

class CoreNavigationPage extends StatefulWidget {
  const CoreNavigationPage({super.key});

  @override
  State<CoreNavigationPage> createState() => _CoreNavigationPageState();
}

class _CoreNavigationPageState extends State<CoreNavigationPage> {
  int _selectedIndex = 0;
  bool _visibleAppBar = true;

  static const List<Widget> _pages = [
    HomeMoviePage(),
    HomeTVPage(),
    AboutPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (index == 2) {
        _visibleAppBar = false;
      } else {
        _visibleAppBar = true;
      }
    });
  }

  _onSearchTapped(int index) {
    if (index == 0) {
      Navigator.pushNamed(context, MOVIE_SEARCH_ROUTE);
    } else {
      Navigator.pushNamed(context, TV_SEARCH_ROUTE);
    }
  }

  _onWatchlistTapped(int index) {
    if (index == 0) {
      Navigator.pushNamed(context, MOVIE_WATCHLIST_ROUTE);
    } else {
      Navigator.pushNamed(context, TV_WATCHLIST_ROUTE);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Movies'),
          BottomNavigationBarItem(icon: Icon(Icons.tv), label: 'TV Series'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: kMikadoYellow,
        onTap: (value) => _onItemTapped(value),
      ),
      appBar: _visibleAppBar
          ? AppBar(
              title: Row(
                children: [
                  Image.asset(
                    'assets/circle-g.png',
                    width: 25,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 8.0),
                  const Text('Ditonton')
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: () => _onWatchlistTapped(_selectedIndex),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: kPrussianBlue,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.save_alt, size: 18),
                          SizedBox(width: 5.0),
                          Text('Watchlist'),
                        ],
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _onSearchTapped(_selectedIndex),
                  icon: const Icon(Icons.search),
                )
              ],
            )
          : null,
      body: _pages.elementAt(_selectedIndex),
    );
  }
}
