import 'package:bit/state_app.dart';
import 'package:flutter/material.dart';
import 'settings.dart';

enum SidePanelPage {
  home,
  settings,
}

class SidePanel extends StatelessWidget {
  const SidePanel(this.page, this.state, {super.key});
  final SidePanelPage page;
  final AppState state;

  void goToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Settings(state: state)),
    );
  }

  void goHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (route) => false,
    );
  }

  List<Widget> getButtons(BuildContext context) {
    const Color buttonColor = Color(0xFF2C474D); // button color
    const Color buttonTextColor =
        Color.fromARGB(255, 113, 169, 180); // button text color

    List<Widget> buttons = [];

    switch (page) {
      case SidePanelPage.home:
        buttons.add(
          ElevatedButton(
            onPressed: () {
              goToSettings(context);
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(buttonColor),
            ),
            child: const Text('settings',
                style: TextStyle(color: buttonTextColor)),
          ),
        );
        break;

      case SidePanelPage.settings:
        buttons.add(
          ElevatedButton(
            onPressed: () {
              goHome(context);
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(buttonColor),
            ),
            child: const Text('home', style: TextStyle(color: buttonTextColor)),
          ),
        );
        break;
    }

    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    const Color sidePanelColor =
        Color(0xFF21202B); // side panel background color

    // side panel
    var sideBar = Container(
      width: 100,
      color: sidePanelColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: getButtons(context),
      ),
    );
    return sideBar;
  }
}
