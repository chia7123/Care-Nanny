import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2/service/videos/video_player.dart';
import 'package:fyp2/service/videos/video_widget.dart';
import 'package:fyp2/widgets/full_screen_image.dart';
import 'package:video_player/video_player.dart';

class FilesPickerRating extends StatefulWidget {
  FilesPickerRating({Key key, this.fileSelectFn, this.videoSelectFn})
      : super(key: key);
  final Function(List<PlatformFile> pickedFile) fileSelectFn;
  final Function(List<PlatformFile> pickedFile) videoSelectFn;

  @override
  State<FilesPickerRating> createState() => _FilesPickerRatingState();
}

class _FilesPickerRatingState extends State<FilesPickerRating> {
  List<PlatformFile> files;
  List<PlatformFile> videoFiles;
  VideoPlayerController controller;

  Widget buttonWidget(IconData icon, String text, VoidCallback function) {
    return ElevatedButton(
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
    );
  }

  Widget mediaList() {
    if (files != null && videoFiles != null) {
      return Column(
        children: [
          SizedBox(
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: files.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FullScreenImage(imagePath: File(files[index].path)),
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
              },
            ),
          ),
          SizedBox(
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: videoFiles.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoPlayerPlatform(
                              pickedVideo: File(videoFiles[index].path)),
                        ));
                  },
                  child: VideoWidget(
                    pickedVideo: File(videoFiles[index].path),
                  ),
                );
              },
            ),
          ),
        ],
      );
    } else {
      if (files != null && videoFiles == null) {
        return SizedBox(
          height: 100,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: files.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FullScreenImage(imagePath: File(files[index].path)),
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
            },
          ),
        );
      } else {
        if (files == null && videoFiles != null) {
          return SizedBox(
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: videoFiles.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoPlayerPlatform(
                              pickedVideo: File(videoFiles[index].path)),
                        ));
                  },
                  child: VideoWidget(
                    pickedVideo: File(videoFiles[index].path),
                  ),
                );
              },
            ),
          );
        } else {
          return const SizedBox();
        }
      }
    }
  }

  Future _selectFile() async {
    try {
      final results = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.image,
      );

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

  Future _selectVideo() async {
    try {
      final results = await FilePicker.platform
          .pickFiles(allowMultiple: true, type: FileType.video);

      if (results == null) {
        return;
      } else {
        final paths = results.files;
        setState(() {
          videoFiles = paths;
        });
        widget.videoSelectFn(videoFiles);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to select the file :$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        mediaList(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buttonWidget(
              Icons.camera_alt_rounded,
              'Add Photo',
              _selectFile,
            ),
            buttonWidget(
              Icons.video_collection,
              'Add Video',
              _selectVideo,
            ),
          ],
        ),
      ],
    );
  }
}
