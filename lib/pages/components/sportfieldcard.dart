import 'package:flutter/material.dart';
import 'package:selaga_ver1/pages/components/format.dart';

class SportsFieldCard extends StatelessWidget {
  final String fieldName;
  final String? fieldImage;
  final String fieldLocation;
  final String fieldPrice;
  final String fieldRating;
  final int totalOrders;
  final VoidCallback onPressed;

  const SportsFieldCard({
    super.key,
    required this.fieldName,
    required this.fieldImage,
    required this.fieldLocation,
    required this.onPressed,
    required this.fieldPrice,
    required this.fieldRating,
    required this.totalOrders,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 270,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8)),
                  child: fieldImage != null
                      ? Image.network(
                          fieldImage!,
                          // width: MediaQuery.of(context).size.width,
                          // height: 100,
                          fit: BoxFit.fill,
                        )
                      : Container(
                          // width: MediaQuery.of(context).size.width,
                          // height: 100,
                          decoration: const BoxDecoration(color: Colors.grey),
                          child: const Icon(Icons.error_outline),
                        )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fieldName,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                    // maxLines: 1,
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    fieldLocation,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Color.fromARGB(255, 77, 77, 77),
                    ),
                    // maxLines: 1,
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            CurrencyFormat.convertToIdr(
                                double.parse(fieldPrice)),
                            style: const TextStyle(
                                fontSize: 14.0,
                                color: Color.fromRGBO(76, 76, 220, 1),
                                fontWeight: FontWeight.bold),
                            // maxLines: 1,
                          ),
                          const Text(
                            ' /jam',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Color.fromARGB(255, 77, 77, 77),
                            ),
                            // maxLines: 1,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Color.fromARGB(255, 255, 230, 3),
                            size: 20,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(double.parse(fieldRating).toStringAsFixed(2)),
                          Text('  ($totalOrders)')
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
