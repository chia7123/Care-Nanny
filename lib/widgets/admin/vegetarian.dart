import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../indicator.dart';

class Vegatarian extends StatefulWidget {
  final dynamic doc;
  const Vegatarian({Key key, this.doc}) : super(key: key);

  @override
  _VegatarianState createState() => _VegatarianState();
}

class _VegatarianState extends State<Vegatarian> {
  int touchedIndex = -1;
  List<double> noVegan;

  @override
  Widget build(BuildContext context) {
    noVegan = cal();
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
              'Vegetarian',
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
                      text: 'Vegetarian',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Indicator(
                      color: Color(0xfff8b250),
                      text: 'Non-Vegetarian',
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

  List<double> cal() {
    var data = widget.doc;
    double vegan = 0;
    double non_vegan = 0;
    List<double> no_vegan = [];
    for (var i = 0; i < data.length; i++) {
      if (data[i]['vegan'] == true) {
        vegan++;
      } else {
        non_vegan++;
      }
    }
    no_vegan.addAll([vegan, non_vegan]);
    return no_vegan;
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 12.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: noVegan[0],
            title: noVegan[0].toStringAsFixed(0),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: noVegan[1],
            title: noVegan[1].toStringAsFixed(0),
            radius: radius,
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
