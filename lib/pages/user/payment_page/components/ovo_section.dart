import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:selaga_ver1/repositories/models/arguments.dart';
import 'package:selaga_ver1/repositories/models/lapangan_model.dart';
import 'package:selaga_ver1/repositories/models/venue_model.dart';
import 'package:selaga_ver1/repositories/providers.dart';

class OvoSection extends StatelessWidget {
  const OvoSection({
    super.key,
    required this.myJadwal,
    required this.lapangan,
    required this.venue,
  });

  final List<JadwalLapanganModel> myJadwal;
  final Lapangan lapangan;
  final VenueModel venue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ovo',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Virtual Account',
                  style: TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'Ketentuan:',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                const Row(
                  children: [
                    Text('•',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      child: Text(
                        'Salin nomer virtual account dibawah ini dan bayarkan sesuai dengan tagihan yang tertera',
                      ),
                    ),
                  ],
                ),
                const Row(
                  children: [
                    Text('•',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      child: Text(
                        'lalu capture bukti pembayaran',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                const Row(
                  children: [
                    Text('•',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      child: Text(
                        'masukan bukti pembayaran di tahap selanjutnya',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                const Row(
                  children: [
                    Text('•',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      child: Text(
                        'Tagihan yang tertera belum termasuk biaya\nadministrasi',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'Nomer virtual account',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '12345678',
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        // Clipboard functionality
                      },
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Rp ${venue.price ?? 0}',
                      style: const TextStyle(
                          fontSize: 16.0,
                          color: Color.fromRGBO(76, 76, 220, 1),
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(76, 76, 220, 1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  onPressed: () {
                    Provider.of<PaymentMethod>(context, listen: false)
                        .update('OVO');
                    ArgumentsUser args = ArgumentsUser(
                        venue: venue, lapangan: lapangan, listJadwal: myJadwal);
                    args.toJson();
                    context.goNamed('user_confirm_payment', extra: args);
                  },
                  child: const Text(
                    'Lanjutkan',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  )))
        ],
      ),
    );
  }
}
