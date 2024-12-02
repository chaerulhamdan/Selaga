import 'package:flutter/material.dart';

class FasilitasBuilder extends StatelessWidget {
  const FasilitasBuilder({
    super.key,
    required this.fasilitasList,
  });

  final List<String>? fasilitasList;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: SizedBox(
        height: 35,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: fasilitasList?.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 223, 222, 222),
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(fasilitasList![index]),
                  )),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
