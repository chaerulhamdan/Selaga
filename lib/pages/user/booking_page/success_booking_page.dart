import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selaga_ver1/pages/components/my_button.dart';

class SuccesssBookingLapanganPage extends StatelessWidget {
  const SuccesssBookingLapanganPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
          body: SafeArea(
              child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 120,
                        color: Color.fromRGBO(76, 76, 220, 1),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Pembayaran Selesai!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Flexible(
                      child: SizedBox(
                        width: 200,
                        child: Text(
                          'Mohon tunggu konfirmasi dari penyewa lapangan ya..',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            MyButton(
                onTap: () {
                  context.goNamed('user_home');
                },
                buttonText: 'Kembali ke halaman utama')
          ],
        ),
      ))),
    );
  }
}
