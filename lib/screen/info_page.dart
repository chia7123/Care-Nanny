import 'package:flutter/material.dart';
import 'package:fyp2/screen/wrapper.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoPage extends StatelessWidget {
  InfoPage({Key key, this.imgUrl, this.msg, this.color}) : super(key: key);
  final String imgUrl;
  final String msg;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Spacer(
            flex: 2,
          ),
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitHeight,
                image: AssetImage(imgUrl),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          Text(
            msg,
            style: GoogleFonts.raleway(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(
            flex: 2,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Wrapper(),
                    ));
              },
              child: const Text(
                'Back to Home',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: color,
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          )
        ],
      ),
    );
  }
}
