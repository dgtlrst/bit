import 'package:bit/state_globals.dart';
import 'package:bit/state_app.dart';
import 'package:bit/terminal_wrapper.dart';
import 'package:flutter/material.dart';
import 'sidepanel.dart'; // side panel

class HomePage extends StatefulWidget {
  final AppState state;
  const HomePage({super.key, required this.state});
  @override
  State<HomePage> createState() => _CreateHomePageState();
}

class _CreateHomePageState extends State<HomePage> {
  // Update this method to accept width and height instead of calculating inside
  Widget createTerminalGrid(double width, double height) {
    Layout layout = widget.state.globalSettings.getLayout();
    List<Widget> terminals = [];
    double childAspectRatio = 1.0;  // Default positive aspect ratio
    int crossAxisCount = 1;  // Default grid column count

    print("Width: $width, Height: $height"); // Log dimensions

    // Calculate aspect only when valid dimensions are provided
    double aspect = (width > 0 && height > 0) ? width / height : 1.0;
    print("Calculated Aspect Ratio: $aspect");  // Log calculated aspect

    switch (layout) {
      case Layout.oneByOne:
        terminals = [Terminal(state: widget.state, threadId: 0)];
        childAspectRatio = aspect;
        crossAxisCount = 1;
        break;
      case Layout.oneByTwo:
        terminals = [
          Terminal(state: widget.state, threadId: 0),
          Terminal(state: widget.state, threadId: 1)
        ];
        childAspectRatio = aspect / 2;
        crossAxisCount = 2;
        break;
      case Layout.twoByOne:
        terminals = [
          Terminal(state: widget.state, threadId: 0),
          Terminal(state: widget.state, threadId: 1)
        ];
        childAspectRatio = aspect * 2;
        crossAxisCount = 1;
        break;
      case Layout.twoByTwo:
        terminals = [
          Terminal(state: widget.state, threadId: 0),
          Terminal(state: widget.state, threadId: 1),
          Terminal(state: widget.state, threadId: 2),
          Terminal(state: widget.state, threadId: 3)
        ];
        childAspectRatio = aspect;
        crossAxisCount = 2;
        break;
    }

    var grid = GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(10),
      childAspectRatio: childAspectRatio,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      crossAxisCount: crossAxisCount,
      children: terminals,
    );

    return Center(
      child: SizedBox(
        height: height, // Directly use passed height
        width: width,  // Directly use passed width
        child: grid
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terminal')),
      body: Row(
        children: [
          SidePanel(SidePanelPage.home, widget.state),
          Expanded(  // Make sure grid takes up remaining space
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                // Passing dimensions from constraints to the grid creation method
                return createTerminalGrid(constraints.maxWidth, constraints.maxHeight);
              },
            ),
          ),
        ],
      ),
    );
  }
}
