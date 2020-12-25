import 'package:flutter/material.dart';

class Panels extends StatefulWidget {
  final AnimationController controller;
  Panels({this.controller});

  @override
  _PanelsState createState() => _PanelsState();
}

class _PanelsState extends State<Panels> {
  static const header_height = 32.0;

  Animation<RelativeRect> getPanelAnimation(BoxConstraints boxConstraints) {
    final height = boxConstraints.biggest.height;
    final backPanelHeight = height - header_height;
    final frontPanelHeight = -header_height; //Height from bottom

    return RelativeRectTween(
      begin: RelativeRect.fromLTRB(0, backPanelHeight, 0, frontPanelHeight),
      end: RelativeRect.fromLTRB(0, 0, 0, 0),
    ).animate(CurvedAnimation(parent: widget.controller, curve: Curves.linear));
  }

  Widget buildPanels(BuildContext context, BoxConstraints constraints) {
    final ThemeData theme = Theme.of(context);

    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            color: theme.primaryColor,
            child: Center(
              child: Text(
                "Back Panel",
                style: TextStyle(fontSize: 24.0, color: Colors.white),
              ),
            ),
          ),
          PositionedTransition(
            rect: getPanelAnimation(constraints),
            child: Material(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16.0),
                topLeft: Radius.circular(16.0),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    height: header_height,
                    child: Center(
                      child: Text(
                        "Front Panel header",
                        style: Theme.of(context).textTheme.button,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Front Panel",
                        style: TextStyle(fontSize: 24.0, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: buildPanels);
  }
}
