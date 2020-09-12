class Value {
  final String title;
  final List<Value> children;

  Value(this.title, this.children);

  @override
  String toString() {
    return title;
  }
}
