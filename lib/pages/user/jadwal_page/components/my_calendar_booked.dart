import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:selaga_ver1/repositories/providers.dart';

class MyJadwalCalendar extends StatefulWidget {
  const MyJadwalCalendar({
    super.key,
  });

  @override
  State<MyJadwalCalendar> createState() => _MyJadwalCalendarState();
}

class _MyJadwalCalendarState extends State<MyJadwalCalendar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(19, 76, 76, 220)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                  '${DateFormat('MMMM').format(DateTime.now())} ${DateTime.now().year}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 80,
                width: 222,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              Provider.of<SelectedDate>(context, listen: false)
                                  .getSelectedIndex(index);
                            });
                          },
                          child: Container(
                              width: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Provider.of<SelectedDate>(context,
                                                listen: true)
                                            .selectedIndex ==
                                        index
                                    ? const Color.fromRGBO(76, 76, 220, 1)
                                    : const Color.fromARGB(61, 76, 76, 220),
                              ),
                              child: index == 0
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${DateTime.now().day}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                            DateFormat('EEE')
                                                .format(DateTime.now()),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold))
                                      ],
                                    )
                                  : index == 1
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              DateFormat('d').format(
                                                DateTime(
                                                    DateTime.now().year,
                                                    DateTime.now().month,
                                                    DateTime.now().day + 1),
                                              ),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                DateFormat('EEE').format(
                                                    DateTime(
                                                        DateTime.now().year,
                                                        DateTime.now().month,
                                                        DateTime.now().day +
                                                            1)),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ],
                                        )
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              DateFormat('d').format(
                                                DateTime(
                                                    DateTime.now().year,
                                                    DateTime.now().month,
                                                    DateTime.now().day + 2),
                                              ),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                DateFormat('EEE').format(
                                                    DateTime(
                                                        DateTime.now().year,
                                                        DateTime.now().month,
                                                        DateTime.now().day +
                                                            2)),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ],
                                        ))),
                    );
                  },
                ),
              ),
            ],
          ),
          Column(
            children: [
              const Text('Tanggal yang dipilih'),
              Text(
                DateFormat('dd MMMM yyyy').format(DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day +
                        Provider.of<SelectedDate>(context, listen: false)
                            .selectedIndex)),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
