import 'package:go_router/go_router.dart';
import 'package:selaga_ver1/pages/landing_page.dart';
import 'package:selaga_ver1/pages/mitra/confirmation_page/confirmation_detail_page.dart';
import 'package:selaga_ver1/pages/mitra/daftar_venue/daftar_venue_page.dart';
import 'package:selaga_ver1/pages/mitra/detail_lapangan/component/edit_jadwal.dart';
import 'package:selaga_ver1/pages/mitra/detail_lapangan/detail_lapangan_page.dart';
import 'package:selaga_ver1/pages/mitra/homepage/component/edit_venue.dart';
import 'package:selaga_ver1/pages/mitra/lapangan_page/component/edit_lapangan.dart';
import 'package:selaga_ver1/pages/mitra/lapangan_page/component/tambah_lapangan.dart';
import 'package:selaga_ver1/pages/mitra/lapangan_page/lapangan_page.dart';
import 'package:selaga_ver1/pages/mitra/mitra_login_page.dart';
import 'package:selaga_ver1/pages/mitra/mitra_navigation_page.dart';
import 'package:selaga_ver1/pages/mitra/mitra_register_page.dart';
import 'package:selaga_ver1/pages/mitra/success_daftar_lapangan_page.dart';
import 'package:selaga_ver1/pages/mitra/success_daftar_venue_page.dart';
import 'package:selaga_ver1/pages/mitra/success_edit_lapangan_page.dart';
import 'package:selaga_ver1/pages/mitra/success_edit_venue_page.dart';
import 'package:selaga_ver1/pages/mitra/venue_detail/venue_detail_page.dart';
import 'package:selaga_ver1/pages/user/booking_page/booking_page.dart';
import 'package:selaga_ver1/pages/user/booking_page/component/choose_jadwal.dart';
import 'package:selaga_ver1/pages/user/booking_page/success_booking_page.dart';
import 'package:selaga_ver1/pages/user/home_page/sortby_page/detail_populer_page.dart';
import 'package:selaga_ver1/pages/user/home_page/sortby_page/detail_rating_page.dart';
import 'package:selaga_ver1/pages/user/payment_page/confirmation_page.dart';
import 'package:selaga_ver1/pages/user/home_page/detail_page.dart';
import 'package:selaga_ver1/pages/user/home_page_navigations.dart';
import 'package:selaga_ver1/pages/user/login_page.dart';
import 'package:selaga_ver1/pages/user/payment_page/confirm_payment_page.dart';
import 'package:selaga_ver1/pages/user/payment_page/payment_page.dart';
import 'package:selaga_ver1/pages/user/register_page.dart';
import 'package:selaga_ver1/pages/user/riwayat_page/detail_riwayat_page.dart';
import 'package:selaga_ver1/repositories/models/arguments.dart';

