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
  Widget createTerminalGrid() {
    Layout layout = widget.state.globalSettings.getLayout();
    List<Widget> terminals;
    double childAspectRatio;
    int crossAxisCount;
    var size = MediaQuery.sizeOf(context);
    double aspect = size.width / size.height;
    int heightOffset = 0;
    int widthOffset = -100;
    switch (layout) {
      case Layout.oneByOne:
        terminals = [
          Terminal(state: widget.state, threadId: 0),
        ];
        childAspectRatio = aspect;
        crossAxisCount = 1;
      case Layout.oneByTwo:
        terminals = [
          Terminal(state: widget.state, threadId: 0),
          Terminal(state: widget.state, threadId: 1)
        ];
        childAspectRatio = aspect / 2;
        // heightOffset = 200;
        crossAxisCount = 2;
      case Layout.twoByOne:
        terminals = [
          Terminal(state: widget.state, threadId: 0),
          Terminal(state: widget.state, threadId: 1)
        ];
        childAspectRatio = aspect * 2;
        crossAxisCount = 1;
      case Layout.twoByTwo:
        childAspectRatio = aspect;
        crossAxisCount = 2;
        terminals = [
          Terminal(state: widget.state, threadId: 0),
          Terminal(state: widget.state, threadId: 1),
          Terminal(state: widget.state, threadId: 2),
          Terminal(state: widget.state, threadId: 3)
        ];
    }
    var grid = GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(10),
      childAspectRatio: childAspectRatio,
      mainAxisSpacing: 10, // Adjust vertical spacing
      crossAxisSpacing: 10, // Adjust horizontal spacing
      crossAxisCount: crossAxisCount,
      children: terminals,
    );

    return Center(
        child: SizedBox(
            height: size.height + heightOffset,
            width: size.width + widthOffset,
            child: grid));
  }

  // TODO: GridViews are scrollable which we don't really want

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('terminal')),
      body: Row(
        children: [
          SidePanel(SidePanelPage.home, widget.state),
          createTerminalGrid()
        ],
      ),
    );
  }
}
