import 'package:flutter/material.dart';
import 'package:fyp2/widgets/menu_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const MenuWidget(),
        centerTitle: true,
        title: const Text('About Us'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 170,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 12),
              child: Text(
                'What is CareNanny?',
                style: GoogleFonts.anton(fontSize: 22),
              ),
            ),
            const Divider(
              thickness: 2,
              color: Colors.black,
              indent: 10,
              endIndent: 10,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Made by student for parents , CareNanny is Malaysia’s first and preferred on-demand babysitting platform that conveniently connects parents with trained and vetted Malaysian babysitters based on their preferred time and location. Whether it’s short-term babysitting service whenever you need it, or a long-term engagement, CareNanny has your back! \n\nAvailable in Greater Klang Valley and major cities nationwide like Seremban and Johor Bahru, we provide the best childcare solutions for parents. Anytime, anywhere – Kiddocare caters to the needs of your family for a reliable babysitting service with just a click!',
                softWrap: true,
                style: GoogleFonts.roboto(fontSize: 15),
                // textAlign: TextAlign.center,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.fromLTRB(12, 20, 0, 0),
              child: Text(
                'Our Mission',
                style: GoogleFonts.anton(fontSize: 22),
              ),
            ),
            const Divider(
              thickness: 2,
              color: Colors.black,
              indent: 10,
              endIndent: 10,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                    '•  Contribute to nation building by providing the right nurturing and care for children. \n' +
                    '•  Provide the best childcare solutions for different kinds of needs' +
                    '•  Application of technology in making childcare convenient and reliable. \n' +
                    '•  Empower women economically with childcare skills and flexible employment. \n' +
                    '•  Establish a collaborative childcare platform that benefits parents, children, employers and ultimately, the childcare industry. \n',
                softWrap: true,
                style: GoogleFonts.roboto(fontSize: 15),
                // textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
