import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  final Widget child;

  const HomePage({super.key, required this.child});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<String> _routes = ['/', '/history'];
  final List<String> _titles = ['Beranda', 'Riwayat Deteksi'];

  int _locationToIndex(String location) {
    if (location.startsWith('/history')) return 1;
    return 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    try {
      final loc = GoRouterState.of(context).uri.toString();
      final idx = _locationToIndex(loc);
      if (idx != _selectedIndex) {
        setState(() => _selectedIndex = idx);
      }
    } catch (_) {}
  }

  /**
 * appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
 * **/ //
  void _onBottomItemTap(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
    context.go(_routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Beranda',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[800],
        toolbarHeight: 70.0,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
      ),
      body: widget.child,
      // bottomNavigationBar: BottomNavBar(
      //   selectedIndex: _selectedIndex,
      //   onTap: _onBottomItemTap,
      // ),
    );
  }
}