class MyRoutes {
  final _router = GoRouter(
    routes: [
      GoRoute(
          path: '/',
          name: 'landing_page',
          builder: (context, state) => const LandingPage(),
          routes: [
            GoRoute(
              path: 'userLogin',
              name: 'user_login',
              builder: (context, state) => const LoginPage(),
            ),
            GoRoute(
              path: 'userRegister',
              name: 'user_register',
              builder: (context, state) => const RegisterPage(),
            ),
            GoRoute(
              path: 'mitraLogin',
              name: 'mitra_login',
              builder: (context, state) => const MitraLoginPage(),
            ),
            GoRoute(
              path: 'mitraRegister',
              name: 'mitra_register',
              builder: (context, state) => const MitraRegisterPage(),
            ),
            GoRoute(
              path: 'userBookingLapanganSuccess',
              name: 'user_booking_lapangan_success',
              builder: (context, state) => const SuccesssBookingLapanganPage(),
            ),
            GoRoute(
              path: 'mitraDaftarVenueSuccess',
              name: 'mitra_daftar_venue_success',
              builder: (context, state) => const SuccesssDaftarVenuePage(),
            ),
            GoRoute(
              path: 'mitraEditVenueSuccess',
              name: 'mitra_edit_venue_success',
              builder: (context, state) => const SuccessEditVenuePage(),
            ),
          ]),
      GoRoute(
        path: '/userHome',
        name: 'user_home',
        builder: (context, state) => const HomePageNavigation(),
        routes: [
          GoRoute(
            path: 'userDetailPemesanan',
            name: 'user_detail_pemesanan',
            builder: (context, state) => const DetailRiwayatPage(),
          ),
          GoRoute(
            path: 'userListVenueByRating',
            name: 'user_venue_byrating',
            builder: (context, state) => const ListRatingVanuePage(),
          ),
          GoRoute(
            path: 'userListVenueByPopuler',
            name: 'user_venue_bypopuler',
            builder: (context, state) => const ListPopulerVanuePage(),
          ),
          GoRoute(
              path: 'userDetailVenue',
              name: 'user_detail_venue',
              builder: (context, state) => const FieldDetailPage(),
              routes: [
                GoRoute(
                    path: 'userVenueLapangan',
                    name: 'user_venue_lapangan',
                    builder: (context, state) {
                      ArgumentsUser args = state.extra as ArgumentsUser;
                      return BookingPage(venue: args.venue);
                    },
                    routes: [
                      GoRoute(
                          path: 'userLapanganDetail',
                          name: 'user_lapangan_detail',
                          builder: (context, state) {
                            ArgumentsUser args = state.extra as ArgumentsUser;
                            return ChooseJadwalPage(
                                myJadwal: args.listJadwal ?? [],
                                lapangan: args.lapangan,
                                venue: args.venue);
                          },
                          routes: [
                            GoRoute(
                                path: 'userLapanganConfirmation',
                                name: 'user_lapangan_confirmation',
                                builder: (context, state) {
                                  ArgumentsUser args =
                                      state.extra as ArgumentsUser;
                                  return DetailConfirmationPage(
                                      myJadwal: args.listJadwal ?? [],
                                      lapangan: args.lapangan,
                                      venue: args.venue);
                                },
                                routes: [
                                  GoRoute(
                                      path: 'userLapanganPayment',
                                      name: 'user_lapangan_payment',
                                      builder: (context, state) {
                                        ArgumentsUser args =
                                            state.extra as ArgumentsUser;
                                        return PaymentPage(
                                            myJadwal: args.listJadwal ?? [],
                                            lapangan: args.lapangan,
                                            venue: args.venue);
                                      },
                                      routes: [
                                        GoRoute(
                                          path: 'userConfirmPayment',
                                          name: 'user_confirm_payment',
                                          builder: (context, state) {
                                            ArgumentsUser args =
                                                state.extra as ArgumentsUser;
                                            return ConfirmPayment(
                                                myJadwal: args.listJadwal ?? [],
                                                lapangan: args.lapangan,
                                                venue: args.venue);
                                          },
                                        )
                                      ])
                                ]),
                          ]),
                    ])
              ])
        ],
      ),
      GoRoute(
          path: '/mitraHome',
          name: 'mitra_home',
          builder: (context, state) => const MitraHomePageNavigation(),
          routes: [
            GoRoute(
              path: 'mitraEditVenue',
              name: 'mitra_edit_venue',
              builder: (context, state) => const EditVenueHandler(),
            ),
            GoRoute(
              path: 'mitraDetailKonfirmasi',
              name: 'mitra_detail_konfirmasi',
              builder: (context, state) => const MitraDetailConfirmation(),
            ),
            GoRoute(
              path: 'mitraDaftarVenue',
              name: 'mitra_daftar_venue',
              builder: (context, state) => const DaftarVenuePage(),
            ),
            GoRoute(
                path: 'mitraDetailVenue',
                name: 'mitra_detail_venue',
                builder: (context, state) {
                  ArgumentsMitra args = state.extra as ArgumentsMitra;
                  return MitraDetailPage(venueId: args.venueId!);
                },
                routes: [
                  GoRoute(
                      path: 'myLapangPage',
                      name: 'mitra_lapangan_page',
                      builder: (context, state) {
                        ArgumentsMitra args = state.extra as ArgumentsMitra;
                        return MyLapanganPage(
                          venue: args.venue!,
                        );
                      },
                      routes: [
                        GoRoute(
                          path: 'mitraDaftarLapanganSuccess',
                          name: 'mitra_daftar_lapangan_success',
                          builder: (context, state) {
                            ArgumentsMitra args = state.extra as ArgumentsMitra;
                            return SuccesssDaftarLapanganPage(
                                venue: args.venue!);
                          },
                        ),
                        GoRoute(
                          path: 'mitraEditLapanganSuccess',
                          name: 'mitra_edit_lapangan_success',
                          builder: (context, state) {
                            ArgumentsMitra args = state.extra as ArgumentsMitra;
                            return SuccessEditLapanganPage(venue: args.venue!);
                          },
                        ),
                        GoRoute(
                          path: 'tambahLapangan',
                          name: 'mitra_tambah_lapangan',
                          builder: (context, state) {
                            ArgumentsMitra args = state.extra as ArgumentsMitra;
                            return TambahLapanganPage(
                              venue: args.venue!,
                              myLapangan: args.listLapangan ?? [],
                            );
                          },
                        ),
                        GoRoute(
                          path: 'editLapangan',
                          name: 'mitra_edit_lapangan',
                          builder: (context, state) {
                            ArgumentsMitra args = state.extra as ArgumentsMitra;
                            return EditMyLapanganPage(
                              venue: args.venue!,
                              myLapangan: args.lapangan!,
                            );
                          },
                        ),
                        GoRoute(
                            path: 'myLapanganDetail',
                            name: 'mitra_lapangan_detail',
                            builder: (context, state) {
                              ArgumentsMitra args =
                                  state.extra as ArgumentsMitra;
                              return DetailLapanganPage(
                                  lapangan: args.lapangan!,
                                  venue: args.venue!,
                                  selectedDateIndex: args.selectedDateIndex!);
                            },
                            routes: [
                              GoRoute(
                                path: 'editJadwalLapangan',
                                name: 'mitra_edit_jadwal_lapangan',
                                builder: (context, state) {
                                  ArgumentsMitra args =
                                      state.extra as ArgumentsMitra;
                                  return EditJadwalPage(
                                    venue: args.venue!,
                                    lapangan: args.lapangan!,
                                    myJadwal: args.listJadwal ?? [],
                                    selectedDateIndex: args.selectedDateIndex,
                                  );
                                },
                              ),
                            ])
                      ]),
                ]),
          ]),
    ],
    initialLocation: '/',
    routerNeglect: true,
    debugLogDiagnostics: true,
  );

  GoRouter get router => _router;
}
