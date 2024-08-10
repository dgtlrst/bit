enum Layout { oneByOne, oneByTwo, twoByOne, twoByTwo }

class GlobalSettings {
  bool _warnings = true;
  Layout _layout = Layout.oneByTwo;

  Layout getLayout() {
    return _layout;
  }

  void setLayout(Layout layout) {
    _layout = layout;
  }

  bool getWarnings() {
    return _warnings;
  }

  void setWarnings(bool warnings) {
    _warnings = warnings;
  }
}
