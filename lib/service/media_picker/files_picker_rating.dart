import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2/service/videos/video_player.dart';
import 'package:fyp2/service/videos/video_widget.dart';
import 'package:fyp2/widgets/full_screen_image.dart';
import 'package:video_player/video_player.dart';

class FilesPickerRating extends StatefulWidget {
  FilesPickerRating({Key key, this.fileSelectFn}) : super(key: key);
  final Function(List<PlatformFile> pickedFile) fileSelectFn;

  @override
  State<FilesPickerRating> createState() => _FilesPickerRatingState();
}

class _FilesPickerRatingState extends State<FilesPickerRating> {
  List<PlatformFile> files;
  VideoPlayerController controller;

  Widget buttonWidget(IconData icon, String text, VoidCallback function) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        files != null
            ? SizedBox(
                height: 100,
                width: 300,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    if (files[index].extension == "jpg" ||
                        files[index].extension == "png") {
                      return GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullScreenImage(
                                  imagePath: File(files[index].path)),
                            )),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          height: 120,
                          width: 90,
                          child: FittedBox(
                              fit: BoxFit.fill,
                              child: Image.file(File(files[index].path))),
                        ),
                      );
                    } else {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideoPlayerPlatform(
                                    pickedVideo: File(files[index].path)),
                              ));
                        },
                        child: VideoWidget(
                          pickedVideo: File(files[index].path),
                        ),
                      );
                    }
                  },
                ),
              )
            : const SizedBox(),
        ElevatedButton(
          onPressed: function,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
              const SizedBox(
                width: 16,
              ),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future _selectFile() async {
    try {
      final results = await FilePicker.platform.pickFiles(allowMultiple: true);

      if (results == null) {
        return;
      } else {
        final paths = results.files;
        setState(() {
          files = paths;
        });
        widget.fileSelectFn(files);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to select the file :$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return buttonWidget(
        Icons.camera_alt_rounded, 'Add Photo/Video', _selectFile);
  }

}
