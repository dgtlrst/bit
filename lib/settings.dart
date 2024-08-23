import 'package:bit/state_globals.dart';
import 'package:bit/state_app.dart';
import 'package:flutter/material.dart';
import 'sidepanel.dart';

class Settings extends StatefulWidget {
  final AppState state;
  const Settings({super.key, required this.state});
  @override
  State<Settings> createState() => _CreateSettingsState();
}

class _CreateSettingsState extends State<Settings> {
  Column layoutDropdown() {
    List<DropdownMenuItem<Layout>> layouts = Layout.values.map((v) {
      return DropdownMenuItem<Layout>(value: v, child: Text(v.name));
    }).toList();
    var layout_btn = DropdownButton(
        hint: Text('Layout'),
        value: widget.state.globalSettings.getLayout(),
        items: layouts,
        onChanged: (value) {
          setState(() {
            widget.state.globalSettings.setLayout(value!);
          });
        });

    Column layout_group = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Center(
          child: Row(children: [
            Text("Layout"),
            Tooltip(
                message:
                    "Connected Terminals will continue running in the background even if you change the layout.\n Disconnect first if you want to permanently switch layout to avoid unnecessary resource consumption.",
                child: Icon(Icons.info_outline))
          ]),
        ),
        layout_btn
      ],
    );
    return layout_group;
  }

  Column enableTerminalWarningsTickBox() {
    var title = Text("Enable Terminal Warnings");
    var tickbox = Checkbox.adaptive(
      value: widget.state.globalSettings.getWarnings(),
      onChanged: (value) {
        setState(() {
          if (value == true) {
            widget.state.globalSettings.setWarnings(true);
          } else {
            widget.state.globalSettings.setWarnings(false);
          }
        });
      },
    );
    return Column(
      children: [title, tickbox],
    );
  }

  GridView settingsGrid() {
    return GridView.count(
      padding: const EdgeInsets.all(20),
      childAspectRatio: 5 / 2,
      mainAxisSpacing: 10, // Adjust vertical spacing
      crossAxisSpacing: 20, // Adjust horizontal spacing
      crossAxisCount: 4,
      children: [layoutDropdown(), enableTerminalWarningsTickBox()],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('settings')),
      body: Row(
        children: [
          // main content
          SidePanel(SidePanelPage.settings, widget.state),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: settingsGrid(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
