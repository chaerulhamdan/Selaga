import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:selaga_ver1/pages/mitra/homepage/home_page.dart';
import 'package:selaga_ver1/pages/mitra/confirmation_page/mitra_confirmation_page.dart';
import 'package:selaga_ver1/pages/mitra/jadwal_pesanan_page.dart';
import 'package:selaga_ver1/pages/mitra/mitra_profile_page.dart';

class MitraHomePageNavigation extends StatefulWidget {
  const MitraHomePageNavigation({super.key});

  @override
  State<MitraHomePageNavigation> createState() =>
      _MitraHomePageNavigationState();
}

class _MitraHomePageNavigationState extends State<MitraHomePageNavigation> {
  int _currentIndexPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        const MitraHomePage(),
        const PesananPage(),
        const ConfirmationPage(),
        const MitraProfilePage()
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
                icon: Icons.calendar_month_outlined,
                text: 'Pesanan',
              ),
              GButton(
                icon: Icons.view_list_rounded,
                text: 'Konfirmasi',
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
