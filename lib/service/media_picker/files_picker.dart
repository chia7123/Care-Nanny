import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FilesPicker extends StatefulWidget {
  FilesPicker({Key key, this.fileSelectFn}) : super(key: key);
  final Function(List<PlatformFile> pickedImage) fileSelectFn;

  @override
  State<FilesPicker> createState() => _FilesPickerState();
}

class _FilesPickerState extends State<FilesPicker> {
  List<PlatformFile> files;

  Widget buttonWidget(IconData icon, String text, VoidCallback function) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              )
            ],
          ),
        ),
        files != null
            ? SizedBox(
                height: 100,
                child: ListView.builder(
                  
                    itemCount: files.length,
                    itemBuilder: (context, index) {
                      var kb = files[index].size / 1024;
                      var mb = kb / 1024;
                      var size = (mb > 1)
                          ? '${mb.toStringAsFixed(2)} MB'
                          : '${kb.toStringAsFixed(2)} KB';

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(files[index].name),
                          Text(size),
                        ],
                      );
                    }),
              )
            : const SizedBox()
      ],
    );
  }

  Future _selectFile() async {
    try{
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
    }
     catch(e){
      Fluttertoast.showToast(msg: 'Failed to select the file :$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return buttonWidget(Icons.attach_file, 'Attach File', _selectFile);
  }
}
