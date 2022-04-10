import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../indicator.dart';

class Religion extends StatefulWidget {
  final dynamic doc;
  const Religion({Key key, this.doc}) : super(key: key);

  @override
  _ReligionState createState() => _ReligionState();
}

class _ReligionState extends State<Religion> {
  int touchedIndex = -1;
  List religion;

  @override
  Widget build(BuildContext context) {
    religion = cal();
    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        elevation: 10,
        margin: const EdgeInsets.all(5),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
                  'Religion',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
            Row(
              children: <Widget>[
                const SizedBox(
                  height: 18,
                ),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: PieChart(
                      PieChartData(
                          pieTouchData: PieTouchData(touchCallback:
                              (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                touchedIndex = -1;
                                return;
                              }
                              touchedIndex = pieTouchResponse
                                  .touchedSection.touchedSectionIndex;
                            });
                          }),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 0,
                          centerSpaceRadius: 40,
                          sections: showingSections()),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    
                    SizedBox(
                      height: 10,
                    ),
                    Indicator(
                      color: Color(0xff0293ee),
                      text: 'Buddha',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Indicator(
                      color: Color(0xfff8b250),
                      text: 'Muslim',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Indicator(
                      color: Color(0xff845bef),
                      text: 'Hindu',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Indicator(
                      color: Color(0xFFD31313),
                      text: 'Christian',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Indicator(
                      color: Color(0xff13d38e),
                      text: 'Others...',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 18,
                    ),
                  ],
                ),
                const SizedBox(
                  width: 28,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List cal() {
    var data = widget.doc;
    double b = 0;
    double h = 0;
    double m = 0;
    double c = 0;
    double o = 0;
    List religion = [];
    for (var i = 0; i < data.length; i++) {
      if (data[i]['religion'] == 'Buddha') {
        b++;
      }
      if (data[i]['religion'] == 'Hindu') {
        h++;
      }
      if (data[i]['religion'] == 'Muslim') {
        m++;
      }
      if (data[i]['religion'] == 'Christian') {
        c++;
      }
      if (data[i]['religion'] == 'Others...') {
        o++;
      }
    }
    religion.addAll([b,m,h,c,o]);
    return religion;
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 12.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: religion[0],
            title: religion[0].toStringAsFixed(0),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: religion[1],
            title: religion[1].toStringAsFixed(0),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: religion[2],
            title: religion[2].toStringAsFixed(0),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xFFD31313),
            value: religion[2],
            title: religion[2].toStringAsFixed(0),
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
          case 4:
          return PieChartSectionData(
            color: const Color(0xff13d38e),
            value: religion[3],
            title: religion[3].toStringAsFixed(0),
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          throw Error();
      }
    });
  }
}
