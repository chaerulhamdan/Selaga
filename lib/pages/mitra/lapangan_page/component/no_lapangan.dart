import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selaga_ver1/repositories/models/arguments.dart';
import 'package:selaga_ver1/repositories/models/venue_model.dart';

class NoLapangan extends StatelessWidget {
  final VenueModel venue;
  final List<Lapangan> myLapangan;
  const NoLapangan({
    super.key,
    required this.myLapangan,
    required this.venue,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Anda belum menambahkan Lapangan',
            style: TextStyle(color: Colors.grey[700]),
          ),
          const SizedBox(width: 2),
          TextButton(
            onPressed: () {
              ArgumentsMitra args = ArgumentsMitra(
                  venueId: venue.id,
                  venue: venue,
                  lapangan: Lapangan(
                    venueId: venue.id,
                    nameLapangan: 'no name',
                    // createdAt: DateTime.now(),
                    days: DateTime.now(),
                    hour: '0',
                    id: 0,
                    // updatedAt: DateTime.now(),
                    // deletedAt: null
                  ),
                  selectedDateIndex: 0,
                  listLapangan: myLapangan,
                  listJadwal: []);
              args.toJson();

              // print(args);
              context.goNamed('mitra_tambah_lapangan', extra: args);
            },
            child: const Text(
              'Tambah disini',
              style: TextStyle(
                color: Color.fromRGBO(76, 76, 220, 1),
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
