import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NoVenue extends StatelessWidget {
  const NoVenue({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Anda belum memiliki Venue',
            style: TextStyle(color: Colors.grey[700]),
          ),
          const SizedBox(width: 2),
          TextButton(
            onPressed: () {
              context.goNamed('mitra_daftar_venue');
            },
            child: const Text(
              'Daftar disini',
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
