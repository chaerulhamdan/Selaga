import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:selaga_ver1/pages/user/home_page/home_page.dart';
import 'package:selaga_ver1/pages/user/jadwal_page/my_jadwal_page.dart';
import 'package:selaga_ver1/pages/user/profile_page.dart';
import 'package:selaga_ver1/pages/user/riwayat_page/riwayat_page.dart';
import 'package:provider/provider.dart';
import 'package:selaga_ver1/repositories/providers.dart';
import 'package:selaga_ver1/shared_preference/shared_preference_repository.dart';

class HomePageNavigation extends StatefulWidget {
  const HomePageNavigation({super.key});

  @override
  State<HomePageNavigation> createState() => _HomePageNavigationState();
}

class _HomePageNavigationState extends State<HomePageNavigation> {
  int _currentIndexPage = 0;

  @override
  void initState() {
    _getData();
    super.initState();
  }

  Future<void> _getData() async {
    final SharedPreferenceRepository sharedPreferenceRepository;
    sharedPreferenceRepository = SharedPreferenceRepositoryImpl();
    final data = await sharedPreferenceRepository.getValue("token");

    if (!mounted) {
      return;
    }
    Provider.of<Token>(context, listen: false).getToken(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        const HomePage(),
        const MyJadwalBookedPage(),
        const RiwayatPage(),
        const ProfilePage()
      ][_currentIndexPage],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
          child: GNav(
            gap: 8,
            color: Colors.grey,
            activeColor: const Color.fromRGBO(76, 76, 220, 1),
            tabBackgroundColor: const Color.fromRGBO(76, 76, 220, 0.25),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: const Duration(milliseconds: 400),
            iconSize: 24,
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Beranda',
              ),
              GButton(
                icon: Icons.calendar_today_rounded,
                text: 'Jadwal',
              ),
              GButton(
                icon: Icons.view_list_rounded,
                text: 'Riwayat',
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
              )
            ],
            selectedIndex: _currentIndexPage,
            onTabChange: (index) {
              setState(() {
                _currentIndexPage = index;
              });
            },
          ),
        )),
      ),
    );
  }
}
