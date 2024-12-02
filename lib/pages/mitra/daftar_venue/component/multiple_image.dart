import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SelectMultipleImages extends StatelessWidget {
  final Function()? onTap;
  const SelectMultipleImages({
    super.key,
    required List<XFile>? imageFileList,
    this.onTap,
  }) : _imageFileList = imageFileList;

  final List<XFile>? _imageFileList;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: InkWell(
              onTap: onTap,
              child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10)),
                  child: const Center(
                    child: Icon(
                      Icons.file_upload_outlined,
                      size: 30,
                    ),
                  )),
            )),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _imageFileList?.length ?? 0,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: SizedBox(
                    width: 150,
                    child: Image.file(
                      File(_imageFileList![index].path),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
